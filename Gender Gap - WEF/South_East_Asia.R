setwd("E:\\Gender Gap")
library(ggplot2)
library(plyr)
library(ggradar)
library(gridExtra)

SEA <- c("China", "Indonesia", "Malaysia", "Philippines", "Thailand", "Singapore", "Vietnam")

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
overall[which((overall$Country %in% SEA)==T),5] <- "#867A72"
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

ggplot(overall, aes(x=Year, y=rerank, group=Country, color=color))+
  geom_line(size=1)+
  scale_color_manual(values=c("#867A72", "#913c3c","#e6e6e8"))+
  theme(panel.background = element_rect(fill = "#CCC0B1"),
        panel.border= element_blank())

eco_par <- eco_par[which((eco_par$Country %in% SEA)==T),]
overall <- overall[which((overall$Country %in% SEA)==T),]
edu_att <- edu_att[which((edu_att$Country %in% SEA)==T),]
income <- income[which((income$Country %in% SEA)==T),]
head_state <- head_state[which((head_state$Country %in% SEA)==T),]
health <- health[which((health$Country %in% SEA)==T),]
life <- life[which((life$Country %in% SEA)==T),]
LFP <- LFP[which((LFP$Country %in% SEA)==T),]
literacy <- literacy[which((literacy$Country %in% SEA)==T),]
LOM <- LOM[which((LOM$Country %in% SEA)==T),]
minister <- minister[which((minister$Country %in% SEA)==T),]
poli_emp <- poli_emp[which((poli_emp$Country %in% SEA)==T),]
primary <- primary[which((primary$Country %in% SEA)==T),]
pro_tech <- pro_tech[which((pro_tech$Country %in% SEA)==T),]
secondary <- secondary[which((secondary$Country %in% SEA)==T),]
sex_ratio <- sex_ratio[which((sex_ratio$Country %in% SEA)==T),]
tertiary <- tertiary[which((tertiary$Country %in% SEA)==T),]
wage <- wage[which((wage$Country %in% SEA)==T),]
parliament <- parliament[which((parliament$Country %in% SEA)==T),]

# summary of the four major categories - radar chart
eco_par$cat <- "1eco_par"
edu_att$cat <- "2edu_att"
poli_emp$cat <- "3poli_emp"
health$cat <- "4health"
radar <- rbind(eco_par, edu_att, poli_emp, health)
radar <- radar[which(radar$Year==2016),]
radar <- radar[, c(1,2,5)]
radar <- reshape(radar, idvar="Country", timevar = "cat", direction= "wide")
ggradar(radar, aes(color=Country))

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

primary[4,4] <- 1
primary[5,4] <- 0.96
primary[6,4] <- 0.93
primary[7,4] <- 0.95
secondary[7,4] <- 0.96
tertiary[7,4] <- 1.16
tertiary[6,4] <- 1.21
parliament[7,4] <- 0.37

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
    scale_x_discrete(limits=SEA)+
    coord_flip()+
    theme(panel.background = element_rect(fill = "white"),
          panel.border= element_blank())+
    ggtitle(i)
  plots[[i]] <- p1
}

do.call("grid.arrange", c(plots, ncol=14, nrow=1))