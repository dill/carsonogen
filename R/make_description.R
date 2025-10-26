# make the alt text for the toot
make_description <- function(dat, eb){

  paste0("Sounds of birds. ",
         "xeno-canto records: ",
         paste(sub("//xeno-canto.org/", "", dat$url),
               collapse=", "),
         ". eBird checklist URL: ",
         "https://ebird.org/checklist/", eb$chk_id)
}
