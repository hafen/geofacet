utils::globalVariables(c("long", "lat", "group", "xcentroid", "ycentroid", "label_col"))

#' auto_states
#'
#' @name auto_states
#' @docType data
#' @keywords data
#' @description List of valid values for countries for fetching rnaturalearth data when used with \code{\link{grid_auto}} to create a grid of states.
#' @rdname auto_names
NULL

#' auto_countries
#'
#' @name auto_countries
#' @docType data
#' @keywords data
#' @description List of valid values for continents for fetching rnaturalearth data when used with \code{\link{grid_auto}} to create a grid of countries.
#' @rdname auto_names
NULL

#' geofacet
#'
#' @name geofacet
#' @docType package
#' @description For examples, see \code{\link{facet_geo}}.
NULL

#' state_ranks
#'
#' @name state_ranks
#' @docType data
#' @description
#' State rankings in the following categories with the variable upon which ranking is based in parentheses: education (adults over 25 with a bachelor's degree in 2015), employment (March 2017 unemployment rate - Bureau of Labor Statistics), health (obesity rate from 2015 - Centers for Disease Control), insured (uninsured rate in 2015 - US Census), sleep (share of adults that report at least 7 hours of sleep each night from 2016 - Disease Control), wealth (poverty rate 2014/15 - US Census). In each category, the lower the ranking, the more favorable. This data is based on data presented here: \url{https://www.axios.com/2017/12/15/the-emoji-states-of-america-1513302318}
#' @usage state_ranks
#' @keywords data
NULL

#' state_unemp
#'
#' @name state_unemp
#' @docType data
#' @description
#' Seasonally-adjusted December unemployment rate for each state (including DC) from 2000 to 2017. Obtained from bls.gov.
#' @usage state_unemp
#' @keywords data
NULL

#' election
#'
#' @name election
#' @docType data
#' @description
#' 2016 US presidential election results, obtained from \url{https://docs.google.com/spreadsheets/d/133Eb4qQmOxNvtesw2hdVns073R68EZx4SfCnP4IGQf8/htmlview?sle=true}.
#' @usage election
#' @keywords data
NULL

#' eu_imm
#'
#' @name eu_imm
#' @docType data
#' @description
#' Annual number of resettled persons for each EU country. "Resettled refugees means persons who have been granted an authorization to reside in a Member State within the framework of a national or Community resettlement scheme.". Source: \url{https://ec.europa.eu/eurostat/cache/metadata/en/migr_asydec_esms.htm}. Dataset ID: tps00195.
#' @usage eu_imm
#' @keywords data
NULL

#' eu_gdp
#'
#' @name eu_gdp
#' @docType data
#' @description
#' GDP per capita in PPS - Index (EU28 = 100). "Gross domestic product (GDP) is a measure for the economic activity. It is defined as the value of all goods and services produced less the value of any goods or services used in their creation. The volume index of GDP per capita in Purchasing Power Standards (PPS) is expressed in relation to the European Union (EU28) average set to equal 100. If the index of a country is higher than 100, this country's level of GDP per head is higher than the EU average and vice versa. Basic figures are expressed in PPS, i.e. a common currency that eliminates the differences in price levels between countries allowing meaningful volume comparisons of GDP between countries. Please note that the index, calculated from PPS figures and expressed with respect to EU28 = 100, is intended for cross-country comparisons rather than for temporal comparisons." Source is no longer available (previously at http://ec.europa.eu/eurostat/web/national-accounts/data/main-tables). Dataset ID: tec00114.
#' @usage eu_gdp
#' @keywords data
NULL

#' aus_pop
#'
#' @name aus_pop
#' @docType data
#' @description
#' March 2017 population data for Australian states and territories by age group. Source: \url{http://lmip.gov.au/default.aspx?LMIP/Downloads/ABSLabourForceRegion}.
#' @usage aus_pop
#' @keywords data
NULL

#' sa_pop_dens
#'
#' @name sa_pop_dens
#' @docType data
#' @description
#' Population density for each province in South Africa for 1996, 2001, and 2011. Source: \url{https://en.wikipedia.org/wiki/List_of_South_African_provinces_by_population_density}
#' @usage sa_pop_dens
#' @keywords data
NULL

#' london_afford
#'
#' @name london_afford
#' @docType data
#' @description
#' Total affordable housing completions by financial year in each London borough since 2015/16. Source: \url{https://data.london.gov.uk/dataset/dclg-affordable-housing-supply-borough}
#' @usage london_afford
#' @keywords data
NULL

#' nhs_scot_dental
#'
#' @name nhs_scot_dental
#' @docType data
#' @description
#' Child dental health data in Scotland. Source: \url{http://statistics.gov.scot/data/child-dental-health}
#' @usage nhs_scot_dental
#' @keywords data
NULL

#' india_pop
#'
#' @name india_pop
#' @docType data
#' @description
#' 2011 population data for India, broken down by urban and rural. Source: \url{https://en.wikipedia.org/wiki/List_of_states_and_union_territories_of_India_by_population}.
#' @usage india_pop
#' @keywords data
NULL
