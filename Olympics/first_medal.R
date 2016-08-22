setwd("E:\\—ßœ∞œ‡πÿ\\R\\Program_for_Fun\\Olympics")
library(plyr)
library(maps)
library(plotly)
library(ggplot2)

dat <- read.csv("first_medal_edited.csv")
code <- read.csv("country_code.csv")
dat <- merge(dat, code, by="country", all = T)
dat <- dat[,c(1,3,14)]
dat <- dat[which(is.na(dat$year)==F),]
colnames(dat) <- c("team", "year", "code")

l <- list(color = "GREY", width = 0.5)
g <- list(
  showframe = FALSE,
  showcoastlines = FALSE,
  projection = list(type = 'Mercator')
)
plot_ly(dat, z = year, text = team, locations = code, type = 'choropleth',
        color = year, colors = c("#EBF0F5", "#384773"), marker = list(line = l),
        colorbar = list(title = "Year")) %>%
  layout(geo = g, title = "First Olympic Medal", font = list(family = "High Tower Text"),
         titlefont = list(family = "Stencil"), autosize = T)