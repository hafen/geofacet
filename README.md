[![Build Status](https://travis-ci.org/hafen/geofacet.svg?branch=master)](https://travis-ci.org/hafen/geofacet)
[![codecov.io](https://codecov.io/github/hafen/geofacet/coverage.svg?branch=master)](https://codecov.io/github/hafen/geofacet?branch=master)

# geofacet

This R package provides geofaceting functionality for ggplot2. Geofaceting arranges a sequence of plots of data for different geographical entities into a grid that strives to preserve some of the original geographical orientation of the entities. It's easiest to describe with examples. See below.

## Install

```r
devtools::install_github("hafen/geofacet")
```

## Example

Barchart of state rankings in various categories:

```r
ggplot(state_ranks, aes(variable, rank, fill = variable)) +
  geom_col() +
  coord_flip() +
  facet_geo(~ state) +
  theme_bw()
```

Unemployment rate time series for each state:

```r
ggplot(state_unemp, aes(year, rate)) +
  geom_line() +
  facet_geo(~ state, grid = "us_state_grid2") +
  scale_x_continuous(labels = function(x) paste0("'", substr(x, 3, 4))) +
  ylab("Unemployment Rate (%)")
```
