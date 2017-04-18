# ----- Shiny App -----
# Jianting Zhao
# April 19th, 2017

library(shiny)
library(dplyr)
library(leaflet)
library(ggplot2)
library(lubridate)

shinyServer(function(input, output, session) {
  filtered_bike <- reactive({
    input$date1
    
    isolate({
      bike_philly %>%
        subset(UPDATED >= as.POSIXlt(input$date1[1])) %>%
        subset(UPDATED <= as.POSIXlt(input$date1[2]))
    })
  })
  
  observe({
    input$date1 # any change on map will update in ggplot
    
    updateDateRangeInput(session, "date1",
                         "Select dates to visualize.",
                         start = input$date1[1],
                         end = input$date1[2],
                         min = min(bike_philly$UPDATED), max = max(bike_philly$UPDATED))
  })
  
  observe({
    input$date2 #any change in ggplot will reflect on map
    
    updateDateRangeInput(session, "date2",
                         "Select dates to visualize.",
                         start = input$date2[1],
                         end = input$date2[2],
                         min = min(bike_philly$UPDATED), max = max(bike_philly$UPDATED))
  })
  
  output$bike_count_map <- renderLeaflet({
    filtered_bike() %>%
      leaflet() %>%
      setView(lng = "-75.131290", lat = "39.998602", zoom = 11) %>% 
      addTiles() %>%
      addMarkers(clusterOptions = markerClusterOptions(),
                 popup = ~popinfo) #~ is a leaflet syntax for column
  })
  
  output$count_by_muni <- renderPlot({
    count_per_muni <- filtered_bike() %>%
      group_by(MUN_NAME) %>%
      summarize(count_sum = sum(AADB))
    
    ggplot(count_per_muni, aes(CrimeDate, count_sum)) + geom_line()
  })
  
  output$desc_plot <- renderPlot({
    desc_crime <- filtered_crime() %>%
      group_by(Description) %>%
      summarize(Total = n())
    
    ggplot(desc_crime, aes(Description, Total)) + geom_bar(stat = "identity") + coord_flip()
  })
  
  output$total_count <- renderText({
    as.character(sum(filtered_bike$AADB))
  })
  
  output$popular_area <- renderText({
    names(tail(sort(table(filtered_crime()$Description)), 1))
  })
  
  output$nhood <- renderText({
    names(tail(sort(table(wday(filtered_crime()$CrimeDate, label = TRUE, abbr = FALSE))), 1))
  })
  
})
