# Hurricane Animation

Welcome! This R script produces hurricane animations to compare forecasts with actual hurricane paths, like the one below for Irma.

<p align="center"><img src="https://github.com/savagedata/hurricane-animation/blob/master/irma_48.gif" width="500"></p>

The data source is the National Hurricane Center's forecast advisories (like the ones on [this archive for Irma](http://www.nhc.noaa.gov/archive/2017/IRMA.shtml?)), which are issued every 6 hours. The text of these forecast advisories looks something like... 

<img src="https://github.com/savagedata/hurricane-animation/blob/master/forecast_advisory_example.png" width="500">

So each advisory must first be parsed for relevant information, like the hurricane's current coordinates and max sustained windspeed, the hurricane's coordinates 3 hours ago, and the forecast for the next 5 days. There's more information on reading advisories [here](http://www.nhc.noaa.gov/help/tcm.shtml?ALL).

Then the hurricane's track is plotted on a map of the US using ggplot. Thanks to some helpful suggestions from [r/DataIsBeautiful](https://www.reddit.com/r/dataisbeautiful/comments/6z0w20/timelapse_of_hurricane_irma_predictions_vs_actual/), the last 20 forecasts (or 5 days) of forecasts are retained, gradually fading out.
