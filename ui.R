# Text of the books downloaded from:
# A Mid Summer Night's Dream:
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
                     sliderInput("freq", 
                                 "Minimum Frequency:", 
                                 min = 1,  max = 50, value = 15),
                     sliderInput("max", 
                                 "Maximum Number of Words:", 
                                 min = 1,  max = 300,  value = 100)
        ),
        
        # Show Word Cloud
        mainPanel(
                plotOutput("plot")
        )
))



