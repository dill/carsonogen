# get region codes
region_codes <- function(){
  rc <- read_xlsx("data/eBird\ regions\ and\ region\ codes_18Apr2023.xlsx", sheet=3)
  rc <- subset(rc, subnational1_name=="Scotland")
  l <- as.list(rc$subnational2_code)
  names(l) <- rc$subnational2_name
  l
}
