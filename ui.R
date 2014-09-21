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
        titlePanel("Word Clouds"),
        wellPanel(div("Common phrases in conference abstracts, AGU Fall Meeting 2012", class="lead"),
                  actionLink(label="MiniHelp", class="text-info", inputId="knbhelp"),
                  div(div("The American Geophysical Union (AGU) is a professional society for Earth Scientists. Once a year, there is a big conference with more than 20000 participants
                      from around the world.", class="muted"),
                          div("This web-app creates Word Clouds from conference abstracts. Each word-cloud picture \"summarizes the summaries\" of hundreds of science talks and posters. ", class="muted"),
                           div("In doing so, this app enables users to get a quick overview of important topics, buzzwords and common themes within a certain research area. 
                               Many subfields of Earth Science are interesting, related to one's own specialty, but still unfamiliar because of their vastness, technicality and interdiciplinarity.", class="muted"),
                           div("Note: Only a small subset of conference contributions, grouped by topic, are made queryable in the UI below.", class="muted"),
                           class="knbtoggle", style="display: none"
                          )
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
                                 min = 1,  max = 50, value = 20),
                     hr(),
                     radioButtons("plotsize", 
                                  "Canvas Size:", 
                                  selected = "auto",
                                  c("auto" = "auto", "large" = "large"))
                     

        ),
        
        # Show Word Cloud
        mainPanel(
                plotOutput("plot"),
                tags$head(tags$script(src="knb.js"))
        )
))



