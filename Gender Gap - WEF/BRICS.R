setwd("E:\\—ßœ∞œ‡πÿ\\R\\Program_for_Fun\\Gender Gap - WEF")
library(ggplot2)
library(plyr)
library(ggradar)
library(gridExtra)

BRICS <- c("China", "Brazil", "Russian Federation", "India", "South Africa")

overall <- read.csv("Overall.csv")
eco_par <- read.csv("Economic Participation.csv")
edu_att <- read.csv("Edu Attainment.csv")
income <- read.csv("Est. Earned Income.csv")
head_state <- read.csv("Female Head of State.csv")
health <- read.csv("Health and Survival.csv")
life <- read.csv("Healthy Life Expectancy.csv")
LFP <- read.csv("Labor Force Participation.csv")
literacy <- read.csv("Literacy Rate.csv")
LOM <- read.csv("LOM.csv")
minister <- read.csv("Ministerial Positions.csv")
poli_emp <- read.csv("Political Empowerment.csv")
primary <- read.csv("Primary Edu Enrollment.csv")
pro_tech <- read.csv("Professional and Technical.csv")
secondary <- read.csv("Secondary Edu Enrollment.csv")
sex_ratio <- read.csv("Sex Ratio at Birth.csv")
tertiary <- read.csv("Tertiary Edu Enrollment.csv")
wage <- read.csv("Wage Equality.csv")
parliament <- read.csv("Women in Parliament.csv")

overall$color <- "#e6e6e8"
overall[which((overall$Country %in% BRICS)==T),5] <- "#867A72"
overall[which(overall$Country=="China"),5] <- "#913c3c"

# summary of ranking - line chart
overall$rerank<- 0
for (i in 1:837){
  if (overall[i,4]==2016){overall[i,6]<- (145-overall[i,3])/144}
  else if (overall[i,4]==2015){overall[i,6]<- (146-overall[i,3])/145}
  else if (overall[i,4]==2014){overall[i,6]<- (143-overall[i,3])/142}
  else if (overall[i,4]==2013){overall[i,6]<- (137-overall[i,3])/136}
  else if (overall[i,4]==2012){overall[i,6]<- (136-overall[i,3])/135}
  else if (overall[i,4]==2011){overall[i,6]<- (136-overall[i,3])/135}
}

x <- data.frame(Country=c("Fake", "Fake"), Score=c(0,1), Rank=c(0,0), Year=c(2011,2016), 
                color=c("white","white"), rerank=c(1,0))
overall <- rbind(overall,x)

ggplot(overall, aes(x=Year, y=rerank, group=Country, color=color))+
  geom_line(size=1)+
  scale_color_manual(values=c("#867A72", "#913c3c","#e6e6e8"))+
  theme(panel.background = element_rect(fill = "#000000"),
        panel.border= element_blank())

eco_par <- eco_par[which((eco_par$Country %in% BRICS)==T),]
overall <- overall[which((overall$Country %in% BRICS)==T),]
edu_att <- edu_att[which((edu_att$Country %in% BRICS)==T),]
income <- income[which((income$Country %in% BRICS)==T),]
head_state <- head_state[which((head_state$Country %in% BRICS)==T),]
health <- health[which((health$Country %in% BRICS)==T),]
life <- life[which((life$Country %in% BRICS)==T),]
LFP <- LFP[which((LFP$Country %in% BRICS)==T),]
literacy <- literacy[which((literacy$Country %in% BRICS)==T),]
LOM <- LOM[which((LOM$Country %in% BRICS)==T),]
minister <- minister[which((minister$Country %in% BRICS)==T),]
poli_emp <- poli_emp[which((poli_emp$Country %in% BRICS)==T),]
primary <- primary[which((primary$Country %in% BRICS)==T),]
pro_tech <- pro_tech[which((pro_tech$Country %in% BRICS)==T),]
secondary <- secondary[which((secondary$Country %in% BRICS)==T),]
sex_ratio <- sex_ratio[which((sex_ratio$Country %in% BRICS)==T),]
tertiary <- tertiary[which((tertiary$Country %in% BRICS)==T),]
wage <- wage[which((wage$Country %in% BRICS)==T),]
parliament <- parliament[which((parliament$Country %in% BRICS)==T),]

# summary of the four major categories - mountain chart
x <- data.frame(Country="Fake", Score=1, Rank=1, Year=2017)

