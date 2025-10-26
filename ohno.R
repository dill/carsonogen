library(curl)
library(readxl)
library(jsonlite)
library(auk)
library(rtoot)

sapply(list.files("R/", full.names=TRUE), source)

# get a random checklist
re <- get_checklist(2022, 01, 29, "GB-SCT-FIF")

# get metadata
aud <- do.call(rbind, lapply(re$sci_nm, get_quack))
# get audio data
aud2 <- get_mp3z(aud)

# squish things into one file
this_fn <- soxygenize(aud2)

# make the description stuff to add to the toot
this_desc <- make_description(aud2, re)
this_status <- make_status(re)


# to create the token
#auth_setup(browser=FALSE, path="rtoot_token.rds")
# get token
token <- readRDS("rtoot_token.rds")

# post the file to botsin.space
post_toot(token = token, status = this_status, media=this_fn,
          alt_text = this_desc)
