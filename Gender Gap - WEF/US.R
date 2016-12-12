setwd("E:\\—ßœ∞œ‡πÿ\\R\\Program_for_Fun\\Gender Gap - WEF")
library(ggplot2)

### Final Score (all countries)

total <- read.csv("Overall.csv")

total$color <- "#adb0c9"
total[which(total$Country=="United States"),5] <- "#ffea07"

total$rerank<- 0
for (i in 1:837){
  if (total[i,4]==2016){total[i,6]<- (145-total[i,3])/144}
  else if (total[i,4]==2015){total[i,6]<- (146-total[i,3])/145}
  else if (total[i,4]==2014){total[i,6]<- (143-total[i,3])/142}
  else if (total[i,4]==2013){total[i,6]<- (137-total[i,3])/136}
  else if (total[i,4]==2012){total[i,6]<- (136-total[i,3])/135}
  else if (total[i,4]==2011){total[i,6]<- (136-total[i,3])/135}
}

ggplot(total, aes(x=Year, y=rerank, group=Country, color=color))+
  geom_line(size=0.8)+
  scale_color_manual(values=c("#adb0c9", "#ffea07"))+
  theme(panel.background = element_rect(fill = "#d3d3d3", color="#696969",size=2),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank())

### eco (all countries)

eco <- read.csv("Economic Participation.csv")

eco$color <- "#adb0c9"
eco[which(eco$Country=="United States"),5] <- "#ffea07"

eco$rerank<- 0
for (i in 1:837){
  if (eco[i,4]==2016){eco[i,6]<- (145-eco[i,3])/144}
  else if (eco[i,4]==2015){eco[i,6]<- (146-eco[i,3])/145}
  else if (eco[i,4]==2014){eco[i,6]<- (143-eco[i,3])/142}
  else if (eco[i,4]==2013){eco[i,6]<- (137-eco[i,3])/136}
  else if (eco[i,4]==2012){eco[i,6]<- (136-eco[i,3])/135}
  else if (eco[i,4]==2011){eco[i,6]<- (136-eco[i,3])/135}
}

ggplot(eco, aes(x=Year, y=rerank, group=Country, color=color))+
  geom_line(size=0.8)+
  scale_color_manual(values=c("#adb0c9", "#ffea07"))+
  theme(panel.background = element_rect(fill = "#d3d3d3", color="#696969",size=2),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank())

### edu (all countries)

edu <- read.csv("Edu Attainment.csv")

edu$color <- "#adb0c9"
edu[which(edu$Country=="United States"),5] <- "#ffea07"

edu$rerank<- 0
for (i in 1:837){
  if (edu[i,4]==2016){edu[i,6]<- (145-edu[i,3])/144}
  else if (edu[i,4]==2015){edu[i,6]<- (146-edu[i,3])/145}
  else if (edu[i,4]==2014){edu[i,6]<- (143-edu[i,3])/142}
  else if (edu[i,4]==2013){edu[i,6]<- (137-edu[i,3])/136}
  else if (edu[i,4]==2012){edu[i,6]<- (136-edu[i,3])/135}
  else if (edu[i,4]==2011){edu[i,6]<- (136-edu[i,3])/135}
}

ggplot(edu, aes(x=Year, y=rerank, group=Country, color=color))+
  geom_line(size=0.8)+
  scale_color_manual(values=c("#adb0c9", "#ffea07"))+
  theme(panel.background = element_rect(fill = "#d3d3d3", color="#696969",size=2),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank())

### health (all countries)

health <- read.csv("Health and Survival.csv")

health$color <- "#adb0c9"
health[which(health$Country=="United States"),5] <- "#ffea07"

health$rerank<- 0
for (i in 1:837){
  if (health[i,4]==2016){health[i,6]<- (145-health[i,3])/144}
  else if (health[i,4]==2015){health[i,6]<- (146-health[i,3])/145}
  else if (health[i,4]==2014){health[i,6]<- (143-health[i,3])/142}
  else if (health[i,4]==2013){health[i,6]<- (137-health[i,3])/136}
  else if (health[i,4]==2012){health[i,6]<- (136-health[i,3])/135}
  else if (health[i,4]==2011){health[i,6]<- (136-health[i,3])/135}
}

ggplot(health, aes(x=Year, y=rerank, group=Country, color=color))+
  geom_line(size=0.8)+
  scale_color_manual(values=c("#adb0c9", "#ffea07"))+
  theme(panel.background = element_rect(fill = "#d3d3d3", color="#696969",size=2),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank())

### politics (all countries)

politics <- read.csv("Political Empowerment.csv")

politics$color <- "#adb0c9"
politics[which(politics$Country=="United States"),5] <- "#ffea07"

