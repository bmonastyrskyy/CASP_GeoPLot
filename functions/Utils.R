# This R function uses the free freegeoip.net geocoding 
# service to resolve an IP address (or a vector of them) 
# into country, region, city, zip, latitude, longitude, 
# area and metro codes.
freegeoip <- function(ip, format = ifelse(length(ip)==1,'list','dataframe'))
{
    if (1 == length(ip))
    {
        # a single IP address
        if (require("rjson") != 1){
		install.packages("rjson")
		require("rjason")
	}
        url <- paste(c("http://freegeoip.net/json/", ip), collapse='')
        ret <- fromJSON(readLines(url, warn=FALSE))
        if (format == 'dataframe')
            ret <- data.frame(ret)
        return(ret)
    } else {
        ret <- data.frame()
        for (i in 1:length(ip))
        {
            r <- freegeoip(ip[i], format="dataframe")
            ret <- rbind(ret, r)
        }
        return(ret)
    }
} 

try.ip <- function(ip){ 
  suppressWarnings(try(freegeoip(ip), silent = TRUE))
}
