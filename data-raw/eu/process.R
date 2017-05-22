## gdp per capita
##---------------------------------------------------------

d <- readr::read_csv("data-raw/eu/tec00114.csv")
d <- dplyr::rename(d, code = geo)

cd <- readr::read_csv("data-raw/eu/codes.csv")

d <- dplyr::full_join(d, cd)

eu_codes <- c("BE", "EL", "LT", "PT", "BG", "ES", "LU", "RO", "CZ", "FR", "HU", "SI", "DK",
  "HR", "MT", "SK", "DE", "IT", "NL", "FI", "EE", "CY", "AT", "SE", "IE", "LV", "PL", "UK")

d <- dplyr::filter(d, code %in% eu_codes)
d <- dplyr::select(d, -indic_na, -aggreg95)

d <- tidyr::gather(d, year, gdp_pc, 2:13)
d <- dplyr::arrange(d, code, year)
d <- dplyr::mutate(d, year = as.integer(year))

eu_gdp <- data.frame(d)

use_data(eu_gdp, overwrite = TRUE)

## sources:
# http://ec.europa.eu/eurostat/statistics-explained/index.php/Glossary:Country_codes
# http://ec.europa.eu/eurostat/web/national-accounts/data/main-tables
# [tec00114] - GDP per capita in PPS - Index (EU28 = 100)
# Short Description: Data from 1st December 2016.
# For most recent GDP data, consult dataset nama_10_gdp.
# Gross domestic product (GDP) is a measure for the economic activity. It is defined as the value of all goods and services produced less the value of any goods or services used in their creation. The volume index of GDP per capita in Purchasing Power Standards (PPS) is expressed in relation to the European Union (EU28) average set to equal 100. If the index of a country is higher than 100, this country's level of GDP per head is higher than the EU average and vice versa. Basic figures are expressed in PPS, i.e. a common currency that eliminates the differences in price levels between countries allowing meaningful volume comparisons of GDP between countries. Please note that the index, calculated from PPS figures and expressed with respect to EU28 = 100, is intended for cross-country comparisons rather than for temporal comparisons."

## immigration
##---------------------------------------------------------

imm <- readr::read_csv("data-raw/eu/tps00195.csv")
imm <- dplyr::rename(imm, code = geo)

cd <- readr::read_csv("data-raw/eu/codes.csv")

imm <- dplyr::full_join(imm, cd)

eu_codes <- c("BE", "EL", "LT", "PT", "BG", "ES", "LU", "RO", "CZ", "FR", "HU", "SI", "DK",
  "HR", "MT", "SK", "DE", "IT", "NL", "FI", "EE", "CY", "AT", "SE", "IE", "LV", "PL", "UK")

imm <- dplyr::filter(imm, code %in% eu_codes)
imm <- dplyr::select(imm, -citizen, -sex, -age, -unit)

imm <- tidyr::gather(imm, year, persons, 2:10)
imm <- dplyr::arrange(imm, code, year)
imm <- dplyr::mutate(imm, year = as.integer(year))

eu_imm <- data.frame(imm)

use_data(eu_imm, overwrite = TRUE)

## sources:
# http://ec.europa.eu/eurostat/cache/metadata/en/migr_asydec_esms.htm
# [tps00195] - Resettled persons - annual data - persons
# Short Description: Resettled refugees means persons who have been granted an authorisation to reside in a Member State within the framework of a national or Community resettlement scheme.
