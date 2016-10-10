setwd("E:\\—ßœ∞œ‡πÿ\\R\\Program_for_Fun\\Presidential_Debate_Word_Cloud")
library(NLP)
library(RColorBrewer)
library(tm)
library(SnowballC)
library(wordcloud)

# data input and cleanup
file <- read.csv("2nd_pre_debate.csv", header = F)
file$V1 <- as.character(file$V1)

clean <- data.frame(x = " ", y = " ")
clean$x <- as.character(clean$x)
clean$y <- as.character(clean$y)

for (i in 1:440){
  if (is.na(strsplit(as.character(file[i,1]), ":")[[1]][2]) == F) {
    name <- strsplit(as.character(file[i,1]), ":")[[1]][1]
  }
  else {
    r <- as.character(file[i,1])
    c <- c(name, ": ", r)
    file$V1[i] <- paste(c, collapse = "")
  }
}

for (i in 1:440){
  clean[i, 1] <- strsplit(as.character(file[i,1]), ":")[[1]][1]
  clean[i, 2] <- strsplit(as.character(file[i,1]), ":")[[1]][2]
} 

# subsetting
Clinton <- clean[which(clean$x=="CLINTON"),]
Trump <- clean[which(clean$x=="TRUMP"),]
Cooper <- clean[which(clean$x=="COOPER"),]
Raddatz <- clean[which(clean$x=="RADDATZ"),]

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

Cooper_Corpus <- Corpus(VectorSource(Cooper$y))
Cooper_Corpus <- tm_map(Cooper_Corpus, tolower)
Cooper_Corpus <- tm_map(Cooper_Corpus, PlainTextDocument)
Cooper_Corpus <- tm_map(Cooper_Corpus, removePunctuation)
wordcloud(Cooper_Corpus, max.words = 200, random.order = FALSE, colors = "gray")

Radd_Corpus <- Corpus(VectorSource(Raddatz$y))
Radd_Corpus <- tm_map(Radd_Corpus, tolower)
Radd_Corpus <- tm_map(Radd_Corpus, PlainTextDocument)
Radd_Corpus <- tm_map(Radd_Corpus, removePunctuation)
wordcloud(Radd_Corpus, max.words = 200, random.order = FALSE, colors = "gray")