setwd("E:\\—ßœ∞œ‡πÿ\\R\\Program_for_Fun\\Presidential_Debate_Word_Cloud")
library(NLP)
library(RColorBrewer)
library(tm)
library(SnowballC)
library(wordcloud)

# data input and cleanup
file <- read.csv("1st_pre_debate.csv", header = F)
file$V1 <- as.character(file$V1)

clean <- data.frame(x = " ", y = " ")
clean$x <- as.character(clean$x)
clean$y <- as.character(clean$y)
 
for (i in 1:523){
  if (is.na(strsplit(as.character(file[i,1]), ":")[[1]][2]) == F) {
    name <- strsplit(as.character(file[i,1]), ":")[[1]][1]
  }
  else {
    r <- as.character(file[i,1])
    c <- c(name, ": ", r)
    file$V1[i] <- paste(c, collapse = "")
  }
}

for (i in 1:523){
  clean[i, 1] <- strsplit(as.character(file[i,1]), ":")[[1]][1]
  clean[i, 2] <- strsplit(as.character(file[i,1]), ":")[[1]][2]
} 

# subsetting
Clinton <- clean[which(clean$x=="CLINTON"),]
Trump <- clean[which(clean$x=="TRUMP"),]
Holt <- clean[which(clean$x=="HOLT"),]

# word cloud
Cli_Corpus <- Corpus(VectorSource(Clinton$y))
Cli_Corpus <- tm_map(Cli_Corpus, tolower)
Cli_Corpus <- tm_map(Cli_Corpus, PlainTextDocument)
Cli_Corpus <- tm_map(Cli_Corpus, removePunctuation)
wordcloud(Cli_Corpus, min.freq = 5, max.words = 200, random.order = FALSE, colors = "gray")

Tr_Corpus <- Corpus(VectorSource(Trump$y))
Tr_Corpus <- tm_map(Tr_Corpus, tolower)
Tr_Corpus <- tm_map(Tr_Corpus, PlainTextDocument)
Tr_Corpus <- tm_map(Tr_Corpus, removePunctuation)
wordcloud(Tr_Corpus, min.freq = 5, max.words = 200, random.order = FALSE, colors = "gray")

Holt_Corpus <- Corpus(VectorSource(Holt$y))
Holt_Corpus <- tm_map(Holt_Corpus, tolower)
Holt_Corpus <- tm_map(Holt_Corpus, PlainTextDocument)
Holt_Corpus <- tm_map(Holt_Corpus, removePunctuation)
wordcloud(Holt_Corpus, max.words = 200, random.order = FALSE, colors = "gray")
