library(rCharts)
library(slidify)

cars <- read.csv('data/cars.csv')
p1 <- rCharts$new()
p1$setLib("http://rcharts.github.io/parcoords/libraries/widgets/parcoords")
p1$set(padding = list(top = 24, left = 0, bottom = 12, right = 200))
p1$set(data = toJSONArray(cars, json = F), 
       colorby = 'economy', 
       range = range(cars$economy),
       colors = c('steelblue', 'brown')
)
p1$print('chart')
p1

p1$set(
    colorby = 'power', 
    range = range(cars$power, na.rm = T),
    colors = c('yellow', 'red')
)
p1$print('chart2')
p1

country_stats <- data.frame(
    country = paste("country ", 1:25), 
    ice_cream_production = rnorm(25), 
    flamenco_appreciation_rate = rnorm(25,mean = -1, sd = 4), 
    beatles_records_sold = rnorm(25, mean = 2)
)
p2 <- rCharts$new()
p2$setLib("http://rcharts.github.io/parcoords/libraries/widgets/parcoords")
p2$set(padding = list(top = 24, left = 0, bottom = 12, right = 200))
p2$set(
    data = toJSONArray(country_stats, json = F),
    colorby = 'flamenco_appreciation_rate',
    range = range(country_stats$flamenco_appreciation_rate),
    colors = c('green', 'purple')
)
p2$print('chart3')
p2
