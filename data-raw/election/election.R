library(tidyverse)

election <- readr::read_csv("data-raw/election/election.csv") %>%
  gather(candidate, votes, 2:4) %>%
  arrange(state) %>%
  mutate(candidate = factor(candidate, levels = c("Clinton", "Trump", "Other"))) %>%
  group_by(state) %>%
  mutate(pct = 100 * votes / sum(votes)) %>%
  ungroup()

election <- data.frame(election)
devtools::use_data(election, overwrite = TRUE)

##
##---------------------------------------------------------

library(ggplot2)

ggplot(election, aes("", pct, fill = candidate)) +
  geom_col(alpha = 0.8, width = 1) +
  scale_fill_manual(values = c("#4e79a7", "#e15759", "#59a14f")) +
  facet_geo(~ state, grid = "us_state_grid2") +
  scale_y_continuous(expand = c(0, 0)) +
  theme(axis.title.x = element_blank(),
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    strip.text.x = element_text(size = 6))

ggplot(election, aes(candidate, pct, fill = candidate)) +
  geom_col() +
  scale_fill_manual(values = c("#4e79a7", "#e15759", "#59a14f")) +
  facet_geo(~ state, grid = "us_state_grid2") +
  theme_bw() +
  coord_flip() +
  theme(
    strip.text.x = element_text(size = 6))

ggplot(election, aes(candidate, votes / 1000000, fill = candidate)) +
  geom_col() +
  scale_fill_manual(values = c("#4e79a7", "#e15759", "#59a14f")) +
  facet_geo(~ state, grid = "us_state_grid2") +
  coord_flip() +
  ylab("Votes (millions)")
