library(shiny)
library(shinyIncubator)

shinyUI(fluidPage(
        progressInit(),
        
        # Application title
        headerPanel("Word Cloud"),
        
        # Sidebar with a slider and selection inputs
        sidebarPanel(width = 6,
                     selectInput("selection", "Choose a conference track:", 
                                 choices = tracks, width="100%"),
                     actionButton("update", "Change"),
                     hr(),
                     sliderInput("max", 
                                 "Number of items in Word-Cloud:", 
                                 min = 1,  max = 100,  value = 15),
                     sliderInput("freq", 
                                 "Phrase must occur at least n times:", 
                                 min = 1,  max = 50, value = 30)
        ),
        
        # Show Word Cloud
        mainPanel(
                plotOutput("plot")
        )
))



