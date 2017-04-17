# ------ 
library(shiny)
library(shinydashboard)
library(leaflet)

dashboardPage(
  dashboardHeader(title = "Philadelphia Bike Count", titleWidth = 250),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Map of Philadelphia", tabName = "map", icon = icon("map")),
      menuItem("Graphs & Metrics", tabName = "graphs", icon = icon("signal", lib = "glyphicon")),
      menuItem("About", tabName = "about", icon = icon("question-circle")),
      menuItem("Source Code", href = "http://github.com/kristenzhao", icon = icon("github-alt"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "map",
              fluidRow(
                column(width = 8,
                       box(width = NULL,
                           leafletOutput("bike_count_map", height = 500))
                ),
                column(width = 3,
                       box(width = NULL,
                           dateRangeInput("date1", "Select dates to visualize.",
                                          start = '2016-08-01', end = '2017-04-30',
                                          min = min(bike_philly$UPDATED), max = max(bike_philly$UPDATED))
                       ),
                       box(width = NULL,
                           h3('Bike Counts'),
                           h4(textOutput("total_count"))),
                       box(width = NULL,
                           h3("Most Popular Biking Area"),
                           h4(textOutput("popular_area"))),
                       box(width = NULL,
                           h3("Most Popular Biking Neighborhood"),
                           h4(textOutput("nhood")))
                )
              )
      ),
      tabItem(tabName = "graphs",
              fluidRow(
                column(width = 6,
                       box(width = NULL,
                           plotOutput("daily_plot"))),
                column(width = 6,
                       box(width = NULL,
                           plotOutput("desc_plot")))
              ),
              fluidRow(
                column(width = 6,
                       box(width = NULL,
                           dateRangeInput("date2", "Select dates to visualize.",
                                          start = '2016-08-01', end = '2017-04-30',
                                          min = min(bike_philly$UPDATED), max = max(bike_philly$UPDATED))
                       )
                )
              )),
      tabItem(tabName = "about",
              fluidRow(
                column(width = 12,
                       box(width = NULL,
                           includeMarkdown("about.md")))
              )
      )
    )
  )
)