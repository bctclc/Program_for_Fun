setwd("E:\\—ßœ∞œ‡πÿ\\R\\Program_for_Fun\\Presidential_Debate_Word_Cloud")
library(NLP)
library(RColorBrewer)
library(tm)
library(SnowballC)
library(wordcloud)

# data input and cleanup
file <- read.csv("vp_debate.csv", header = F)
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
Pence <- clean[which(clean$x=="PENCE"),]
Kaine <- clean[which(clean$x=="KAINE"),]
Quijano <- clean[which(clean$x=="QUIJANO"),]

# word cloud
Pence_Corpus <- Corpus(VectorSource(Pence$y))
Pence_Corpus <- tm_map(Pence_Corpus, tolower)
Pence_Corpus <- tm_map(Pence_Corpus, PlainTextDocument)
Pence_Corpus <- tm_map(Pence_Corpus, removePunctuation)
wordcloud(Pence_Corpus, min.freq = 5, max.words = 200, random.order = FALSE, colors = "gray")

Kaine_Corpus <- Corpus(VectorSource(Kaine$y))
Kaine_Corpus <- tm_map(Kaine_Corpus, tolower)
Kaine_Corpus <- tm_map(Kaine_Corpus, PlainTextDocument)
Kaine_Corpus <- tm_map(Kaine_Corpus, removePunctuation)
wordcloud(Kaine_Corpus, min.freq = 5, max.words = 200, random.order = FALSE, colors = "gray")

Qui_Corpus <- Corpus(VectorSource(Quijano$y))
Qui_Corpus <- tm_map(Qui_Corpus, tolower)
Qui_Corpus <- tm_map(Qui_Corpus, PlainTextDocument)
Qui_Corpus <- tm_map(Qui_Corpus, removePunctuation)
wordcloud(Qui_Corpus, max.words = 200, random.order = FALSE, colors = "gray")
