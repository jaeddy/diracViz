#library(rCharts)

# Testing basic functionality of rCharts library with online examples

# Test 1: Morris
data(economics, package = "ggplot2")
econ <- transform(economics, date = as.character(date))
m1 <- mPlot(x = "date", y = c("psavert", "uempmed"), type = "Line", 
            data = econ)
m1$set(pointSize = 0, lineWidth = 1)
m1$print("chart2")
m1

# Test 2: NVD3
hair_eye_male <- subset(as.data.frame(HairEyeColor), Sex == "Male")
head(hair_eye_male)
n1 <- nPlot(Freq ~ Hair, group = "Eye", data = hair_eye_male,
            type = "multiBarChart")
n1$print("chart3")
n1

# Test 3: parcoords

# source("http://bioconductor.org/biocLite.R")
# biocLite("EBImage")

packrat::install_github("ramnathv/rCharts@dev")
packrat::install_github("rblocks/ramnathv")
packrat::install_github("woobe/rPlotter")

#library(rCharts)
#library(rPlotter)

## Using Theoph as the demo data.
dat <- Theoph

## Initialise rCharts-parcoords
p1 <- rCharts$new()
p1$setLib("http://rcharts.github.io/parcoords/libraries/widgets/parcoords")

## Adjust output size
p1$set(padding = list(top = 50, bottom = 50,
                      left = 50, right = 50),
       width = 960, height = 500)

## Brew some colours with rPlotter x Bart Simpson
set.seed(1234)
n_col <- length(unique(dat$Subject))
pal <- colorRampPalette(extract_colours(
    "http://www.allfreevectors.com/images/Free%20Vector%20Bart%20Simpson%2002%20The%20Simpsons2980.jpg",
    7), interpolate = "spline")(n_col)

## rCharts magic here ...
p1$set(
    data = toJSONArray(dat, json = F),
    range = unique(dat$Subject),
    colorby = 'Subject',
    colors = pal)

## Remember to add "afterScript" (this is needed for now)
p1$setTemplate(afterScript = '<script></script>')

## Save as HTML
p1$save("index.html")


