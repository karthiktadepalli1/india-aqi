pacman::p_load(dplyr, ggplot2, gridExtra)

aqi <- read.csv("city_day.csv") %>% mutate(Date = as.Date(Date))

cities <- c("Delhi", "Bangalore", "Ernakulam", "Visakhapatnam", "Kolkata", "Thiruvananthapuram", "Jaipur")

p1 <- aqi %>% 
  filter(Date > "2019-01-01", City != "Ahmedabad") %>%
  ggplot(aes(x = Date, y = AQI, color = City)) + 
  geom_line()
p1

p2 <- aqi %>% 
  filter(Date > "2020-01-01", City != "Ahmedabad") %>%
  ggplot(aes(x = Date, y = AQI, color = City)) + 
  geom_line()
p2

all <- grid.arrange(p1, p2, nrow = 2) 

ggsave("aqi_all.png", all, width = 16, height = 10)

p3 <- aqi %>% 
  filter(Date > "2019-01-01", City %in% cities) %>%
  ggplot(aes(x = Date, y = AQI, color = City)) + 
  geom_line()
p3

p4 <- aqi %>% 
  filter(Date > "2020-01-01", City %in% cities) %>%
  ggplot(aes(x = Date, y = AQI, color = City)) + 
  geom_line()
p4

select <- grid.arrange(p3, p4, nrow = 2)

ggsave("aqi_select.png", select, width = 16, height = 10)

# comparing dif 

aqi <- aqi %>% 
  mutate(AQI_before = lag(AQI, 365), 
         AQI_dif = AQI - AQI_before,
         Post = ifelse(Date > "2020-03-25", 1, 0))
aqi %>% filter(City %in% cities, Date >= "2020-01-01", Date <= "2020-05-01") %>%
  ggplot(aes(x = Date, y = AQI_dif, color = City)) + 
  geom_line() + 
  labs(y = "AQI change from 365 days ago")



aqi20 <- aqi20 %>% mutate(Time = as.numeric(Date) - 18262)
summary(lm(AQI ~ Time + Post, aqi20))
