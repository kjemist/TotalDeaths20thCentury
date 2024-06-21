library(ggplot2)

url <- "https://raw.githubusercontent.com/kjemist/TotalDeaths20thCentury/main/20thCenturyDeathsInUS-CDC.csv"

TotalDeaths <- read.csv(url)

TotalDeaths$Infection...Death.Rates <- TotalDeaths$Pneumonia.and.influenza...Death.Rates + TotalDeaths$Tuberculosis...Death.Rates

ggplot(TotalDeaths, aes(x = Year, y=Total.deaths...Death.Rates)) +
  geom_line() +
  geom_line(aes(y=Pneumonia.and.influenza...Death.Rates)) +
  geom_line(aes(y=Infection...Death.Rates)) +
  geom_point() +
  theme_classic()
