# Philadelphia Bike Count Visualization

This is a web application for readers to visualize bicycle activities 
in the City of Phildelphia. 
This application includes the following features:

1. An interactive map of Philadelphia including:
  - Clustered Bike Count locations
  - Popup text for traffic at each count location
2. Widgets that provides summaries of bike traffic pattern.
3. A calendar that allows the user to filter bike count data by date. This calendar
is consistent throughout the app.
4. Visualizations of bike counts aggregated to municipalities.

The following R Packages were used to prepare the data for this app:

- dplyr
- lubridate
- readr
- magrittr
- stringr
- purrr

The following R Packages are used to render this app:

- shiny
- shinydashboard
- dplyr
- leaflet
- ggplot2
- lubridate
- plotly

To run this app locally make sure you've installed the R packages mentioned above, then
run:

```
shiny::runGitHub("kristenzhao/Philadelphia-Bike-Count")
```


