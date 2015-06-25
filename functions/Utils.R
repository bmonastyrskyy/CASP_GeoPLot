# This R function uses the free freegeoip.net geocoding 
# service to resolve an IP address (or a vector of them) 
# into country, region, city, zip, latitude, longitude, 
# area and metro codes.
# Author: Heuristic Andrew (thank you)
freegeoip <- function(ip, format = ifelse(length(ip)==1,'list','dataframe'))
{
  # load required libraries
  if (require("rjson") != 1){
    install.packages("rjson")
    require("rjson")
  }
  # if a single IP address  
  if (1 == length(ip)){        
    url <- paste(c("http://freegeoip.net/json/", ip), collapse='')
    result <- fromJSON(readLines(url, warn=FALSE))
    if (format == 'dataframe'){
          result <- data.frame(result)
    }
    return(result)
  } else {
    ret <- data.frame()
    for (i in 1:length(ip)){
        r <- freegeoip(ip[i], format="dataframe")
        result <- rbind(result, r)
    }
    return(result)
  }
} 

try.ip <- function(ip){ 
  suppressWarnings(try(freegeoip(ip), silent = TRUE))
}

# another function to get latitude and longitude
# requires RCurl package
ipinfo <- function(ip, format="dataframe"){
  if (!require("RCurl")){
    tryCatch(
      {
        suppressWarnings(utils:install.packages("RCurl"))
      },
      warning = function(war){
        print(paste0("WARNING: ", war));
      },
      error = function(err){
        stop(paste0("load failed : ", "RCurl"));
      },
      finally = function(fin){
        # do nothing
      }
    );
    if (!require("RCurl")){
      stop(paste0("loading failed : " , "RCurl"));
    }
  }
  if (length(ip) == 1){
    res <- getURL(paste("http://ipinfo.io/",ip,"/loc", sep=""));
    #remove space symbols
    res <- gsub("[[:space:]]", "", res);
    if (res == "undefined"){
      res <- c(NA, NA)
    } else {
      res <- strsplit(res, split=',')[[1]];
    }
    names(res) <- c("latit", "longit")
    if (format == 'dataframe'){
      result <- data.frame(t(res));
      result$ip <- ip;
      result$latit <- as.numeric(result$latit);
      result$longit <- as.numeric(result$longit);
      return(result);
    }
    return(res);
  } else {
    result <- data.frame()
    for (ip1 in ip) {
      result <- rbind(result, ipinfo(ip1, "dataframe")); 
    }
    return(result);
  }
}
