## state unemployment
##---------------------------------------------------------

a <- readr::read_tsv("https://download.bls.gov/pub/time.series/la/la.data.3.AllStatesS")

a <- a %>%
  filter(grepl("03$", series_id) & year >= 2000) %>%
  select(-footnote_codes) %>%
  mutate(
    period = as.integer(gsub("M", "", period)),
    state_code = substr(series_id, 6, 7))

# https://www.bls.gov/sae/saestruct.htm
b <- readr::read_tsv("https://download.bls.gov/pub/time.series/sm/sm.state")

a <- left_join(a, b) %>%
  filter(state_name != "Puerto Rico")

sn <- unique(a$state_name)
sn[which(! sn %in% state.name)]

state_name2 <- c(state.name, "District of Columbia")
state_abb2 <- c(state.abb, "DC")

pars <- as.list(state_abb2)
names(pars) <- state_name2

a$state <- do.call(recode, c(list(a$state_name), pars))
a <- select(a, -series_id, -state_code, -state_name)

a2 <- filter(a, period == 12)
a2 <- select(a2, -period)
a2 <- rename(a2, rate = value)

state_unemp <- data.frame(a2)

use_data(state_unemp, overwrite = TRUE)
