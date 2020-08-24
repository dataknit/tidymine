microbiome <- read.csv("http://www.exploredata.net/ftp/MicrobiomeWithMetadata.csv") %>%
  janitor::clean_names()

usethis::use_data(microbiome, overwrite = TRUE)
