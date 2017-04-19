# ----- Shiny App -----
# Jianting Zhao
# April 19th, 2017

library(shiny)
library(dplyr)
library(leaflet)
library(ggplot2)
library(plotly)
library(lubridate)

direction_subset = function(dataset,direc){
  if (direc == 'west'|direc == 'both'|direc=='east'|direc=='north'|direc=='south'){
    dataset %>% 
      subset(CNTDIR==direc)
  } else {
    return(dataset)
  }
}

shinyServer(function(input, output, session) {
  filtered_bike <- reactive({
    input$date1
    input$CNTDIR
    isolate({
      bike_philly %>%
        subset(UPDATED >= as.POSIXlt(input$date1[1])) %>%
        subset(UPDATED <= as.POSIXlt(input$date1[2])) %>%
        direction_subset(as.character(input$CNTDIR))
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
  
  # observe({
  #   input$CNTDIR
  #   updateSelectInput(session,'CNTDIR','Choose a direction',
  #                     choices = c('all','both','east','north','south','west'))
  # })
  
  output$bike_count_map <- renderLeaflet({
    filtered_bike() %>%
      leaflet() %>%
      setView(lng = "-75.131290", lat = "39.998602", zoom = 11) %>% 
      addTiles() %>%
      addMarkers(clusterOptions = markerClusterOptions(),
                 popup = ~popinfo) #~ is a leaflet syntax for column
  })
  
  output$count_by_muni <- renderPlotly({
    count_per_muni <- filtered_bike() %>%
      select(-UPDATED) %>%
      group_by(MUN_NAME) %>%
      summarize(count_sum = sum(AADB))
    # use plotly to plot. 
    plot1 <- ggplot(count_per_muni, aes(x=reorder(MUN_NAME,-count_sum), y=count_sum, text = paste('count:',count_sum))) + 
      geom_bar(stat = 'identity',aes(fill=MUN_NAME)) +
      labs(title = 'Bike Counts per Municipalities', x="Municipality names",y="Bike counts") +
      theme_gray() + theme(axis.text.x = element_text(angle = 45, hjust = 1),legend.position="none")
    ggplotly(plot1) %>%
      layout(annotations = 'good')
  })
  #plotlyOutput('count_by_muni')
  
  # output$count_by_muni_per_dir <- renderPlot({
  #   count_per_muni2 <- filtered_bike() %>%
  #     select(-UPDATED) %>%
  #     group_by(MUN_NAME) %>%
  #     summarize(count_sum2 = sum(AADB))
  # 
  #   ggplot(count_per_muni2, aes(reorder(MUN_NAME,-count_sum), count_sum)) + 
  #     geom_bar(stat = 'identity',aes(fill=MUN_NAME)) +
  #     labs(title = 'Bike Counts per Municipalities', x="Municipality names",y="Bike counts") +
  #     theme_gray() + theme(axis.text.x = element_text(angle = 45, hjust = 1),legend.position="none")
  # })
  
  output$total_count <- renderText({
    as.character(sum(filtered_bike()$AADB))
  })
  
  output$popular_area <- renderText({
    names(tail(sort(table(filtered_bike()$TOLMT)), 1))
    #filtered_bike()$MUN_NAME[which(filtered_bike()$),]
  })
  
  output$muni <- renderText({
    names(tail(sort(table(filtered_bike()$MUN_NAME)), 1))
  })
})
