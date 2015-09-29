## Homework 11: Shiny

For [Homework 11](http://stat545-ubc.github.io/hw11_build-shiny-app), I have developed my own Shiny app using RStudio. My app has been deployed using `shinyapps.io` and can be found on the web, at [creagh.shinyaps.io/Gapminder-app](https://creagh.shinyapps.io/Gapminder-app/). 

### Overview

This app uses the Gapminder dataset to explore the relationships between *GDP per Capita*, *Life Expectancy*, and *Population*, over time. Within the app, there are 3 tabs for users to explore:

* **Plot**: A scatterplot of one of the 3 response variables against *Year*

* **Data**: A tabular display of the Gapminder data for the country or countries currently selected.

* **Linear Spline**: A dynamic scatter plot that produces a linear regression spline on the chosen data and let's the user specify the number of knots. This feature was based on the code that I wrote as part of my Homework 10.

### Running the App

Currently, there are 2 methods for running this Shiny app:

* On the web, simply follow the link to [creagh.shinyaps.io/Gapminder-app](https://creagh.shinyapps.io/Gapminder-app/), where my app has been deployed on `shinyapps.io`.

* To run the app locally, clone my repo to a local RStudio project and run my app from within the [Shiny-apps/Gampminder-app](https://github.com/STAT545-UBC/zz_creagh_briercliffe-coursework/tree/master/Homeworks/HW11/Shiny-apps/Gapminder-app) subdirectory.

### Features

I've added several extra features to this app, beyond those that were developed in the class tutorial:

* CSS theme and `html` coding to alter display qualities and improve alignment.
* Use of a `tabsetPanel` for displaying the plots and tables in different tabs of the main display area.
* Added a UBC logo image to the `sidebarPanel`
* Widgets for adding multiple plots, facetting, changing the response variable, and smoothing of the lines
* Linear regression spline plots that can handle 1 country at a time and various response variables.
* A widget to change the number of knots in the linear spline plot

I also experimented with changing the slider for year input to a `dateRangeInput` widget; however, I decided that I preferred the slider, so in the end I changed it back to the slider.

### Code

All of my code has been made available in the [Shiny-apps/Gampminder-app](https://github.com/STAT545-UBC/zz_creagh_briercliffe-coursework/tree/master/Homeworks/HW11/Shiny-apps/Gapminder-app) subdirectory.

### Reflections

* The most frustrating part of this homework was trying to get the `radioButtons` to center align. I tried numerous methods, but to no avail, so in the end I chose to use a drop-down menu instead.

* The linear spline portion of this app still needs further improvement. In particular, it would be nice if the linear spline plots could be extended to handle multiple countries at one time.

* Originally, I had the app download my [linearspline](https://github.com/Creagh/linearspline) package from Github, but this was too slow, so I chose to embed all of the necessary functions within my `server.R` script instead.

