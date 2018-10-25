#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(tidyverse)

data <- read_csv("google_search.csv") %>% 
        data.frame()

searchterms <- as.character(unique(data$Suchanfragen))

top_domain <- as.character(unique(data$top_domain))

library(shiny)


# UI ------------------
ui <- fluidPage(
  theme = "bootstrap.css",
  
  # Application title
  titlePanel("zhsearch"),
  
  # Show a plot of the generated distribution
  mainPanel(    selectizeInput('searchselect', label= 'search terms',choices = searchterms, 
                               multiple = TRUE,selected = "zürich", options= list(maxItems = 10)),
                selectInput('domainselect', label='subdomain', choices=top_domain, selected = NULL, multiple = TRUE, selectize = TRUE)
                  )
       # placeholder for plot         , plotOutput("bvplot"))
)


# SERVER LOGIC  --------------------

server <- function(input, output) {
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)


