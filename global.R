#
options(mc.cores=1)
library(rJava) 

.jinit(parameters="-Xmx3g")
#options( java.parameters = "-Xmx4g" )

library(tm)

library(wordcloud)
library(memoise)
library(RWeka) # for tokenization algorithms more complicated than single-word
# Text of the corp downloaded from:

# cn <- c( 
#         "Abstract.Final.ID", "Session.or.Event.Type", "Abstract.or.Placeholder.Title"  ,
#         "Abstract.Presenter.Name"           ,
#         "Abstract.Authors"                  , "Institutions.All",                  
#         "Abstract.Status"            ,        "Abstract.Body",                     
#         "Session.Abstract.Sort.Order"      
# )  
#
# The list of valid tracks, simplified
tracks <<- list("Outreach" = "corpus--education-publicrel-outreach",
                
                
                "Earthquakes" = "corpus--seismo900_new",
                "Climate" = "corpus--planetbiogeoclim",
                "Geo-Informatics" = "corpus--earthspaceinformatics",
                "Volcanoes" = "corpus--volcanology",
                "Complex systems" = "corpus--nonlin-geophys"
                
               
               )
#UnigramTokenizer <<- function(x) NGramTokenizer(x, Weka_control(min = 1, max = 1))
#BigramTokenizer <<- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))

# Using "memoise" to automatically cache the results
getTermMatrix <- memoise(function(track, ngram) {
        nGramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = ngram, max = ngram))
        
        # Careful not to let just any name slip in here; a
        # malicious user could manipulate this value.
        if (!(track %in% tracks))
                stop("Unknown conference track!")
        #f.loadData <- function()  # read in the RData file 
        #         { 
        #        myData = new.env()  # create environment for the data 
                load(paste0("data/Rdata/", track, ".RData"))
        #        myData  # return the data 
        #} 
        #data <- f.loadData()
        # warning(bodies[[1]])
        #myCorpus <- VCorpus(VectorSource(as.vector(data$bodies)))
        #bodies <- bodies[!is.na(bodies)]
        convbodies <- iconv(bodies, to = "utf-8")
        
        # The above conversion leaves you with vector entries "NA", i.e. those tweets that can't be handled. Remove the "NA" entries with the following command:
        
        bodies <- (convbodies[!is.na(bodies)])
        myCorpus <- VCorpus(VectorSource(as.vector(bodies)))
        myCorpus = tm_map(myCorpus, content_transformer(tolower))
        myCorpus = tm_map(myCorpus, removePunctuation)
 #       myCorpus = tm_map(myCorpus,  content_transformer(cleanup))
        myCorpus = tm_map(myCorpus, removeNumbers)
        myCorpus = tm_map(myCorpus, removeWords,
                          c(stopwords("SMART"), "thy", "thou", "thee"))
        myDTM = TermDocumentMatrix(myCorpus,
                                  # control = list(minWordLength = 1))   
                                   control = list(minWordLength = 2, tokenize = nGramTokenizer)) 
        
        #warning(ht(myDTM))
        m = as.matrix(myDTM)
        rv <- sort(rowSums(m), decreasing = TRUE)
        #lapply(head(rv), warning)
        rv
})



rmPunc = function(x){
        # lookbehinds :
        # need to be careful to specify fixed-width conditions
        # so that it can be used in lookbehind
        x <- gsub('(.*?)(?<=^[[:space:][:punct:]’“”\\|:±</>]{9})([[:alnum:]])',"\\2", x, perl=TRUE) ;
        x <- gsub('(.*?)(?<=^[[:space:][:punct:]’“”:±</>]{8})([[:alnum:]])',"\\2", x, perl=TRUE) ;
        x <- gsub('(.*?)(?<=^[[:space:][:punct:]’“”\\|:±</>]{7})([[:alnum:]])',"\\2", x, perl=TRUE) ;
        x <- gsub('(.*?)(?<=^[[:space:][:punct:]’“”:±</>]{6})([[:alnum:]])',"\\2", x, perl=TRUE) ;
        x <- gsub('(.*?)(?<=^[[:space:][:punct:]’“”\\|:±</>]{5})([[:alnum:]])',"\\2", x, perl=TRUE) ;
        x <- gsub('(.*?)(?<=^[[:space:][:punct:]’“”:±</>]{4})([[:alnum:]])',"\\2", x, perl=TRUE) ;
        x <- gsub('(.*?)(?<=^[[:space:][:punct:]’“”:±</>]{3})([[:alnum:]])',"\\2", x, perl=TRUE) ;
        x <- gsub('(.*?)(?<=^[[:space:][:punct:]’“”:±</>]{2})([[:alnum:]])',"\\2", x, perl=TRUE) ;
        x <- gsub('(.*?)(?<=^[[:space:][:punct:]’“”:±</>])([[:alnum:]])',"\\2", x, perl=TRUE) ;
        # lookbehind: there must be a word char to the left and punct/whitespace stuff to the end.
        # Then append 1 extra blank
        x <- gsub('(.*?)(?<=[[:alnum:]])([[:space:][:punct:]’“”:±</>\\\\]+?)$',"\\1", x, perl=TRUE)
        # remove all strings that consist *only* of punct chars
        x <- gsub('^[[:space:][:punct:]’“”:±</>\\\\]+$',"", x, perl=TRUE) ;
        x
}

cleanup = function(doc, sep= "-"){
        doc = gsub("body:", "", doc, perl=TRUE);
        y = strsplit(doc, sep);
        y = lapply(y, rmPunc);
        y[grep("\\S+", y, invert=FALSE, perl=TRUE)];
        y = sapply(y, paste, sep=" ")
        y <- paste(y, collapse = sep)
        y
}

