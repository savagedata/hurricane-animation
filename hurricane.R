library(ggplot2)
library(png)
library(magrittr)
options(stringsAsFactors = FALSE) 

# Irma settings
coord_xmin <- -95
coord_xmax <- -28
coord_ymin <- 10
coord_ymax <- 40
date_x <- -56.5
date_y <- 38
savage_x <- -34.5
savage_y <- 10
hurricane_name <- "IRMA - "
folder_name <- "irma"
nhc_prefix <- "http://www.nhc.noaa.gov/archive/2017/al11/al112017.fstadv."
max_forecast_n <- 48
    
plot_hurricane <- function(file_name, hurricane_name, display_date, prediction_subset.df, track.df, current_track.df, current_winds){
    
    # scale hurricane icon to current windspeed
    x_width <- 3*current_winds/160
    y_height <- 2.5*current_winds/160
    
    # create ggplot object
    fig <- ggplot(data=prediction_subset.df, aes(x=long, y=lat)) + 
        geom_polygon(data=map_data("world"), aes(x=long, y=lat, group=group), colour="grey30", size=0.1, fill="darkolivegreen3") + 
        geom_polygon(data=map_data("state"), aes(x=long, y=lat, group=group), colour="grey30", size=0.1, fill="darkolivegreen3") + 
        geom_path(size=0.75, aes(group=n, alpha=n)) +
        geom_path(data=track.df, color="red") + 
        annotation_raster(readPNG("cyclone_1f300.png"), 
                      xmin=current_track.df$long-x_width, 
                      xmax=current_track.df$long+x_width, 
                      ymin=current_track.df$lat-y_height, 
                      ymax=current_track.df$lat+y_height,
                      interpolate=T) +
        annotate("text", x=date_x, y=date_y, vjust=0, hjust=0, size=8, label=paste0(hurricane_name, display_date)) + 
        annotate("text", x=savage_x, y=savage_y, vjust=0, hjust=0, size=5, label="@savagedata") + 
        theme(panel.background = element_rect(fill = 'lightblue1'),
              axis.title=element_blank(), axis.text=element_blank(),
              axis.ticks=element_blank(), legend.position="none") + 
        coord_cartesian(xlim = c(coord_xmin, coord_xmax), ylim = c(coord_ymin, coord_ymax)) 
    
    # print ggplot object to file
    png(file=file_name, width=800, heigh=450)
    print(fig)
    dev.off()
}

# create empty dataframes
track.df <- data.frame(forecast_n = numeric(),
                       forecast_date = character(),
                       lat = numeric(),
                       long = numeric(),
                       winds = numeric())
prediction.df <- data.frame(forecast_n = numeric(),
                            forecast_date = character(),
                            prediction_date = character(),
                            lat = numeric(),
                            long = numeric())

