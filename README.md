# tidymine

tidymine provides a tidy interface for calculating statistics from the Maximal Information-based Nonparametric Exploration (MINE) family. MINE statistics are a robust alternative to correlation measures, recognising a range of functional and non-functional relationships between variables.

## Getting Started

### Installation

Install the latest development version from GitHub:

```{r}
if (!require("devtools")) {
  install.packages("devtools")
}
devtools::install_github("joekroese/tidymine")
```

### Examples

```{r}
library(tidyverse)
library(tidymine)

who %>%
  tidymine(net_primary_school_enrolment_ratio_female) %>%
  arrange(-mic)
```
