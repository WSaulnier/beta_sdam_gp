library(tidyverse)
library(prism)
# library(raster) #Avoid conflicts with plyr and do not load. Call directly instead. #Can we replace with exactextractr?
# library(exactextractr) #Avoid conflicts with plyr and do not load. Call directly instead.
library(randomForest)
library(sf)
library(rgdal)

#Load final simplified RF models
load("NotForGit/5.0_Model Refinement/SnowDomModel_Simplified.Rdata")
load("NotForGit/5.0_Model Refinement/NonSnowDomModel_Simplified.Rdata")

#Required predictors to run the model
SnowDomModel_Simplified_varz<-SnowDomModel_Simplified$importance %>% row.names()
NonSnowDomModel_Simplified_varz<-NonSnowDomModel_Simplified$importance %>% row.names()


#Required inputs from user, needed to generate required predictors
#Use these to determine if the user has supplied all the rquired information
SnowDomModel_Simplified_varz_required<-c("lat","lon","perennial_taxa", "TotalAbundance" ,"perennial_abundance","BankWidthMean","alglivedead_cover_score")
NonSnowDomModel_Simplified_varz_required<-c("lat","lon","DifferencesInVegetation_score","alglivedead_cover_score","Sinuosity_score","fishabund_score2","BankWidthMean","mayfly_abundance","perennial_taxa")

#Load snow persistence raster
snowp_raster<-raster::raster('NotForGit/shapefiles/SnowPersistence/mod10a2_sci_AVG_v2_Match.tif' )


#Get data from user

#Required for all sites
user_lat<- 34.112788
user_lon<- -116.833940
user_perennial_taxa<-2 #Any value but binned at 0, 1, 2, 3+
user_perennial_abundance<-10 #Any value but binned at 0, 1-6, 7+. Only needed for snow dom.
user_BankWidthMean<-3 #Any value. For SnowDom, binned at <2, 2-6, 6+.
user_fishabund_score2<-0 #For NonSnowDom only. Values at 0, 1, 2, 3
user_mayfly_abundance<-16 #For NonSnowDom. Binned at 0, 1-5, 6-10, 11-5, 16+
user_alglivedead_cover_score<-2 #For both. Values at 0, 1, 2, 3
user_DifferencesInVegetation_score<-3  #For NonSnowDom only. Values at 0, 1, 2, 3
user_Sinuosity_score<-1 #For NonSnowDom only. Values at 0, 1, 2, 3
user_TotalAbundance<-50 #For SnowDom only. Binned at 0, 1-19, 20+
user_hydric<-1 #For NonSnowDom. Values at 0 and 1


user_df<-tibble(lat=user_lat,
                lon=user_lon,
                TotalAbundance=user_TotalAbundance,
                perennial_abundance=user_perennial_abundance,
                perennial_taxa=user_perennial_taxa,
                mayfly_abundance=user_mayfly_abundance,
                fishabund_score2=user_fishabund_score2,
                alglivedead_cover_score=user_alglivedead_cover_score,
                DifferencesInVegetation_score=user_DifferencesInVegetation_score,
                BankWidthMean=user_BankWidthMean,
                Sinuosity_score=user_Sinuosity_score,
                SI_Hydric=user_hydric
                ) 


Beta_SDAM_WM<-function(df){
  #Add a check to see if site is in WM area. If in PNW area or AW area (or GP, or NESE?), return with URL to appropriate resources.
  #If outside all possible regions, return "Site is outside region where the EPA has developed streamflow duration assessment methods.

  #Move the snow persistence calcs here
  #Once you determine which model you need (snow dominated vs. non-snow dominated), 
  #perform a check to see that all required predictors are in df.
  #If not, return an error indicating which predictors are missing.

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
  
  #Calculate GIS metrics
  #Calculate mean snow persistence within 10 km
  snowp_raster<-raster::raster('NotForGit/shapefiles/SnowPersistence/mod10a2_sci_AVG_v2_Match.tif' )
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
  
  #Calculate May and October precipitation
  prism_set_dl_dir("~/prism")
  get_prism_normals(type="tmax", resolution="800m", keepZip = F, annual = T)
  get_prism_normals(type="ppt", resolution="800m", keepZip = F, mon=c(5,10))
  #Suppress warnings here
  tmax_RS<-pd_stack("PRISM_tmax_30yr_normal_800mM2_annual_bil")
  proj4string(tmax_RS)<-CRS("+proj=longlat +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")
  ppt.m05_RS<-pd_stack("PRISM_ppt_30yr_normal_800mM2_05_bil")
  proj4string(ppt.m05_RS)<-CRS("+proj=longlat +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")
  ppt.m10_RS<-pd_stack("PRISM_ppt_30yr_normal_800mM2_10_bil")
  proj4string(ppt.m10_RS)<-CRS("+proj=longlat +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")
  
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
  if(xsf$SnowDom_SP10=="Snow-dominated")
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
  xdf
  
}


sdam_classification<-Beta_SDAM_WM(user_df) 


####Example output

print(paste("Reach is:",sdam_classification$SnowDom_SP10))
print(paste("Reach is classified as:", sdam_classification$Class_final))


#Tests