politics$rerank<- 0
for (i in 1:837){
  if (politics[i,4]==2016){politics[i,6]<- (145-politics[i,3])/144}
  else if (politics[i,4]==2015){politics[i,6]<- (146-politics[i,3])/145}
  else if (politics[i,4]==2014){politics[i,6]<- (143-politics[i,3])/142}
  else if (politics[i,4]==2013){politics[i,6]<- (137-politics[i,3])/136}
  else if (politics[i,4]==2012){politics[i,6]<- (136-politics[i,3])/135}
  else if (politics[i,4]==2011){politics[i,6]<- (136-politics[i,3])/135}
}

ggplot(politics, aes(x=Year, y=rerank, group=Country, color=color))+
  geom_line(size=0.8)+
  scale_color_manual(values=c("#adb0c9", "#ffea07"))+
  theme(panel.background = element_rect(fill = "#d3d3d3", color="#696969",size=2),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank())

### eco (US 2016)
Cincome <- read.csv("Est. Earned Income.csv")
ALFP <- read.csv("Labor Force Participation.csv")
DLOM <- read.csv("LOM.csv")
Epro_tech <- read.csv("Professional and Technical.csv")
Bwage <- read.csv("Wage Equality.csv")

index <- c("ALFP", "Bwage", "Cincome", "DLOM", "Epro_tech")
value <- c(ALFP[which(ALFP$Country=="United States" & ALFP$Year==2016),5],
           Bwage[which(Bwage$Country=="United States" & Bwage$Year==2016),3],
           Cincome[which(Cincome$Country=="United States" & Cincome$Year=="2016"),6],
           DLOM[which(DLOM$Country=="United States" & DLOM$Year==2016),5],
           Epro_tech[which(Epro_tech$Country=="United States" & Epro_tech$Year==2016),5])
eco_US <- as.data.frame(index)
eco_US$index <- as.character(eco_US$index)
eco_US <- cbind(eco_US, as.data.frame(value))
eco_US <- rbind(eco_US, c("AZLFP", 1-0.86), c("BZwage", 1-0.65), 
                c("CZincome",1-0.65), c("DZLOM", 1-0.65), c("EZpro_tech", 1-1))
eco_US$value <- as.numeric(eco_US$value)
eco_US[1,2] <- eco_US[1,2]*0.199
eco_US[6,2] <- eco_US[6,2]*0.199
eco_US[2,2] <- eco_US[2,2]*0.31
eco_US[7,2] <- eco_US[7,2]*0.31
eco_US[3,2] <- eco_US[3,2]*0.221
eco_US[8,2] <- eco_US[8,2]*0.221
eco_US[4,2] <- eco_US[4,2]*0.149
eco_US[9,2] <- eco_US[9,2]*0.149
eco_US[5,2] <- eco_US[5,2]*0.121
eco_US[10,2] <- eco_US[10,2]*0.121
eco_US$color <- "#ffea07"
eco_US[c(6:10),3] <- "#adb0c9"

eco_US[1,1] <- "aLFP"
eco_US[6,1] <- "aLFP"
eco_US[2,1] <- "bwage"
eco_US[7,1] <- "bwage"
eco_US[3,1] <- "cincome"
eco_US[8,1] <- "cincome"
eco_US[4,1] <- "dLOM"
eco_US[9,1] <- "dLOM"
eco_US[5,1] <- "epro_tech"
eco_US[10,1] <- "epro_tech"

ggplot(eco_US,aes(x=index,y=value,group=color, fill=color))+
  geom_bar(stat="identity")+
  scale_fill_manual(values=c("#adb0c9","#ffea07"))+
  theme(panel.background = element_rect(fill = "#d3d3d3", color="#696969",size=2),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank())


ggplot(eco_US[order(eco_US$index),], aes(x="", y=value, group=index, fill=color))+
  geom_bar(stat = "identity", width=0.1, color="#d3d3d3",size=1)+
  scale_fill_manual(values=c("#adb0c9","#ffea07"))+
  coord_polar(theta="y")+
  theme(panel.background = element_blank(),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank())

### edu (US 2016)
literacy <- read.csv("Literacy Rate.csv")
primary <- read.csv("Primary Edu Enrollment.csv")
secondary <- read.csv("Secondary Edu Enrollment.csv")
tertiary <- read.csv("Tertiary Edu Enrollment.csv")

index <- c("Aliteracy", "Bprimary", "Csecondary", "Dtertiary")
value <- c(literacy[which(literacy$Country=="United States" & literacy$Year==2016),5],
           primary[which(primary$Country=="United States" & primary$Year==2016),5],
           secondary[which(secondary$Country=="United States" & secondary$Year==2016),5],
           tertiary[which(tertiary$Country=="United States" & tertiary$Year==2016),5])

