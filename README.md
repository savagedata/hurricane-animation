# Hurricane Animation

Welcome! This R script produces hurricane animations to compare forecasts with actual hurricane paths, like the one below.

<img src="https://github.com/savagedata/hurricane-animation/blob/master/irma_48.gif" width="500">

The data source is the National Hurricane Center's forecast advisories (like the ones on [this archive for Irma](http://www.nhc.noaa.gov/archive/2017/IRMA.shtml?)), which are issued every 6 hours. The text of these forecast advisories looks something like... 

<img src="https://github.com/savagedata/hurricane-animation/blob/master/forecast_advisory_example.png" width="500">

So each advisory must first be parsed for relevant information, like the hurricane's current coordinates and max sustained windspeed, the hurricane's coordinates 3 hours ago, and the forecast for the next 5 days. There's more information on reading advisories [here](http://www.nhc.noaa.gov/help/tcm.shtml?ALL).
