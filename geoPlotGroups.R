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


# load CRAN packageslibraries
packs <- c("RPostgreSQL", "dplyr", "ggplot2", "maps", "mapdata", "maptools")
for (p  in packs){
  if (!require(p, character.only = TRUE)){
    install.packages(p);
    if (!require(p, character.only = TRUE)){
      stop(paste0("failed to load required package: ", p))
    }
  }
}

# load user-defined libraries
source("functions/GroupsUtils.R");
source("functions/Utils.R");

# load config.R
# the variables related to database: HOST_IP, DB_USER, DB_NAME
source("config.R")

# ---------------------------------------------------
# RETRIEVE DATA
# 
# retrieve data from database at predictioncenter.org
# and write data.frame to file 
# ---------------------------------------------------

# set up database driver
drv <- dbDriver("PostgreSQL")

# set db connector
con <- dbConnect(drv, host=HOST_IP, user=DB_USER, dbname=DB_NAME)
# fetch data from database

gr_info <- getGroupsIPs(con, CASP)
# search the geolocation by ip
geoip <- sapply(gr_info$ip, FUN=ipinfo)

gr_info <- unique(merge(gr_info, geoip, by=c("ip"))

write.csv(gr_info, paste0("data/",CASP,".geo_data.txt", quote=FALSE, row.names=FALSE)

# ---------------------------------------------------
# END RETRIEVE DATA
# ---------------------------------------------------
