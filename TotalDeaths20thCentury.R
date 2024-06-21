library(ggplot2)
library(tidyverse)

url <- "https://raw.githubusercontent.com/kjemist/TotalDeaths20thCentury/main/20thCenturyDeathsInUS-CDC.csv"

TotalDeaths <- read.csv(url)

TotalDeaths <- TotalDeaths %>% replace(is.na(.), 0) #set NA to 0 so we can add col values together
TotalDeaths$Infection...Death.Rates <- TotalDeaths$Pneumonia.and.influenza...Death.Rates + 
                                        TotalDeaths$Tuberculosis...Death.Rates + 
                                        TotalDeaths$Respiratory.disease...Death.Rates +
                                        TotalDeaths$Kidney.infection...Death.Rates
TotalDeaths$NonInfection...Death.Rates <- TotalDeaths$Total.deaths...Death.Rates - TotalDeaths$Infection...Death.Rates

TotalDeaths

TotalDeaths[TotalDeaths <= 0] <- NA #reset NA-values so that plot does not misbehave

<- ggplot(TotalDeaths, aes(x = Year)) +
  geom_line(data=TotalDeaths[!is.na(TotalDeaths$Total.deaths...Death.Rates),], aes(y=Total.deaths...Death.Rates)) + #here only a subset of years who has actually reported death numbers. 1946 is missing.
  #geom_line(aes(y=Pneumonia.and.influenza...Death.Rates)) +
  geom_line(aes(y=Infection...Death.Rates)) +
  geom_line(data=TotalDeaths[!is.na(TotalDeaths$NonInfection...Death.Rates),], aes(y=NonInfection...Death.Rates)) + #same here as above
  theme_classic()
