#

library(tm)
library(wordcloud)
library(memoise)
#library("RWeka") # for tokenization algorithms more complicated than single-word
# Text of the corp downloaded from:

cn <- c( 
        "Abstract.Final.ID", "Session.or.Event.Type", "Abstract.or.Placeholder.Title"  ,
        "Abstract.Presenter.Name"           ,
        "Abstract.Authors"                  , "Institutions.All",                  
        "Abstract.Status"            ,        "Abstract.Body",                     
        "Session.Abstract.Sort.Order"      
)  
#
# The list of valid tracks
tracks <<- list("Outreach" = "corpus--education-publicrel-outreach",
                "Seismology" = "corpus--seismo900_new",
                "Volcanology" = "corpus--volcanology"
                
               
               )
#UnigramTokenizer <<- function(x) NGramTokenizer(x, Weka_control(min = 1, max = 1))
#BigramTokenizer <<- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))


# Using "memoise" to automatically cache the results
getTermMatrix <- memoise(function(track) {
        # Careful not to let just any name slip in here; a
        # malicious user could manipulate this value.
        if (!(track %in% tracks))
                stop("Unknown conference track!")
        f.loadData <- function()  # read in the RData file 
                 { 
                myData = new.env()  # create environment for the data 
                load(paste0("data/Rdata/", track, ".RData"), envir=myData)
                myData  # return the data 
        } 
        data <- f.loadData()
        #myList <- ls()
        #myList <- myList[! (myList %in% c("csv", "bodies", "df", "BigramTokenizer"))] 
        #rm(list=myList)
        #lapply(ls(), warning)
        #warning(bodies[[1]])
        myCorpus <- VCorpus(VectorSource(as.vector(data$bodies)))
        myCorpus = tm_map(myCorpus, content_transformer(tolower))
        myCorpus = tm_map(myCorpus, removePunctuation)
        myCorpus = tm_map(myCorpus, removeNumbers)
        myCorpus = tm_map(myCorpus, removeWords,
                          c(stopwords("SMART"), "thy", "thou", "thee"))
        myDTM = TermDocumentMatrix(myCorpus,
                                   control = list(minWordLength = 1))   
                                   # control = list(minWordLength = 1, tokenize = BigramTokenizer)) 
        #warning(ht(myDTM))
        m = as.matrix(myDTM)
        
        sort(rowSums(m), decreasing = TRUE)
})