plots <-list()
for (i in BRICS){
  temp <- eco_par[which(eco_par$Country==i),]
  x$Score <- temp[which(temp$Year==2016),2]
  temp <- rbind(temp, x)
  p1 <- ggplot(temp, aes(x=Year, y=Score, color="white"))+
                 geom_step()+ ggtitle(i)+
    theme(panel.background = element_rect(fill = "#000000"),
          panel.border= element_blank(), panel.grid.major=element_line(colour=NA))
  plots[[i]] <- p1
  }
do.call("grid.arrange", c(plots, ncol=1, nrow=5))

plots <-list()
for (i in BRICS){
  temp <- edu_att[which(edu_att$Country==i),]
  x$Score <- temp[which(temp$Year==2016),2]
  temp <- rbind(temp, x)
  p1 <- ggplot(temp, aes(x=Year, y=Score, color="white"))+
    geom_step()+ ggtitle(i)+
    theme(panel.background = element_rect(fill = "#000000"),
          panel.border= element_blank(), panel.grid.major=element_line(colour=NA))
  plots[[i]] <- p1
}
do.call("grid.arrange", c(plots, ncol=1, nrow=5))

plots <-list()
for (i in BRICS){
  temp <- health[which(health$Country==i),]
  x$Score <- temp[which(temp$Year==2016),2]
  temp <- rbind(temp, x)
  p1 <- ggplot(temp, aes(x=Year, y=Score, color="white"))+
    geom_step()+ ggtitle(i)+
    theme(panel.background = element_rect(fill = "#000000"),
          panel.border= element_blank(), panel.grid.major=element_line(colour=NA))
  plots[[i]] <- p1
}
do.call("grid.arrange", c(plots, ncol=1, nrow=5))

plots <-list()
for (i in BRICS){
  temp <- poli_emp[which(poli_emp$Country==i),]
  x$Score <- temp[which(temp$Year==2016),2]
  temp <- rbind(temp, x)
  p1 <- ggplot(temp, aes(x=Year, y=Score, color="white"))+
    geom_step()+ ggtitle(i)+
    theme(panel.background = element_rect(fill = "#000000"),
          panel.border= element_blank(), panel.grid.major=element_line(colour=NA))
  plots[[i]] <- p1
}
do.call("grid.arrange", c(plots, ncol=1, nrow=5))

# break-down of smaller categories

LFP$cat <- "1LFP"
wage$cat <- "2wage"
income$cat <- "3income"
LOM$cat <- "4LOM"
pro_tech$cat <- "5pro-tech"
literacy$cat <- "6literacy"
primary$cat <- "7primary_edu"
secondary$cat <- "8secondary_edu"
tertiary$cat <- "9tertiary_edu"
sex_ratio$cat <- "91sex_ratio"
life$cat <- "92life_exp"
parliament$cat <- "93parliament"
minister$cat <- "94ministerial_position"
head_state$cat <- "95head_of_state"

primary[5,4] <- 1
LOM[5,4] <- 0.03
pro_tech[5,4] <- 1.07

breakdown <- rbind(LFP[which(LFP$Year==2016),c(1,4,8)], 
                   wage[which(wage$Year==2016),c(1,3,6)],
                   income[which(income$Year==2016),c(1,6,9)],
                   LOM[which(LOM$Year==2016),c(1,4,8)],
                   pro_tech[which(pro_tech$Year==2016),c(1,4,9)],
                   literacy[which(literacy$Year==2016),c(1,4,8)],
                   primary[which(primary$Year==2016),c(1,4,8)],
                   secondary[which(secondary$Year==2016),c(1,4,8)],
                   tertiary[which(tertiary$Year==2016),c(1,4,8)],
                   sex_ratio[which(sex_ratio$Year==2016),c(1,2,6)],
                   life[which(life$Year==2016),c(1,4,8)],
                   parliament[which(parliament$Year==2016),c(1,4,8)],
                   minister[which(minister$Year==2016),c(1,4,8)],
                   head_state[which(head_state$Year==2016),c(1,4,7)])

plots <-list()
for (i in unique(breakdown$cat)){
  temp <- subset(breakdown, breakdown$cat==i)
  benchmark <- temp[which(temp$Country=="China"),2]
  temp$main_score <- as.numeric(temp$main_score) - as.numeric(benchmark)
  p1 <- ggplot(temp, aes(x = Country, y= main_score))+
    geom_bar(stat= "identity")+
    scale_x_discrete(limits=BRICS)+
    coord_flip()+
    theme(panel.background = element_rect(fill = "white"),
          panel.border= element_blank())+
    ggtitle(i)
  plots[[i]] <- p1
}

do.call("grid.arrange", c(plots, ncol=14, nrow=1))