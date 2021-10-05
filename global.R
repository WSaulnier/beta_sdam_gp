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

# Need to specify background color for spinner
options(spinner.color="#0275D8", spinner.color.background="#ffffff", spinner.size=0.5)

#Load final simplified RF models
load("data/5.0_Model Refinement/SnowDomModel_Simplified.Rdata")
load("data/5.0_Model Refinement/NonSnowDomModel_Simplified.Rdata")

#Required predictors to run the model
SnowDomModel_Simplified_varz<-SnowDomModel_Simplified$importance %>% row.names()
NonSnowDomModel_Simplified_varz<-NonSnowDomModel_Simplified$importance %>% row.names()


#Required inputs from user, needed to generate required predictors
#Use these to determine if the user has supplied all the rquired information
SnowDomModel_Simplified_varz_required<-c("lat","lon","perennial_taxa", "TotalAbundance" ,"perennial_abundance","BankWidthMean","alglivedead_cover_score")
NonSnowDomModel_Simplified_varz_required<-c("lat","lon","DifferencesInVegetation_score","alglivedead_cover_score","Sinuosity_score","fishabund_score2","BankWidthMean","mayfly_abundance","perennial_taxa")

#Load snow persistence raster
snowp_raster<-raster::raster('data/shapefiles/SnowPersistence/mod10a2_sci_AVG_v2_Match.tif' )


Beta_SDAM_WM<-function(
      user_model_choice='sno',
      user_lat=0, user_lon=0, user_TotalAbundance=0, user_perennial_abundance=0, user_perennial_taxa=0, user_mayfly_abundance=0, user_fishabund_score2=0,
      user_alglivedead_cover_score=0, user_DifferencesInVegetation_score=0, user_BankWidthMean=0.5 , user_Sinuosity_score=0, user_hydric=0
){
  #Add a check to see if site is in WM area. If in PNW area or AW area (or GP, or NESE?), return with URL to appropriate resources.
  #If outside all possible regions, return "Site is outside region where the EPA has developed streamflow duration assessment methods.
  
  #Move the snow persistence calcs here
  #Once you determine which model you need (snow dominated vs. non-snow dominated), 
  #perform a check to see that all required predictors are in df.
  #If not, return an error indicating which predictors are missing.
  
  print("user_TotalAbundance")
  print(ifelse(is.null(user_TotalAbundance), "Null", "Not Null"))
  
  df<-tibble(lat=ifelse(is.null(user_lat), 0,user_lat ),
                  lon=ifelse(is.null(user_lon), 0,user_lon),
                  TotalAbundance=ifelse(is.null(user_TotalAbundance), 0,user_TotalAbundance),
                  perennial_abundance=ifelse(is.null(user_perennial_abundance), 0,user_perennial_abundance),
                  perennial_taxa=ifelse(is.null(user_perennial_taxa), 0,user_perennial_taxa),
                  mayfly_abundance=ifelse(is.null(user_mayfly_abundance), 0,user_mayfly_abundance),
                  fishabund_score2=ifelse(is.null(user_fishabund_score2), 0,user_fishabund_score2),
                  alglivedead_cover_score=ifelse(is.null(user_alglivedead_cover_score), as.double(0),as.double(user_alglivedead_cover_score)),
                  DifferencesInVegetation_score=ifelse(is.null(user_DifferencesInVegetation_score), 0,user_DifferencesInVegetation_score),
                  BankWidthMean=ifelse(is.null(user_BankWidthMean), 0.5 ,user_BankWidthMean),
                  Sinuosity_score=ifelse(is.null(user_Sinuosity_score), 0,user_Sinuosity_score),
                  SI_Hydric=ifelse(is.null(user_hydric), 0,user_hydric)
  ) 
  
  
  
  df2<-df%>%
    #Convert continuous data to categories
    mutate(PerennialTaxa_cat = case_when(perennial_taxa==0~0,
                                         perennial_taxa<=1~1,
                                         perennial_taxa<=2~2,
                                         T~3),
           TotalAbundance_cat = case_when(TotalAbundance==0~0,
                                          TotalAbundance<20~1, #Same as AW
                                          T~2),
           PerennialAbundance_cat = case_when(perennial_abundance==0~0,
                                              perennial_abundance<=6~1,
                                              T~2),
           BankWidth_cat = case_when(BankWidthMean<2~0,
                                     BankWidthMean<6~1,
                                     T~2),
           Algae_cat = case_when(alglivedead_cover_score<=2~2,
                                 T~alglivedead_cover_score),
           mayfly_cat= case_when(mayfly_abundance==0~0,
                                 mayfly_abundance<=5~1,
                                 mayfly_abundance<=10~2,
                                 mayfly_abundance<=15~3,
                                 T~4),
           SI_Fish = case_when(fishabund_score2>0~1,T~0),
           SI_Algae = case_when(alglivedead_cover_score>1~1,T~0),
           SI_Hydric=SI_Hydric
    )
  

  
  #Calculate May and October precipitation
  prism_set_dl_dir("data/prism")
  #get_prism_normals(type="tmax", resolution="800m", keepZip = F, annual = T)
  #get_prism_normals(type="ppt", resolution="800m", keepZip = F, mon=c(5,10))
  #Suppress warnings here
  tmax_RS<-pd_stack("PRISM_tmax_30yr_normal_800mM2_annual_bil")
  proj4string(tmax_RS)<-CRS("+proj=longlat +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")
  ppt.m05_RS<-pd_stack("PRISM_ppt_30yr_normal_800mM2_05_bil")
  proj4string(ppt.m05_RS)<-CRS("+proj=longlat +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")
  ppt.m10_RS<-pd_stack("PRISM_ppt_30yr_normal_800mM2_10_bil")
  proj4string(ppt.m10_RS)<-CRS("+proj=longlat +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")

  
  xsf<-df2 %>%
    st_as_sf(coords=c("lon", "lat"),
             remove=F,
             crs=4326) %>%
    st_transform(crs=32611) %>%
    st_buffer(10000) %>%
    st_transform(crs=st_crs(snowp_raster))
  #Suppress warnings here
  xsf$MeanSnowPersistence_10=exactextractr::exact_extract(x=snowp_raster, y=xsf, 'mean')
  xsf$SnowDom_SP10=case_when(xsf$MeanSnowPersistence_10<25~"Not snow-dominated",T~"Snow-dominated")
  
  
  mydf_prism<-bind_cols(
    raster::extract(tmax_RS, xsf, fun=mean, na.rm=T, sp=F) %>% as.data.frame() %>% dplyr::rename(tmax = 1),
    raster::extract(ppt.m05_RS, xsf, fun=mean, na.rm=T, sp=F) %>% as.data.frame() %>% dplyr::rename(ppt.m05 = 1),
    raster::extract(ppt.m10_RS, xsf, fun=mean, na.rm=T, sp=F) %>% as.data.frame() %>% dplyr::rename(ppt.m10 = 1)
  )
  
  
  #Combine data sets
  xdf<-xsf %>%
    bind_cols(mydf_prism) %>%
    as.data.frame() %>%
    dplyr::select(-geometry) 
  
  
  
  #Apply appropriate random forest model
  if(user_model_choice == 'sno')
    ClassProbs = predict(SnowDomModel_Simplified, newdata = xdf, type="prob") %>% as.data.frame()
  else
    ClassProbs = predict(NonSnowDomModel_Simplified, newdata = xdf, type="prob") %>% as.data.frame()
  
  #Classify results based on predicted probabilities of class membership
  xdf<- bind_cols(xdf, ClassProbs) %>%
    mutate(ALI = I + P,
           Class = case_when(P>=.5~"Perennial",
                             I>=.5~"Intermittent",
                             E>=0.5~"Ephemeral",
                             ALI >= 0.5 ~ "At least intermittent",
                             T~"Need more information"),
           #Modify classification based on single indicators
           SingleIndicator = case_when(SI_Hydric>0~1,
                                       SI_Fish>0~1,
                                       SI_Algae>0~1,
                                       T~0),
           Class_final = case_when(Class %in% c("Ephemeral","Need more information") & SingleIndicator==1~"At least intermittent",
                                   T~Class))
  xdf$Class_final
  
}

