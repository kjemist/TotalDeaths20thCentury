library(ggplot2)
library(tidyverse)
library(RColorBrewer)
library(reshape2) # for melt()

url <- "https://raw.githubusercontent.com/kjemist/TotalDeaths20thCentury/main/20thCenturyDeathsInUS-CDC.csv"

TotalDeaths <- read.csv(url)

TotalDeaths <- TotalDeaths %>% replace(is.na(.), 0) #set NA to 0 so we can add col values together
TotalDeaths$Infection...Death.Rates <- TotalDeaths$Pneumonia.and.influenza...Death.Rates + 
                                        TotalDeaths$Tuberculosis...Death.Rates + 
                                        TotalDeaths$Respiratory.disease...Death.Rates +
                                        TotalDeaths$Kidney.infection...Death.Rates
TotalDeaths$NonInfection...Death.Rates <- TotalDeaths$Total.deaths...Death.Rates - TotalDeaths$Infection...Death.Rates


TotalDeaths[TotalDeaths <= 0] <- NA #reset NA-values so that plot does not misbehave


pal <- palette(brewer.pal(n = 3, name = "Set2"))


#subset only relevant cols
TotalDeaths.subset <- TotalDeaths[c("Year", "Total.deaths...Death.Rates", "Infection...Death.Rates", "NonInfection...Death.Rates")]

colnames(TotalDeaths.subset) <- c("Year", "Total deaths", "Infectious-related deaths", "Noninfectious-related deaths")

#converts dataframe from wide to long format https://seananderson.ca/2013/10/19/reshape/. Coloring and legends become easier to operate & handle in ggplot

TotalDeaths.long <- melt(TotalDeaths.subset,
                           id.vars = "Year",
                           value.name = "Death Rates pr. 100.000 [United States]",
                           variable.name = "Death Rate variable") 

ggplot(TotalDeaths.long, aes(x = Year, y = `Death Rates pr. 100.000 [United States]`, color = `Death Rate variable`, group = `Death Rate variable`)) +
  geom_line(data=TotalDeaths.long[!is.na(TotalDeaths.long$`Death Rates pr. 100.000 [United States]`),]) + #here only a subset of years who has actually reported death numbers. 1946 is missing.
  theme_classic() +
  theme(legend.position = "bottom") +
  scale_color_manual(values=pal)
  

# > setwd("./07-VariousProjects/TotalDeaths20thCentury/")
ggsave("./pngs/total_deaths.png", width = 2000, height = 1000, units = "px")
