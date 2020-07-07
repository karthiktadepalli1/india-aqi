# supplement city_day.csv with AQI data from after May 1

pacman::p_load("tabulizer", "dplyr", "ggplot2")

cities <- read.csv("./city_day.csv") %>% pull(City) %>% unique()

date_range <- as.Date("2020-05-02"):as.Date("2020-05-24")

base_df <<- data.frame(City = NA, AQI= NA, Date = NA)
sapply(date_range, function(dat) { 
  datestr <- gsub("-", "", as.character(as.Date(dat)))
  url <- paste0("https://cpcb.nic.in//upload/Downloads/AQI_Bulletin_", datestr, ".pdf")
  # system(paste0("curl ", url, " --output pdfs/", datestr, ".pdf --insecure"))
  tab <- extract_tables(paste0("pdfs/", datestr, ".pdf"))
  tab2 <- tab[seq(1,17,2)]
  df <- as.data.frame(do.call('rbind', tab2)) %>% 
    select(c(City = V2, AQI = V4)) %>%
    filter(City %in% cities) %>%
    mutate(Date = as.Date(dat), AQI = as.numeric(AQI))
  base_df <<- bind_rows(base_df, df)
})
base_df <- base_df[1:nrow(base_df)-1, ]

# merge them to make the full dataset
aqi <- read.csv("./city_day.csv") %>%
  mutate(Date = as.Date(Date)) %>%
  bind_rows(base_df)
write.csv(aqi, "./city_full.csv")