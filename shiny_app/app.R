#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(tidyverse)
library(shinythemes)
library(shiny)

library(statR)

statR::zhpal$zhcd

data <- read_csv("google_search.csv") %>% 
        data.frame()

searchterms <- as.character(unique(data$Suchanfragen))

top_domain <- as.character(unique(data$top_domain))


#does not work yet - button customizing
# tags$style(".nav-tabs li.active a::focus {border-radius: 4px 4px 4px 4px ;border-bottom-color: #ffffff;}")),


# UI ------------------
ui <- fluidPage(
  theme = "bootstrap.css",
  tags$header(list(tags$style("img {display:inline-block;background-repeat:no-repeat;position:relative;left:10px;z-index:3;}"),
                   tags$a(href="http://www.zh.ch", tags$img(src="lionwhite.png", height="90%"), target="_blank")),
                   tags$style("header {background-color: #009ee0 ;padding-top:10px;height:60px}")),
  # Application title
  titlePanel("zhsearch"),
  
  # Show a plot of the generated distribution
fluidRow(
  column(4, selectizeInput('searchselect', label= 'search terms',choices = searchterms, 
                         multiple = TRUE,selected = "zürich", options= list(maxItems = 10))),
  column(4,  selectInput('domainselect', label='subdomain', choices=top_domain, selected = NULL, multiple = TRUE, selectize = TRUE))
      ),
column(6, checkboxInput("checkbox", label="single terms or entire keywords", value = FALSE)),
  
  mainPanel(   )
       # placeholder for plot         , plotOutput("bvplot"))
)


# SERVER LOGIC  --------------------

server <- function(input, output) {
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)


