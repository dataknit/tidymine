# Data from http://www.exploredata.net/Downloads/Baseball-Data-Set

mlb_2008 <- read.csv("http://www.exploredata.net/ftp/MLB2008.csv") %>%
  janitor::clean_names()

usethis::use_data(mlb_2008, overwrite = TRUE)
