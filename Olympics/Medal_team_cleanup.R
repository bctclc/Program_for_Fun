setwd("E:\\—ßœ∞œ‡πÿ\\R\\Program_for_Fun\\Olympics")

team <- read.csv("Medal_team.csv")

China <- team[which(team$team=="China"),]
write.csv(China, "China_category.csv")

first_gold <- as.data.frame(matrix(0, ncol = 2))
colnames(first_gold) <- c("year", "team")
first_gold$year[1] = 1986
first_gold$team = "Greece"
gold <- team[which(team$medal=="GOLD"),]
for (i in 1:10283){
  if (gold$team[i] %in% first_gold$team){
    i = i+1
  }
  else{
    first_gold <- rbind(first_gold, c(gold$year[i], as.character(gold$team[i])))
    i = i+1
  }  
}
write.csv(first_gold,"first_gold.csv")

first_medal <- as.data.frame(matrix(0, ncol = 2))
colnames(first_medal) <- c("year", "team")
first_medal$year[1] = 1986
first_medal$team[1] = "Greece"
for (i in 1:30588){
  if (team$team[i] %in% first_medal$team){
    i = i+1
  }
  else{
    first_medal <- rbind(first_medal, c(team$year[i], as.character(team$team[i])))
    i = i+1
  }  
}
write.csv(first_medal,"first_medal.csv")