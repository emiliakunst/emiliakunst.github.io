lineplot = read.csv('./data/best_selling_artists_elaborate.csv')
View(lineplot)

library(dplyr)
lineplot1 <- lineplot %>% group_by(Country)

View(lineplot1)
lineplot1 %>% summarise(
  Year
)