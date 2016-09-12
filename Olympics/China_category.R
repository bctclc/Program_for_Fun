setwd("E:\\—ßœ∞œ‡πÿ\\R\\Program_for_Fun\\Olympics")

library(dplyr)
library(devtools)
# devtools::install_github("hrbrmstr/streamgraph")
library(streamgraph)

# read file and subset for gold medal file
fl <- read.csv("China_category.csv")
gd <- fl[which(fl$medal=="GOLD"),]
fl <- fl[,c(1,2)]
fl[,3] <- 1
gd <- gd[,c(1,2)]
gd[,3] <- 1

# aggregate
medal <- fl %>%
  group_by(year,category) %>%
  summarise(count = sum(V3))

gold <- gd %>%
  group_by(year,category) %>%
  summarise(count = sum(V3))

# set colors
color = c("#3d457b", "#fd6270", "#3d457b", "#3d457b", "#3d457b", "#3d457b",
                "#f1ada4", "#3d457b", "#3d457b", "#3d457b", "#eeccb1", "#3d457b",
                "#3d457b", "#3d457b", "#3d457b", "#3d457b", "#f3d64e", "#3d457b",
                "#3d457b", "#f5f2a4", "#3d457b", "#a4edce", "#3d457b", "#3d457b",
                "#3d457b", "#3d457b", "#a7eee8", "#3d457b")


# create stream graphs
streamgraph(medal, "category", "count", "year", interpolate = "linear") %>%
  sg_fill_manual(values = color) %>%
  sg_legend(show=TRUE, label="Sports: ")

streamgraph(gold, "category", "count", "year", interpolate = "linear") %>%
  sg_fill_manual(values = color) %>%
  sg_legend(show=TRUE, label="Sports: ")