snowdom <- function(lat, lon){
  #Calculate GIS metrics
  #Calculate mean snow persistence within 10 km
  
  df <- data.frame(lat = lat, lon = lon)
  # df <- data.frame(lat = 40.8, lon = -124)
  # df <- data.frame(lat = 0, lon = 0)
  
  snowp_raster<-raster::raster('data/shapefiles/SnowPersistence/mod10a2_sci_AVG_v2_Match.tif')
  wm_strata <- st_read('data/shapefiles/WM_Strata.shp') 
  
  ysf<-df %>%
    st_as_sf(coords=c("lon", "lat"),
             remove=F,
             crs=4326) %>%
    st_transform(crs=st_crs(wm_strata)) %>% 
    st_join(wm_strata, join = st_within)
  
  in_wm <- ifelse(is.na(ysf$Region), F, T)
  
  
  
  xsf<-df %>%
    st_as_sf(coords=c("lon", "lat"),
             remove=F,
             crs=4326) %>%
    st_transform(crs=32611) %>%
    st_buffer(10000) %>%
    st_transform(crs=st_crs(snowp_raster))
  #Suppress warnings here
  xsf$MeanSnowPersistence_10=exactextractr::exact_extract(x=snowp_raster, y=xsf, 'mean')
  xsf$SnowDom_SP10=case_when(
    is.na(xsf$MeanSnowPersistence_10) ~ "Outside snow raster",
    xsf$MeanSnowPersistence_10 < 25 ~ "Not snow influenced",
    T ~ "Snow influenced"
  )
  
  sno_inf <- xsf$SnowDom_SP10
  
  # Get May and October Precipitation
  prism_set_dl_dir("data/prism")
  #get_prism_normals(type="tmax", resolution="800m", keepZip = F, annual = T)
  #get_prism_normals(type="ppt", resolution="800m", keepZip = F, mon=c(5,10))
  #Suppress warnings here
  tmax_RS<-pd_stack("PRISM_tmax_30yr_normal_800mM2_annual_bil")
  proj4string(tmax_RS)<-CRS("+proj=longlat +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")
  ppt.m05_RS<-pd_stack("PRISM_ppt_30yr_normal_800mM2_05_bil")
  proj4string(ppt.m05_RS)<-CRS("+proj=longlat +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")
  ppt.m10_RS<-pd_stack("PRISM_ppt_30yr_normal_800mM2_10_bil")
  proj4string(ppt.m10_RS)<-CRS("+proj=longlat +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")
  
  # More stuff for May and Oct precip
  mydf_prism<-bind_cols(
    raster::extract(tmax_RS, xsf, fun=mean, na.rm=T, sp=F) %>% as.data.frame() %>% dplyr::rename(tmax = 1),
    raster::extract(ppt.m05_RS, xsf, fun=mean, na.rm=T, sp=F) %>% as.data.frame() %>% dplyr::rename(ppt.m05 = 1),
    raster::extract(ppt.m10_RS, xsf, fun=mean, na.rm=T, sp=F) %>% as.data.frame() %>% dplyr::rename(ppt.m10 = 1)
  )
  
  
  if (sno_inf == 'Outside snow raster') {
    return(
      list(
        canrun = F,
        msg = HTML('<strong>Warning</strong>: Site is outside the project area. Site cannot be assessed'),
        mod = character(0)
      )
    )
  }
  
  if (in_wm) {
    
    xdf <- xsf %>%
      bind_cols(mydf_prism) %>%
      as.data.frame() %>%
      dplyr::select(-geometry) %>%
      mutate(
        TotalAbundance=0,
        perennial_abundance=0,
        perennial_taxa=0,
        mayfly_abundance=0,
        fishabund_score2=0,
        alglivedead_cover_score=0,
        DifferencesInVegetation_score=0,
        BankWidthMean=0,
        Sinuosity_score=0,
        SI_Hydric=0,
        PerennialTaxa_cat = 0,
        TotalAbundance_cat = 0,
        PerennialAbundance_cat = 0,
        BankWidth_cat = 0,
        Algae_cat = 0,
        mayfly_cat= 0,
        SI_Fish = 0,
        SI_Algae = 0
      )
    
    if (xsf$MeanSnowPersistence_10 == "Not snow influenced") {
      ClassProbs = predict(NonSnowDomModel_Simplified, newdata = xdf, type="prob") %>% as.data.frame()
      modchoice <- 'nosno'
    }
    else {
      ClassProbs = predict(SnowDomModel_Simplified, newdata = xdf, type="prob") %>% as.data.frame()
      modchoice <- 'sno'
    }
    
    xdf <- bind_cols(xdf, ClassProbs) %>%
      mutate(ALI = I + P,
             Class = case_when(P>=.5~"Perennial",
                               I>=.5~"Intermittent",
                               E>=0.5~"Ephemeral",
                               ALI >= 0.5 ~ "At least intermittent",
                               T~"Need more information"),
             #Modify classification based on single indicators
             SingleIndicator = case_when(SI_Hydric>0~1,
                                         SI_Fish>0~1,
                                         SI_Algae>0~1,
                                         T~0),
             Class_final = case_when(Class %in% c("Ephemeral","Need more information") & SingleIndicator==1~"At least intermittent",
                                     T~Class))
    
    msg <- paste0(
      "<h5>",
      "<p>This reach is <strong>{sno_inf}</strong></p><br>",
      "<p>Snow persistence is {round(xsf$MeanSnowPersistence_10, 1)}</p><br>",
      "<p>October precipitation (mm): {round(mydf_prism$ppt.m10, 1)}</p><br>",
      "<p>May precipitation (mm): {round(mydf_prism$ppt.m05, 1)}</p><br>",
      "<p>Mean annual max temperature (Deg C): {round(mydf_prism$tmax, 1)}</p><br>"
    )
    
    if (xdf$Class_final %in% c('Intermittent','At least intermittent','Perennial')) {
      msg <- paste0(msg, '<p>Reach is likely at least intermittent based on climatic conditions alone</p>')
    }
    
    msg <- paste0(msg, '</h5>')
    
    return(
      list(
        canrun = T,
        msg = glue::glue(
          HTML(msg)
        ),
        mod = modchoice
      )
    )
  } else {
    return(
      list(
        canrun = T,
        msg = HTML("<strong>Warning</strong>: Site is outside the Western Mountains. Classifications for the Beta SDAM WM are presented for informational purposes only."),
        mod = character(0)
      )
    )
  }
  
}
