setwd("E:\\—ßœ∞œ‡πÿ\\R\\Program_for_Fun\\Douban_Movie250")

library(ggplot2)

after <- read.csv("year_count_after80.csv")
before <- read.csv("year_count_pre80.csv")


ggplot(after, aes(x=year, y=count, fill=year)) +
  geom_bar(stat = "identity", width = 0.8, color = "white", fill= "#06B310")+
  coord_polar(theta = "x", start = 0)+
  theme(panel.background = element_rect(fill = "white"))

ggplot(before, aes(x=year, y=count, fill=year)) +
  geom_bar(stat = "identity", width = 7, color = "white", fill= "#06B310")+
  coord_polar(theta = "x", start = 0)+
  theme(panel.background = element_rect(fill = "white"))
