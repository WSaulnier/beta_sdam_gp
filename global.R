library(tidyverse)
library(prism)
# library(raster) #Avoid conflicts with plyr and do not load. Call directly instead. #Can we replace with exactextractr?
# library(exactextractr) #Avoid conflicts with plyr and do not load. Call directly instead.
library(randomForest)
library(sf)
library(rgdal)
library(shiny)
library(shinycssloaders)
library(shinycustomloader)
library(shinyWidgets)
library(formatR)
library(shinyjs)
library(magrittr)
library(rslates)
library(leaflet)
library(leaflet.extras)
library(dataRetrieval)
# Load the final RF model
RF_v8 <- readRDS("./model/RF_V8_rmGOLDOCH_StratUNC.rds")

# Required predictors for model
predictors <- row.names(RF_v8$importance)


# Load shapefile with regions
# regions <- read_sf("./spatial/Major_SDAM_regions.shp") %>%
#         st_transform(crs = 4326)
# light weight version of regions shapefile to speed up leaflet rendering
regions_leaflet <- read_sf("./spatial/simplified_regions.shp")



Beta_SDAM_GP <- function(
        user_lat = 0,
        user_lon = 0,
        user_SubstrateSorting_score = 0,
        user_Sinuosity_score = 1,
        user_UplandRootedPlants_score = 0,
        user_ChannelDimensions_score = 0,
        user_BankWidthMean = 0,
        user_EPT_taxa = 0,
        user_Hydrophyte_total = 0,
        user_PctShade = 0,
        var_input_reg = NA
){
        # Add a check to see if the user supplied point is inside the Great Plains regions.
        # Determine the regions based on the lat/long of the supplied point.
        if (var_input_reg == 'No Region'){
            
            df <- tibble(lat = user_lat,
                         lon = user_lon,
                         SubstrateSorting_score = user_SubstrateSorting_score,
                         Sinuosity_score = user_Sinuosity_score,
                         UplandRootedPlants_score = user_UplandRootedPlants_score,
                         ChannelDimensions_score = user_ChannelDimensions_score,
                         BankWidthMean = user_BankWidthMean,
                         EPT_taxa = user_EPT_taxa,
                         Hydrophyte_total = user_Hydrophyte_total,
                         PctShading = user_PctShade
                         )
            # Create the bin variables for the model
            df %<>%
                    mutate(BankWidth_cat = case_when(BankWidthMean<20~0, T~1),
                           PctShad_bin= case_when(PctShading<0.1~0, T~1),
                           EPT_bin= case_when(EPT_taxa<2~0, T~1),
                           hydrophyte_cat = case_when(Hydrophyte_total<2~0,T~1)
                    )
                           
            # check to see if user supplied lat/long is in Great Plains regions
            pnts_df <- sf::st_as_sf(df, coords = c("lon", "lat"), crs = 4326, remove = FALSE)
            pnts_join_df <- sf::st_join(pnts_df, regions_leaflet) %>%
                    rename(Strata_UNC = region)
            
            # if user supplied location is outside of study regions, return an error message
            # otherwise continue to RF model
            if (is.na(pnts_join_df$Strata_UNC)){
                    spatial_msg <- paste0(
                            "<h5>",
                            "<p>The location of your site is outside of the SDAM Study areas.<p><br>",
                            "<p>Please check your latitude and longitude coordinates to ensure they are entered correctly.<p><br>"
                    )
                    print(spatial_msg)
            
            } else {
                    # apply random forest model to user supplied data
                    ClassProbs <- predict(RF_v8, newdata = pnts_join_df, type="prob") %>% as.data.frame()
                    # assign appropriate class based on probabilities
                    output_df <- bind_cols(pnts_join_df, ClassProbs) %>%
                            mutate(ALI = I + P,
                                    Class = case_when(P>=.5~"perennial",
                                                      I>=.5~"intermittent",
                                                      E>=0.5~"ephemeral",
                                                      ALI >= 0.5 ~ "at least intermittent",
                                                      T~"Need more information")
                                    )
                    print(glue::glue("User Supplied Coordinates: '{output_df$Strata_UNC}'"))
                    paste0("This reach is classified as ", output_df$Class)
            }
        } else {
            print(glue::glue("User Supplied Region '{var_input_reg}'"))
            df <- tibble(lat = user_lat,
                         lon = user_lon,
                         SubstrateSorting_score = user_SubstrateSorting_score,
                         Sinuosity_score = user_Sinuosity_score,
                         UplandRootedPlants_score = user_UplandRootedPlants_score,
                         ChannelDimensions_score = user_ChannelDimensions_score,
                         BankWidthMean = user_BankWidthMean,
                         EPT_taxa = user_EPT_taxa,
                         Hydrophyte_total = user_Hydrophyte_total,
                         PctShading = user_PctShade,
                         Strata_UNC = var_input_reg
            )
            # Create the bin variables for the model
            df %<>%
                mutate(BankWidth_cat = case_when(BankWidthMean<20~0, T~1),
                       PctShad_bin= case_when(PctShading<0.1~0, T~1),
                       EPT_bin= case_when(EPT_taxa<2~0, T~1),
                       hydrophyte_cat = case_when(Hydrophyte_total<2~0,T~1)
                )
            
            # # check to see if user supplied lat/long is in Great Plains regions
            # pnts_df <- sf::st_as_sf(df, coords = c("lon", "lat"), crs = 4326, remove = FALSE)
            # pnts_join_df <- sf::st_join(pnts_df, regions) %>%
            #     rename(Strata_UNC = region)
            # 
            # # if user supplied location is outside of study regions, return an error message
            # # otherwise continue to RF model
            # if (is.na(pnts_join_df$Strata_UNC)){
            #     spatial_msg <- paste0(
            #         "<h5>",
            #         "<p>The location of your site is outside of the SDAM Study areas.<p><br>",
            #         "<p>Please check your latitude and longitude coordinates to ensure they are entered correctly.<p><br>"
            #     )
            #     print(spatial_msg)
            #     
            # } else {
                # apply random forest model to user supplied data
                ClassProbs <- predict(RF_v8, newdata = df, type="prob") %>% as.data.frame()
                # assign appropriate class based on probabilities
                output_df <- bind_cols(df, ClassProbs) %>%
                    mutate(ALI = I + P,
                           Class = case_when(P>=.5~"perennial",
                                             I>=.5~"intermittent",
                                             E>=0.5~"ephemeral",
                                             ALI >= 0.5 ~ "at least intermittent",
                                             T~"Need more information")
                    )
                
                paste0("This reach is classified as ", output_df$Class)
            }
        
}

point_region <- function(
        user_lat = 0,
        user_lon = 0
){
        df <- tibble(lat = user_lat,
                     lon = user_lon)
        # check to see if user supplied lat/long is in Great Plains regions
        pnts_df <- sf::st_as_sf(df, coords = c("lon", "lat"), crs = 4326, remove = FALSE)
        pnts_join_df <- sf::st_join(pnts_df, regions_leaflet) 
        # if (is.na(pnts_join_df$region)){
        #         spatial_msg <- paste0(
        #                 "<h5>",
        #                 "<p>The location of your site is outside of the SDAM study areas.<p><br>",
        #                 "<p>Please check your latitude and longitude coordinates to ensure they are entered correctly.<p><br>"
        #         )
        #         print(spatial_msg)
        # } else {
        # 
        #         pnts_join_df
        # }
        pnts_join_df
        
}




        
        


        
        