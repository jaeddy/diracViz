library(rCharts)

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
