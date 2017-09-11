# Hurricane Animation

Welcome! This R script produces hurricane animations to compare forecasts with actual hurricane paths, like the one below for Irma.

<p align="center"><img src="https://github.com/savagedata/hurricane-animation/blob/master/irma.gif" width="500"></p>

The data source is the National Hurricane Center's forecast advisories (like the ones in [this archive for Irma](http://www.nhc.noaa.gov/archive/2017/IRMA.shtml?)), which are issued every 6 hours. The text of these forecast advisories looks something like... 

<img src="https://github.com/savagedata/hurricane-animation/blob/master/forecast_advisory_example.png" width="500">

So each advisory must first be parsed for relevant information, like the hurricane's current coordinates and max sustained windspeed, the hurricane's coordinates 3 hours ago, and the forecast for the next 5 days. There's more information on reading advisories [here](http://www.nhc.noaa.gov/help/tcm.shtml?ALL).

Then the hurricane's track is plotted on a map of the US using ggplot. Thanks to some helpful suggestions from [r/DataIsBeautiful](https://www.reddit.com/r/dataisbeautiful/comments/6z0w20/timelapse_of_hurricane_irma_predictions_vs_actual/), the last 20 forecasts (or 5 days) of forecasts are retained, gradually fading out.

I started this project while anxiously watching Hurricane Irma's path shift from east Florida to west Florida. I thought I would discover how far off the forecasts were. Instead, I saw how Irma regularly strayed hundreds of miles from the projected path, even while still in the middle of the Atlantic. Given the context, Florida didn't seem that wide anymore. The moral of the story is to take into account hurricane "cones of uncertainty" since hurricanes won't follow the exact predicted path. 140 miles sounds like a lot when we're talking about whether Irma will make landfall in Miami or Tampa but it's within the error of these weather models, especially days out.

Next up... will Jose pull a loop de loop?

<p align="center"><img src="https://github.com/savagedata/hurricane-animation/blob/master/jose.gif" width="500"></p>

And here's Harvey bouncing along the Texas coast. Harvey actually started off southeast of the Yucatan Peninsula but dissipated on August 9 (into a "tropical wave") before it crossed Mexico. It strengthened again on August 23 and that's when the forecast advisories started again. This animation looks at August 23 onward.

<p align="center"><img src="https://github.com/savagedata/hurricane-animation/blob/master/harvey.gif" width="500"></p>
