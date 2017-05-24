# https://graphics.axios.com/2017-05-01-proj-emoji-states-of-america/index.html?c=0&initialWidth=802&childId=emoji-chernoff&parentTitle=The%20Emoji%20States%20of%20America%20-%20Axios&parentUrl=https%3A%2F%2Fwww.axios.com%2Fan-emoji-built-from-data-for-every-state-2408885674.html

state_stats <- jsonlite::fromJSON("_ignore/state_data.json")

library(tidyr)
library(dplyr)

state_stats <- gather(state_stats, variable, value, 3:14) %>%
  arrange(postal, variable)

state_ranks <- filter(state_stats, grepl("-rank", variable)) %>%
  mutate(variable = gsub("-rank", "", variable)) %>%
  rename(rank = value, state = postal)

state_ranks$variable <- recode(state_ranks$variable,
  uninsured = "insured", poverty = "wealth", jobless = "employment",
  bachelor = "education", obesity = "health")

state_ranks <- data.frame(state_ranks)

use_data(state_ranks, overwrite = TRUE)
