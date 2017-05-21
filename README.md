[![Build Status](https://travis-ci.org/hafen/geofacet.svg?branch=master)](https://travis-ci.org/hafen/geofacet)
[![Coverage Status](https://img.shields.io/codecov/c/github/hafen/geofacet/master.svg)](https://codecov.io/github/hafen/geofacet?branch=master)

# geofacet

This R package provides geofaceting functionality for ggplot2. Geofaceting arranges a sequence of plots of data for different geographical entities into a grid that strives to preserve some of the original geographical orientation of the entities. It's easiest to describe with examples. See below.

## Install

```r
devtools::install_github("hafen/geofacet")
```

## Example

Barchart of state rankings in various categories:

```r
library(ggplot2)

ggplot(state_ranks, aes(variable, rank, fill = variable)) +
  geom_col() +
  coord_flip() +
  facet_geo(~ state) +
  theme_bw()
```

![us_categories](https://cloud.githubusercontent.com/assets/1275592/26282369/611ab89e-3dc5-11e7-86eb-65685cc2948b.png)

Unemployment rate time series for each state:

```r
ggplot(state_unemp, aes(year, rate)) +
  geom_line() +
  facet_geo(~ state, grid = "us_state_grid2") +
  scale_x_continuous(labels = function(x) paste0("'", substr(x, 3, 4))) +
  ylab("Unemployment Rate (%)")
```

![us_unemp](https://cloud.githubusercontent.com/assets/1275592/26282368/6118d06a-3dc5-11e7-96b4-6a511800b6d3.png)
