# Philadelphia Bike Count Visualization

This is a web application for readers to visualize bicycle activities 
in the City of Phildelphia. This application includes the following 
features:

1. An interactive map of Philadelphia including:
  - Clustered crime events
  - Popup text for each event with crime details
2. Widgets that provide aggregate summaries of crime events.
3. A calendar that allows the user to filter crime events by date. This calendar
is consistent throughout the app.
4. Visualizations of crime over time and by type of crime.

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

To run this app locally make sure you've installed the R packages mentioned above, then
run:

```
shiny::runGitHub("kristenzhao/Philadelphia-Bike-Count")
```


