# ------ 
library(shiny)
library(shinydashboard)
library(leaflet)
library(shinythemes)
library(shinytoastr)

#theme = shinythemes::shinytheme("slate")
dashboardPage(
  skin = 'purple',
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
                                          start = min(bike_philly$UPDATED), end = max(bike_philly$UPDATED),
                                          min = min(bike_philly$UPDATED), max = max(bike_philly$UPDATED))
                       ),
                       box(width = NULL,
                           h3('Bike Counts'),
                           h4(textOutput("total_count"))),
                       box(width = NULL,
                           h3("Most Popular Biking Area"),
                           h4(textOutput("popular_area"))),
                       box(width = NULL,
                           h3("Most Popular Biking Municipality"),
                           h4(textOutput("muni")))
                )
              )
      ),
      tabItem(tabName = "graphs",
              fluidRow(
                column(width = 12,
                       box(width = NULL,
                           plotOutput("count_by_muni")))
                # column(width = 6,
                #        box(width = NULL,
                #            plotOutput("count_by_muni_per_dir")))
              ),
              fluidRow(
                column(width = 6,
                       box(width = NULL,
                           dateRangeInput("date2", "Select dates to visualize.",
                                          start = min(bike_philly$UPDATED), end = max(bike_philly$UPDATED),
                                          min = min(bike_philly$UPDATED), max = max(bike_philly$UPDATED))
                       )
                ),
                column(width = 6,
                       box(width = NULL,
                           selectInput("CNTDIR", "Which direction are you looking at?", #'county' is an ID, it is to help you keep organized. can be any other names
                                       choices = c('all','both','east','north','south','west'))
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