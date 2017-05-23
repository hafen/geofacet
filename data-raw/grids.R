us_state_grid1 <- readr::read_csv("code,row,col,name
AL,6,7,Alabama
AK,7,2,Alaska
AZ,5,2,Arizona
AR,5,5,Arkansas
CA,4,1,California
CO,4,3,Colorado
CT,3,10,Connecticut
DE,4,10,Delaware
FL,7,9,Florida
GA,6,8,Georgia
HI,7,1,Hawaii
ID,2,2,Idaho
IL,2,6,Illinois
IN,3,6,Indiana
IA,3,5,Iowa
KS,5,4,Kansas
KY,4,6,Kentucky
LA,6,5,Louisiana
ME,1,11,Maine
MD,4,9,Maryland
MA,2,10,Massachusetts
MI,2,7,Michigan
MN,2,5,Minnesota
MS,6,6,Mississippi
MO,4,5,Missouri
MT,2,3,Montana
NE,4,4,Nebraska
NV,3,2,Nevada
NH,1,10,New Hampshire
NJ,3,9,New Jersey
NM,5,3,New Mexico
NY,2,9,New York
NC,5,7,North Carolina
ND,2,4,North Dakota
OH,3,7,Ohio
OK,6,4,Oklahoma
OR,3,1,Oregon
PA,3,8,Pennsylvania
RI,3,11,Rhode Island
SC,5,8,South Carolina
SD,3,4,South Dakota
TN,5,6,Tennessee
TX,7,4,Texas
UT,4,2,Utah
VT,1,9,Vermont
VA,4,8,Virginia
WA,2,1,Washington
WV,4,7,West Virginia
WI,1,6,Wisconsin
WY,3,3,Wyoming
DC,5,9,District of Columbia
")

grid_preview(us_state_grid1)

us_state_grid1 <- data.frame(us_state_grid1)
use_data(us_state_grid1, overwrite = TRUE)

##
##---------------------------------------------------------

us_state_grid2 <- readr::read_csv("code,row,col,name
AL,6,7,Alabama
AK,1,1,Alaska
AZ,6,2,Arizona
AR,6,5,Arkansas
CA,6,1,California
CO,5,3,Colorado
CT,2,10,Connecticut
DE,4,11,Delaware
FL,7,9,Florida
GA,6,8,Georgia
HI,8,1,Hawaii
ID,4,2,Idaho
IL,4,6,Illinois
IN,4,7,Indiana
IA,4,5,Iowa
KS,5,4,Kansas
KY,5,7,Kentucky
LA,7,5,Louisiana
ME,1,12,Maine
MD,5,10,Maryland
MA,2,11,Massachusetts
MI,3,7,Michigan
MN,3,5,Minnesota
MS,6,6,Mississippi
MO,5,5,Missouri
MT,3,2,Montana
NE,4,4,Nebraska
NV,5,1,Nevada
NH,1,11,New Hampshire
NJ,3,10,New Jersey
NM,6,3,New Mexico
NY,2,9,New York
NC,5,9,North Carolina
ND,3,3,North Dakota
OH,4,8,Ohio
OK,6,4,Oklahoma
OR,4,1,Oregon
PA,3,9,Pennsylvania
RI,3,11,Rhode Island
SC,6,9,South Carolina
SD,3,4,South Dakota
TN,5,6,Tennessee
TX,7,4,Texas
UT,5,2,Utah
VT,1,10,Vermont
VA,4,9,Virginia
WA,3,1,Washington
WV,5,8,West Virginia
WI,3,6,Wisconsin
WY,4,3,Wyoming
DC,4,10,District of Columbia
")

grid_preview(us_state_grid2)

us_state_grid2 <- data.frame(us_state_grid2)
use_data(us_state_grid2, overwrite = TRUE)

## eu
##---------------------------------------------------------

eu_grid1 <- readr::read_csv("code,row,col,name
BE,4,3,Belgium
BG,6,6,Bulgaria
CZ,4,4,Czech Republic
DK,2,3,Denmark
DE,3,4,Germany
EE,2,7,Estonia
IE,1,1,Ireland
EL,7,6,Greece
ES,5,2,Spain
FR,4,2,France
HR,6,5,Croatia
IT,6,3,Italy
CY,7,7,Cyprus
LV,2,6,Latvia
LT,3,6,Lithuania
LU,5,3,Luxembourg
HU,5,5,Hungary
MT,7,3,Malta
NL,3,3,Netherlands
AT,5,4,Austria
PL,3,5,Poland
PT,5,1,Portugal
RO,5,6,Romania
SI,6,4,Slovenia
SK,4,5,Slovakia
FI,1,5,Finland
SE,1,4,Sweden
UK,2,1,United Kingdom
")

grid_preview(eu_grid1, use_code = FALSE)

eu_grid1 <- data.frame(eu_grid1)
use_data(eu_grid1, overwrite = TRUE)

## Australian States / Territories
##---------------------------------------------------------

aus_grid1  <- readr::read_csv("code,row,col,name
WA,2,1,Western Australia
NT,1,2,Northern Territory
SA,2,2,South Australia
QLD,1,3,Queensland
NSW,2,3,New South Wales
ACT,3,4,Australian Capital Territory
VIC,3,3,Victoria
TAS,5,3,Tasmania
")

grid_preview(aus_grid1)

aus_grid1 <- data.frame(aus_grid1)
use_data(aus_grid1, overwrite = TRUE)
