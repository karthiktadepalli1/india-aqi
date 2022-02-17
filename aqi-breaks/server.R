#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
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

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    dataset <- reactive({
        read.csv("./city_full.csv") %>%
            filter(City %in% cities) %>%
            mutate(Date = as.Date(Date)) %>%
            filter(Date >= "2020-01-01") %>%
            arrange(City, Date) %>% 
            mutate(AQI_MA7 = rollapplyr(AQI, 7, mean, fill=NA))
    })
    output$distPlot <- renderPlot({

        # draw the histogram with the specified number of bins
        dataset() %>% 
            mutate(Post = ifelse(Date > input$dateslider, 1, 0)) %>%
            ggplot(aes(x = Date, y = AQI_MA7, color = City, group = Post)) + 
            geom_line()  + 
            geom_smooth(method = 'lm') + 
            geom_vline(xintercept = input$dateslider, linetype=4) + 
            facet_wrap(~City) + 
            labs(y = "7-day moving average of AQI") + 
            theme(legend.position = "none")
    })

})
