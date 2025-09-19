library(curl)
library(readxl)
library(jsonlite)
library(auk)


sapply(list.files("R/", full.names=TRUE), source)

# get a random checklist
re <- get_checklist(2022, 01, 29, "GB-SCT-FIF")


# get audio data
aud <- lapply(re$sci_nm, get_quack)


