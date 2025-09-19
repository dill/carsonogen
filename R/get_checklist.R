# get an ebird checklist

get_checklist <- function(year, month, day, rc){
  # fist get api key
  ebird_key <- readLines("ebird_api_key")


  # build a url
  # this for the "Checklist feed on a date"
  # curl --location -g 'https://api.ebird.org/v2/product/lists/{{regionCode}}/{{y}}/{{m}}/{{d}}' --header 'X-eBirdApiToken: {{x-ebirdapitoken}}'
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
  chks <- readLines(con, warn=FALSE)

  # make things non-yucky
  # list o' lists
  lol <- jsonlite::parse_json(chks)

  if(length(lol) == 0){
    stop("No checklists in this place/time!")
  }

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
  chklst <- jsonlite::parse_json(readLines(con, warn=FALSE))
  sps <- unlist(lapply(chklst$obs, `[[`, "speciesCode"))


  # use auk to get from species codes to "real" names :)
  sci_nm <- auk::ebird_species(sps)
  com_nm <- auk::ebird_species(sps, "common")

  chk_desc$sci_nm <- sci_nm
  chk_desc$com_nm <- com_nm

  chk_desc
}
