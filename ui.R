library(shiny)
library(shinyIncubator)
actionButton <- function(inputId, label, btn.style = "" , css.class = "") {
        if ( btn.style %in% c("primary","info","success","warning","danger","inverse","link")) {
                btn.css.class <- paste("btn",btn.style,sep="-")
        } else btn.css.class = ""
        tags$button(id=inputId, type="button", class=paste("btn action-button",btn.css.class,css.class,collapse=" "), label)
}
shinyUI(fluidPage(
        progressInit(),
        
        # Application title
        headerPanel("Word Clouds"),
        wellPanel(div("Most common phrases in conference abstracts", class="lead"), div("AGU Fall Meeting 2012", class="lead"),
                  div("The American Geophysical Union (AGU) is a professional society for Earth Scientists. Once a year, there is a big conference with more than 20000 participants
                      from around the world.", class="muted"),
                  div("This web-app creates word clouds from conference abstracts. Each word cloud summarizes hundreds of science talks and posters. 
                       Only a small subset of the conference 'tracks', and the sessions in these tracks are listed here, grouped by theme.", class="muted"),
                  div("This app enables users to get a quick overview about important topics, buzzwords and common research themes within the unfamiliar but related subfields of sciences.", class="muted")
                  ),
       
        # Sidebar with a slider and selection inputs
        sidebarPanel(width = 3,
                     div("Choose conference track, simplified title:"), #, class="lead"
                     selectInput("selection", "", 
                                 choices = tracks, width="100%"),
                     radioButtons("ngram", 
                                  "Phrase consists of this many words:", 
                                  selected = "2",
                                  c("1 Word (fastest)" = "1",
                                    "2 Words (default)" = "2",
                                    "3 Words (resource hog!)" = "3")),
                     actionButton("update", "Change", btn.style="primary"),
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



