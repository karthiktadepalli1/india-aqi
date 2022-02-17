#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(ggplot2)
library(zoo)
library(ggthemes)
theme_set(theme_wsj())
cities <- c("Delhi", "Mumbai", "Kolkata", "Bengaluru")

dataset <- read.csv("./city_full.csv") %>%
    filter(City %in% cities) %>%
    mutate(Date = as.Date(Date)) %>%
    filter(Date >= "2020-01-01") %>%
    arrange(City, Date) %>% 
    mutate(AQI_MA7 = rollapplyr(AQI, 7, mean, fill=NA))

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Testing Break Dates for Lockdown and AQI"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            sliderInput("dateslider", 
                        "What date do you want to place a \"lockdown\" at?",
                        min = as.Date("2020-01-01", "%Y-%m-%d"),
                        max = as.Date("2020-07-06", "%Y-%m-%d"),
                        value = as.Date("2020-03-25", "%Y-%m-%d"),
                        timeFormat = "%Y-%m-%d")
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("distPlot")
        )
    )
))

# shinyApp(ui, server = function(input, output) { })