for(forecast_n in 1:max_forecast_n){
    print(forecast_n)
    
    # load NOAA forecast
    forecast <- readLines(paste0(nhc_prefix, formatC(forecast_n, width=3, format="d", flag="0"), ".shtml?"))
    
    # get current winds
    current_winds <- grep("MAX SUSTAINED WINDS .*", forecast, value=T) %>%
        gsub("MAX SUSTAINED WINDS *([0-9]*) KT.*", "\\1", .) %>%
        as.numeric
    
    # get location 3 hours before forecast
    current_track <- grep("AT ([0-9/Z]*) CENTER WAS LOCATED NEAR ([0-9\\.]*)(N|S) *([0-9\\.]*)(E|W)", forecast, value=T) %>%
        gsub("AT ([0-9/Z]*) CENTER WAS LOCATED NEAR ([0-9\\.]*)(N|S) *([0-9\\.]*)(E|W)", "\\1_\\2_\\3_\\4_\\5", .) %>%
        strsplit("_") %>%
        unlist
    
    # for the first forecast, use the current winds, otherwise average current and previous winds
    winds_3minus <- ifelse(forecast_n == 1, current_winds, (current_winds + track.df[track.df$forecast_n==forecast_n-1,"winds"])/2)
    
    # convert to dataframe
    current_track.df <- data.frame(forecast_n = forecast_n - 0.5,
                                   forecast_date = current_track[1], 
                                   lat = as.numeric(current_track[2])*ifelse(current_track[3]=="N", 1, -1),
                                   long = as.numeric(current_track[4])*ifelse(current_track[5]=="E", 1, -1),
                                   winds = winds_3minus)
    
    # update track with 3 minus location
    track.df <- rbind(track.df, current_track.df)
    
    # for the first forecast, use empty data frame to plot predictions
    if(forecast_n == 1){
        prediction_subset.df <- data.frame(forecast_n = numeric(), n = numeric(), forecast_date = character(),
                                           prediction_date = character(), lat = numeric(), long = numeric())   
    }
    
    # for the first forecast, get current date, otherwise use previous date
    display_date <- ifelse(forecast_n == 1,
                           gsub("([0-9]{1,2})00 UTC (.*) ([0-9]{4})", "\\2 \\1:00 UTC", 
                                grep("([0-9]{3,4}) UTC ([A-Z]*) ([A-Z]*) ([0-9]*) ([0-9]{4})", forecast, value=T)),
                           display_date)
    
    # plot 3 minus
    plot_hurricane(file_name=paste0(folder_name, "/", formatC(forecast_n-1, width=2, format="d", flag ="0"), "5.png"), 
                   hurricane_name, display_date, prediction_subset.df, track.df, current_track.df, current_winds)
        
    # get current location
    current_track <- grep("REPEAT...CENTER LOCATED NEAR .*", forecast, value=T) %>%
        gsub(".* NEAR ([0-9\\.]*)(N|S) *([0-9\\.]*)(E|W) AT ([0-9/Z]*)", "\\5_\\1_\\2_\\3_\\4", .) %>%
        strsplit("_") %>%
        unlist
    
    # convert to data frame
    current_track.df <- data.frame(forecast_n = forecast_n, 
                                   forecast_date = current_track[1], 
                                   lat = as.numeric(current_track[2])*ifelse(current_track[3]=="N", 1, -1),
                                   long = as.numeric(current_track[4])*ifelse(current_track[5]=="E", 1, -1),
                                   winds = current_winds)
    
    # update track with current location
    track.df <- rbind(track.df, current_track.df)
    
    # add current location to prediction data frame
    current_track.df$prediction_date <- current_track.df$forecast_date
    prediction.df <- rbind(prediction.df, current_track.df[c("forecast_n", "forecast_date", "prediction_date", "lat", "long")])
    
    # get date
    display_date <- grep("([0-9]{3,4}) UTC ([A-Z]*) ([A-Z]*) ([0-9]*) ([0-9]{4})", forecast, value=T) %>%
        gsub("([0-9]{1,2})00 UTC (.*) ([0-9]{4})", "\\2 \\1:00 UTC", .)
    
    # get current prediction and convert to data frame
    current_prediction.df <- grep("FORECAST VALID .*|OUTLOOK VALID .*", forecast, value=T) %>%
        gsub(".*VALID ([0-9/Z]*) ([0-9\\.]*)(N|S) *([0-9\\.]*)(E|W).*", "\\1_\\2_\\3_\\4_\\5", .) %>%
        strsplit("_") %>%
        do.call(rbind.data.frame, .)
    colnames(current_prediction.df) <- c("prediction_date","lat","n_s","long","e_w")
    current_prediction.df$lat <- as.numeric(current_prediction.df$lat) * ifelse(current_prediction.df$n_s=="N", 1, -1)
    current_prediction.df$long <- as.numeric(current_prediction.df$long) * ifelse(current_prediction.df$e_w=="E", 1, -1)
    current_prediction.df$forecast_n <- forecast_n
    current_prediction.df$forecast_date <- current_track.df$forecast_date
    current_prediction.df <- current_prediction.df[c("forecast_n", "forecast_date", "prediction_date", "lat", "long")]
    
    # add current prediction to predictions data frame
    prediction.df <- rbind(prediction.df, current_prediction.df)
    
    # get last 20 predictions to plot (and remove Irma special forecast #25)
    prediction_subset.df <- prediction.df[prediction.df$forecast_n != 25,]
    prediction_subset.df$n <- ifelse(prediction_subset.df$forecast_n < 25, 
                                     prediction_subset.df$forecast_n, 
                                     prediction_subset.df$forecast_n-1)
    prediction_subset.df <- prediction_subset.df[prediction_subset.df$n > ifelse(forecast_n < 25, forecast_n, forecast_n-1)-1-20,]
    
    # plot hurricane
    plot_hurricane(file_name=paste0(folder_name, "/", formatC(forecast_n, width=2, format="d", flag ="0"), "0.png"), 
                   hurricane_name, display_date, prediction_subset.df, track.df, current_track.df, current_winds)
    
}
    