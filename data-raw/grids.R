us_state_grid1 <- readr::read_csv("row,col,code,name
6,7,AL,Alabama
7,2,AK,Alaska
5,2,AZ,Arizona
5,5,AR,Arkansas
4,1,CA,California
4,3,CO,Colorado
3,10,CT,Connecticut
4,10,DE,Delaware
7,9,FL,Florida
6,8,GA,Georgia
7,1,HI,Hawaii
2,2,ID,Idaho
2,6,IL,Illinois
3,6,IN,Indiana
3,5,IA,Iowa
5,4,KS,Kansas
4,6,KY,Kentucky
6,5,LA,Louisiana
1,11,ME,Maine
4,9,MD,Maryland
2,10,MA,Massachusetts
2,7,MI,Michigan
2,5,MN,Minnesota
6,6,MS,Mississippi
4,5,MO,Missouri
2,3,MT,Montana
4,4,NE,Nebraska
3,2,NV,Nevada
1,10,NH,New Hampshire
3,9,NJ,New Jersey
5,3,NM,New Mexico
2,9,NY,New York
5,7,NC,North Carolina
2,4,ND,North Dakota
3,7,OH,Ohio
6,4,OK,Oklahoma
3,1,OR,Oregon
3,8,PA,Pennsylvania
3,11,RI,Rhode Island
5,8,SC,South Carolina
3,4,SD,South Dakota
5,6,TN,Tennessee
7,4,TX,Texas
4,2,UT,Utah
1,9,VT,Vermont
4,8,VA,Virginia
2,1,WA,Washington
4,7,WV,West Virginia
1,6,WI,Wisconsin
3,3,WY,Wyoming
5,9,DC,District of Columbia
")

grid_preview(us_state_grid1)

us_state_grid1 <- data.frame(us_state_grid1)
devtools::use_data(us_state_grid1, overwrite = TRUE)

##
##---------------------------------------------------------

us_state_grid2 <- readr::read_csv("row,col,code,name
6,7,AL,Alabama
1,1,AK,Alaska
6,2,AZ,Arizona
6,5,AR,Arkansas
6,1,CA,California
5,3,CO,Colorado
2,10,CT,Connecticut
4,11,DE,Delaware
7,9,FL,Florida
6,8,GA,Georgia
8,1,HI,Hawaii
4,2,ID,Idaho
4,6,IL,Illinois
4,7,IN,Indiana
4,5,IA,Iowa
5,4,KS,Kansas
5,7,KY,Kentucky
7,5,LA,Louisiana
1,12,ME,Maine
5,10,MD,Maryland
2,11,MA,Massachusetts
3,7,MI,Michigan
3,5,MN,Minnesota
6,6,MS,Mississippi
5,5,MO,Missouri
3,2,MT,Montana
4,4,NE,Nebraska
5,1,NV,Nevada
1,11,NH,New Hampshire
3,10,NJ,New Jersey
6,3,NM,New Mexico
2,9,NY,New York
5,9,NC,North Carolina
3,3,ND,North Dakota
4,8,OH,Ohio
6,4,OK,Oklahoma
4,1,OR,Oregon
3,9,PA,Pennsylvania
3,11,RI,Rhode Island
6,9,SC,South Carolina
3,4,SD,South Dakota
5,6,TN,Tennessee
7,4,TX,Texas
5,2,UT,Utah
1,10,VT,Vermont
4,9,VA,Virginia
3,1,WA,Washington
5,8,WV,West Virginia
3,6,WI,Wisconsin
4,3,WY,Wyoming
4,10,DC,District of Columbia
")

grid_preview(us_state_grid2)

us_state_grid2 <- data.frame(us_state_grid2)
devtools::use_data(us_state_grid2, overwrite = TRUE)

## eu
##---------------------------------------------------------

eu_grid1 <- readr::read_csv("row,col,code,name
4,3,BE,Belgium
6,6,BG,Bulgaria
4,4,CZ,Czech Republic
2,3,DK,Denmark
3,4,DE,Germany
2,7,EE,Estonia
1,1,IE,Ireland
7,6,EL,Greece
5,2,ES,Spain
4,2,FR,France
6,5,HR,Croatia
6,3,IT,Italy
7,7,CY,Cyprus
2,6,LV,Latvia
3,6,LT,Lithuania
5,3,LU,Luxembourg
5,5,HU,Hungary
7,3,MT,Malta
3,3,NL,Netherlands
5,4,AT,Austria
3,5,PL,Poland
5,1,PT,Portugal
5,6,RO,Romania
6,4,SI,Slovenia
4,5,SK,Slovakia
1,5,FI,Finland
1,4,SE,Sweden
2,1,UK,United Kingdom
")

grid_preview(eu_grid1, label = "name")

eu_grid1 <- data.frame(eu_grid1)
devtools::use_data(eu_grid1, overwrite = TRUE)

## Australian States / Territories
##---------------------------------------------------------

aus_grid1  <- readr::read_csv("row,col,code,name
2,1,WA,Western Australia
1,2,NT,Northern Territory
2,2,SA,South Australia
1,3,QLD,Queensland
2,3,NSW,New South Wales
3,4,ACT,Australian Capital Territory
3,3,VIC,Victoria
5,3,TAS,Tasmania
")

grid_preview(aus_grid1)

aus_grid1 <- data.frame(aus_grid1)
devtools::use_data(aus_grid1, overwrite = TRUE)

## South African Provinces
##---------------------------------------------------------

sa_prov_grid1  <- readr::read_csv("row,col,code_iso,code_abb,name,name_af
4,1,WC,WC,Western Cape,Wes-Kaap
4,2,EC,EC,Eastern Cape,Oos-Kaap
3,1,NC,NC,Northern Cape,Noord-Kaap
2,2,GT,GP,Gauteng,Gauteng
3,3,NL,KZN,KwaZulu-Natal,KwaZulu-Natal
2,3,MP,MP,Mpumalanga,Mpumalanga
1,3,LP,LP,Limpopo,Limpopo
2,1,NW,NW,North West,Noordwes
3,2,FS,FS,Free State,Vrystaat
")

check_grid(sa_prov_grid1)

grid_preview(sa_prov_grid1, label = "name")

sa_prov_grid1 <- data.frame(sa_prov_grid1)
devtools::use_data(sa_prov_grid1, overwrite = TRUE)

## London Boroughs
##---------------------------------------------------------

london_boroughs_grid  <- readr::read_csv("row,col,code_ons,name
4,5,E09000001,City of London
4,8,E09000002,Barking and Dagenham
2,4,E09000003,Barnet
5,8,E09000004,Bexley
3,3,E09000005,Brent
6,6,E09000006,Bromley
3,4,E09000007,Camden
6,5,E09000008,Croydon
3,2,E09000009,Ealing
1,5,E09000010,Enfield
5,7,E09000011,Greenwich
3,6,E09000012,Hackney
4,2,E09000013,Hammersmith and Fulham
2,5,E09000014,Haringey
2,3,E09000015,Harrow
3,8,E09000016,Havering
3,1,E09000017,Hillingdon
4,1,E09000018,Hounslow
3,5,E09000019,Islington
4,3,E09000020,Kensington and Chelsea
5,2,E09000021,Kingston upon Thames
5,4,E09000022,Lambeth
5,6,E09000023,Lewisham
6,4,E09000024,Merton
4,7,E09000025,Newham
3,7,E09000026,Redbridge
6,3,E09000027,Richmond upon Thames
5,5,E09000028,Southwark
7,4,E09000029,Sutton
4,6,E09000030,Tower Hamlets
2,6,E09000031,Waltham Forest
5,3,E09000032,Wandsworth
4,4,E09000033,Westminster
")

grid_preview(london_boroughs_grid, label = "name")

london_boroughs_grid <- data.frame(london_boroughs_grid)
devtools::use_data(london_boroughs_grid, overwrite = TRUE)