edu_US <- cbind(as.data.frame(index), as.data.frame(value))

edu_US$value <- as.numeric(edu_US$value)
edu_US[1,2] <- edu_US[1,2]*0.191
edu_US[2,2] <- edu_US[2,2]*0.459
edu_US[3,2] <- edu_US[3,2]*0.230
edu_US[4,2] <- edu_US[4,2]*0.121

ggplot(edu_US, aes(x=index, y=value))+
  geom_bar(stat="identity")+
  theme(panel.background = element_rect(fill = "#d3d3d3", color="#696969",size=2),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank())

ggplot(edu_US, aes(x="", y=value, group=index))+
  geom_bar(stat = "identity", width=0.1, color="#d3d3d3",size=1, fill="#ffea07")+
  coord_polar(theta="y")+
  theme(panel.background = element_blank(),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank())

### health (US 2016)
life <- read.csv("Healthy Life Expectancy.csv")
sex_ratio <- read.csv("Sex Ratio at Birth.csv")

index <- c("Aratio", "Bexp")
value <- c(sex_ratio[which(sex_ratio$Country=="United States" & sex_ratio$Year==2016),3],
           life[which(life$Country=="United States" & life$Year==2015),5])

health_US <- cbind(as.data.frame(index), as.data.frame(value))

health_US$value <- as.numeric(health_US$value)
health_US$index <- as.character(health_US$index)
health_US[1,2] <- health_US[1,2]/0.944
health_US[2,2] <- health_US[2,2]/1.06
health_US <- rbind(health_US, c("AZratio", as.numeric(1-1)), c("BZexp", as.numeric(1-0.9811321)))

health_US$value <- as.numeric(health_US$value)
health_US[1,2] <- health_US[1,2]*0.693
health_US[3,2] <- health_US[3,2]*0.693
health_US[2,2] <- health_US[2,2]*0.307
health_US[4,2] <- health_US[4,2]*0.307

health_US$color <- "#ffea07"
health_US[c(3:4),3] <- "#adb0c9"
health_US[3,1]<- "Aratio"
health_US[4,1]<- "Bexp"

ggplot(health_US,aes(x=index,y=value,group=color, fill=color))+
  geom_bar(stat="identity")+
  scale_fill_manual(values=c("#adb0c9","#ffea07"))+
  theme(panel.background = element_rect(fill = "#d3d3d3", color="#696969",size=2),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank())

ggplot(health_US[order(health_US$index),], aes(x="", y=value, group=index, fill=color))+
  geom_bar(stat = "identity", width=0.1, color="#d3d3d3",size=1)+
  scale_fill_manual(values=c("#adb0c9","#ffea07"))+
  coord_polar(theta="y")+
  theme(panel.background = element_blank(),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank())

### political (US 2016)
head_state <- read.csv("Female Head of State.csv")
minister <- read.csv("Ministerial Positions.csv")
parliament <- read.csv("Women in Parliament.csv")

index <- c("Aparlia", "Bmini", "Chead")
value <- c(parliament[which(parliament$Country=="United States" & parliament$Year==2016),5],
           minister[which(minister$Country=="United States" & minister$Year==2016),5],
           head_state[which(head_state$Country=="United States" & head_state$Year==2016),4])

po_US <- cbind(as.data.frame(index), as.data.frame(value))

po_US$index <- as.character(po_US$index)

po_US <- rbind(po_US, c("AZparlia", 1-0.24), c("BZmini", 1-0.35), c("CZhead", 1))
po_US$value <- as.numeric(po_US$value)
po_US[1,2] <- po_US[1,2]*0.31
po_US[4,2] <- po_US[4,2]*0.31
po_US[2,2] <- po_US[2,2]*0.247
po_US[5,2] <- po_US[5,2]*0.247
po_US[3,2] <- po_US[3,2]*0.443
po_US[6,2] <- po_US[6,2]*0.443

po_US$color <- "#ffea07"
po_US[c(4:6),3] <- "#adb0c9"

po_US[4,1] <- "Aparlia"
po_US[5,1] <- "Bmini"
po_US[6,1] <- "Chead"

ggplot(po_US,aes(x=index,y=value,group=color, fill=color))+
  geom_bar(stat="identity")+
  scale_fill_manual(values=c("#adb0c9","#ffea07"))+
  theme(panel.background = element_rect(fill = "#d3d3d3", color="#696969",size=2),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank())

ggplot(po_US[order(po_US$index),], aes(x="", y=value, group=index, fill=color))+
  geom_bar(stat = "identity", width=0.1, color="#d3d3d3",size=1)+
  scale_fill_manual(values=c("#adb0c9","#ffea07"))+
  coord_polar(theta="y")+
  theme(panel.background = element_blank(),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank())