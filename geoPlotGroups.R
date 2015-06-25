#!/usr/bin/Rscript


# Description:
#   the script generates statistics regarding the geolocation of the groups
#   participating in CASP ;
#   the data are fetched from predictioncenter.org database="predictioncenter"
#      tables="casp11.groups,accounts"
#   
################################################
# Author : Bohdan Monastyrskyy
# Date   : 11/22/2014


# load CRAN libraries
libs <- c("RPostgreSQL", "dplyr", "ggplot2", "maps", 
          "mapdata", "maptools", "rworldmap", 
          "RCurl", "ggmap");
for (p  in libs){
  if (!require(p, character.only = TRUE)){
    install.packages(p);
    if (!require(p, character.only = TRUE)){
      stop(paste0("failed to load required package: ", p));
    }
  }
}

# load user-defined libraries
source("functions/GroupsUtils.R");
source("functions/Utils.R");

# load config.R
# the variables related to database: HOST_IP, DB_USER, DB_NAME, CASP
source("config.R")

# ---------------------------------------------------
# try to read data from file
# ---------------------------------------------------
dataFile <- paste0("data/",CASP,".geo_data.txt")
skipDB <- FALSE # boolean flag to avoid retrieving data from DB
if (file.exists(dataFile)){
  skipDB <- TRUE
}

# ---------------------------------------------------
# RETRIEVE DATA FROM DB
# 
# retrieve data from database at predictioncenter.org
# and write data.frame to file 
# ---------------------------------------------------
if (! skipDB ){
# set up database driver
drv <- dbDriver("PostgreSQL")

# set db connector
con <- dbConnect(drv, host=HOST_IP, user=DB_USER, 
                 dbname=DB_NAME)
# fetch data from database

gr_info <- getGroupsIPs(con, CASP)
# search the geolocation by ip
geoip <- ipinfo(unique(gr_info$ip), format="dataframe")

gr_info <- merge(gr_info, geoip, by=c("ip"))

write.csv(gr_info, dataFile, 
          quote=FALSE, row.names=FALSE)
}
# ---------------------------------------------------
# END RETRIEVE DATA FROM DB
# ---------------------------------------------------

gr_info <- read.csv(dataFile, 
                    header=TRUE, stringsAsFactors=FALSE)
worldMap <- borders("world", colour="grey60", fill="grey70" )
mp <- ggplot() + worldMap
mp <- mp + geom_jitter(data=gr_info, aes(x=longit, y=latit), size = 3, color="red", position = position_jitter(width = 0.4, height = .4))
print(mp)

