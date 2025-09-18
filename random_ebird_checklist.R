# get a random ebird checklist

random_ebird_checklist <- function(){
  # fist get api key
  ebird_key <- readLines("ebird_api_key")


# curl --location -g 'https://api.ebird.org/v2/product/lists/{{regionCode}}/{{y}}/{{m}}/{{d}}' --header 'X-eBirdApiToken: {{x-ebirdapitoken}}'

  year <- 2025
  month <- 1
  day <- 29

  ## get region codes
  #rc <- read_xlsx("data/eBird\ regions\ and\ region\ codes_18Apr2023.xlsx", sheet=3)
  ## get a random region
  #rc <- rc[sample(1:nrow(rc), 1), ]

  # fix for now
  rc <- "GB-SCT-FIF"

  # build a url
  # this for the "Checklist feed on a date"
  a_url <- paste0("https://api.ebird.org/v2/product/lists/",
                  rc,# {{regionCode}}
                  "/",
                  year,# {{y}}
                  "/",
                  month,# {{m}}
                  "/",
                  day#{{d}}
                 )

  # soem hieroglyphics to get the data
  h <- new_handle(verbose = TRUE)
  handle_setheaders(h,
   "X-eBirdApiToken" = ebird_key
  )
  con <- curl(a_url, handle = h)
  # this is yucky JSON
  chks <- readLines(con)

  # make things non-yucky
  # list o' lists
  lol <- jsonlite::parse_json(chks)

  # just want one of these, so grab that
  ss <- lol[[sample(1:length(lol), 1)]]

  # build the checklist descriptor
  chk_desc <- list(user = ss$userDisplayName,
                   location = ss$loc$hierarchicalName,
                   date = ss$obsDt,
                   time = ss$obsTime)

  # now actually get the checklist itself
  chklst_url <- paste0("https://api.ebird.org/v2/product/checklist/view/",
                       ss$subId)
  con <- curl(chklst_url, handle = h)
  chklst <- jsonlite::parse_json(readLines(con))
  sps <- unlist(lapply(chklst$obs, `[[`, "speciesCode"))


  # use auk to get from species codes to "real" names :)
  sci_nm <- auk::ebird_species(sps)
  com_nm <- auk::ebird_species(sps, "common")


  # now get some noises
  xc_key <- readLines("xenocanto_api_key")

  quality <- "A"

  a_sci_nm <- sub(" ", "%20", sci_nm[1])
  xc_url <- paste0('https://xeno-canto.org/api/3/recordings?query=sp:"',
                   a_sci_nm,
                   '"&per_page=10',
                   "&q=",quality,
                   '&key=', xc_key)
  con <- curl(xc_url)
  quack <- jsonlite::parse_json(readLines(con))

  aquack <- quack$recordings[[sample(1:length(quack$recordings), 1)]]

  aquack_meta <- list(user = aquack$rec,
                      loc  = aquack$loc,
                      url  = aquack$url
                      length  = aquack$length,
                      file  = aquack$file)


}
