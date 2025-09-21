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

