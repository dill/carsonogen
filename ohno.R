library(curl)
library(readxl)
library(jsonlite)
library(auk)
library(rtoot)

sapply(list.files("R/", full.names=TRUE), source)

# get a random checklist
# possible years to sample from
yrs <- 1990:2025
mn_ln <- c(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)

re <- "A"
class(re) <- "try-error"
it <- 0
while(class(re) == "try-error" & it < 100){
  # years are exponentially weighted since there are more observations
  # more recently and we don't want to get stuck in this loop
  yr <- sample(yrs, 1, prob=exp(1:length(yrs))/sum(exp(1:length(yrs))))
  mn <- sample(1:12, 1)
  dy <- sample(1:mn_ln[mn], 1)
  re <- get_checklist(yr, mn, dy, "GB-SCT-FIF")
  it <- it + 1
}

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
