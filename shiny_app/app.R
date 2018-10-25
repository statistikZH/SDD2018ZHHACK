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
library(plotly)
library(tm)
library(tidytext)

source("helpers.R")

data <- read_csv("google_search.csv") %>% 
        data.frame()

searchterms <- as.character(unique(data$Suchanfragen))

top_domain <- as.character(unique(data$top_domain))

top10 <-data %>% top_n(10,Klicks)


#does not work yet - button customizing
# tags$style(".nav-tabs li.active a::focus {border-radius: 4px 4px 4px 4px ;border-bottom-color: #ffffff;}")),


# UI ------------------
ui <- fluidPage(
  theme = "bootstrap.css",
  tags$header(list(tags$style("img {display:inline-block;background-repeat:no-repeat;position:relative;left:10px;z-index:3;}"),
                   tags$a(href="http://www.zh.ch", tags$img(src="lionwhite.png", height="90%"), target="_blank")),
                   tags$style("header {background-color: #009ee0 ;padding-top:10px;height:60px}")),
  # Application title
  titlePanel("sear.zh"),
  "This shiny-App has been developed at the Swiss Digital Day - Hackathon 2018. It reveals which Google search keywords led people to the website of the canton of Zurich and its subdomains.
  It allows the visualization of relationships between search terms and domains of zh.ch. ",
  br(),
  # Show a plot of the generated distribution
fluidRow(
  column(4, selectizeInput('searchselect', label= 'search terms',choices = searchterms, 
                         multiple = TRUE,selected = top10$Suchanfragen, options= list(maxItems = 10))),
  column(4,  selectInput('domainselect', label='subdomain', choices=top_domain, selected = NULL, multiple = TRUE, selectize = TRUE))
      ),
column(12,"By checking the checkboy below you can decompose the search terms into single words."),
column(4, checkboxInput("checkbox", label="single terms", value = FALSE)),
column(4, checkboxInput("checkbox_year", label="include all domains (caution : varying timespans!)", value = FALSE)),
  
  mainPanel( plotlyOutput("sankey")  )

)


# SERVER LOGIC  --------------------

server <- function(input, output) {
  
  
  output$sankey <- renderPlotly({
    
    if(length(input$domainselect)==0){
      
      data_filtered <- data[which(data$Suchanfragen %in% input$searchselect),]
      
      zhweb(dat_processing(data_filtered,single_word=input$checkbox,filter_yr=!input$checkbox_year)) 
      
    }else{
      
      zhweb(domain_filter(data,domains=input$domainselect,filter_yr=!input$checkbox_year)) 
    }
      
    
  })
  
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)


