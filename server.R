library(rJava) 
.jinit(parameters="-Xmx128g")
library(shiny)
library(shinyIncubator)



shinyServer(function(input, output, session) {
        # Define a reactive expression for the document term matrix
        terms <- reactive({
                # Change when the "Change" button is pressed...
                input$update
                # ...but not for anything else
                isolate({
                        withProgress(session, {
                                setProgress(message = "Processing text corpus...",
                                            detail = '...may continue after this has disappeared!'
                                            )
                                getTermMatrix(input$selection, input$ngram)
                        })
                })
        })
        
        # image size
        
        wdt <- reactive({
                if(input$plotsize == "large"){ 
                     wdt <- 1024
                } else {
                     wdt <- "auto"    
                }
        })
        hgt <- reactive({
                if(input$plotsize == "large"){ 
                        hgt <- 768
                } else {
                        hgt <- "auto"
                }
        })
        
        # Make the wordcloud drawing predictable during a session
        
        wordcloud_rep <- repeatable(wordcloud)

        output$plot <- renderPlot({
                v <- terms()
                wordcloud_rep(names(v), v, scale=c(4,0.5),
                              min.freq = input$freq, max.words=input$max,
                              colors=brewer.pal(8, "Dark2"))
        }, width =wdt, height =hgt )
        
})
