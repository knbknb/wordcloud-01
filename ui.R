library(shiny)
library(shinyIncubator)

shinyUI(fluidPage(
        progressInit(),
        
        # Application title
        headerPanel("Word Clouds"),
        wellPanel(div("Most common phrases in conference abstracts", class="lead"), div("AGU Fall Meeting 2012", class="lead"),
                  div("The American Geophysical Union is a professional society for Earth Scientists. Once a year, there is a big conference with more than 20000 participants
                      from around the world.", class="muted"),
                  div("This web-app creates word clouds from the conference abstracts of selected conference tracks. Only a small subset of the tracks and the sessions in these tracks are listed here.", class="muted"),
                  div("This app enables users to get a quick overview about important topics, buzzwords and common research themes in unfamiliar but related subfields of sciences.", class="muted")
                  ),
       
        # Sidebar with a slider and selection inputs
        sidebarPanel(width = 3,
                     textOutput("AGU Fall Meeting 2012"),
                     selectInput("selection", "Choose a conference track:", 
                                 choices = tracks, width="100%"),
                     radioButtons("ngram", 
                                  "Phrase consists of this many words:", 
                                  selected = "2",
                                  c("1 Word" = "1",
                                    "2 Words" = "2",
                                    "3 Words" = "3")),
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



