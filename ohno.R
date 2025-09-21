library(curl)
library(readxl)
library(jsonlite)
library(auk)
library(rtoot)

sapply(list.files("R/", full.names=TRUE), source)

# get a random checklist
re <- get_checklist(2022, 01, 29, "GB-SCT-FIF")


# get audio data
aud <- do.call(rbind, lapply(re$sci_nm, get_quack))
aud2 <- get_mp3z(aud)


soxygenize(aud2)

# to create the token
#auth_setup(browser=FALSE, path="rtoot_token.rds")
# get token
token <- readRDS("rtoot_token.rds")

# post the file to botsin.space
post_toot(token = token, status = "", media="merged_final.png",
          alt_text = )
