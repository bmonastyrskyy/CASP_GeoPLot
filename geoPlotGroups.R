#!/usr/bin/Rscript

# author : Bohdan Monastyrskyy
# date   : 11/22/2014
# description:
#   the script generates statistics regarding the perfomance of the groups
#   participating in CASP in RR category;
#   the data are fetched from predictioncenter.org database="predictioncenter"
#      tables="casp11.groups,accounts"
#   so make sure that you have uploaded the data through the web-interface


# load libraries
require(RPostgreSQL);
require(plyr);
require(ggplot2);

# load iuser-defined libraries
source("functions/GroupsUtils.R");
source("functions/Utils.R");

# set up database driver
drv <- dbDriver("PostgreSQL")

# set db connector
con <- dbConnect(drv, host='128.120.136.187', user='predictioncenter', dbname='predictioncenter')

gr_info <- getGroupsIPs(con, 'casp11')

geoip <- sapply(gr_info$ip, freegeoip)

gr_info$longit <- as.numeric(as.character(geoip$longitude))
gr_info$latit <- as.numeric(as.character(geoip$latitude))

write.csv(gr_info, "casp11.geo_data.txt", quote=FALSE, row.names=FALSE)


