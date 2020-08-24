spellman <- read.csv("http://www.exploredata.net/ftp/Spellman.csv") %>%
  janitor::clean_names()

usethis::use_data(spellman, overwrite = TRUE)
