# Data from www.exploredata.net/ftp/WHO.csv

who <- read.csv("http://www.exploredata.net/ftp/WHO.csv") %>%
  janitor::clean_names()

usethis::use_data(who, overwrite = TRUE)
