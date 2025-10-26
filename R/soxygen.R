# soxygen
# this is a bad idea
#' @param clip_length length of the clip to create (in seconds)
soxygenize <- function(auds, clip_length=30){

  # convert lengths to lengths in seconds
  lens <- lapply(auds$length, function(x){
    spl <- as.numeric(strsplit(x, ":")[[1]])
    spl[1]*60+spl[2]
  })
  auds$length <- unlist(lens)

  # first tidy things, clip everything to clip_length
  # at random
  which_long_clips <- which(auds$length > clip_length)
  for(i in which_long_clips){
    clipit(auds$dfile[i], auds$length[i], clip_length)
    auds$length[i] <- clip_length
  }

  # now generate when the clips will happen (i.e., start)
  when <- round(runif(nrow(auds), 0, 0.75*clip_length), 0)
  # for long clips, let's start them at the start
  when[auds$length > 0.8*clip_length] <- 0
  # pad up to that time with silence
  for(i in 1:nrow(auds)){
    padit(auds$dfile[i], when[i])
    channelit(auds$dfile[i])
    rateit(auds$dfile[i])
  }


  # splunge them all together
  newfn <- paste0("final_mp3/", format(Sys.time(), "%d-%m-%Y_%H%M"), ".mp3")
  system2("sox",
          c("-m",
            "tmp/\\*\\.mp3",
            newfn))

  # remove temporary mp3 files
  tmps <- list.files("tmp/", ".mp3$", full.names=TRUE)
  file.remove(tmps)

  newfn
}

newfnfn <- function(fn, bit){
  fn <- normalizePath(fn)
  fns <- strsplit(fn, "\\.")[[1]]
  paste0(fns[1], bit, ".", fns[2])
}

clipit <- function(fn, len, maxlen){
  # how much space do we have?
  sp <- len-maxlen
  # find starting point at random
  spr <- runif(1, 0, sp)

  newfn <- newfnfn(fn, "CLIPPED")
  # now call sox and truncate
  system2("sox",
          c(fn,
            newfn,
            "trim",
            paste0("0:", spr),
            paste0("0:", maxlen)))
  system2("mv", c(newfn, fn))
}

padit <- function(fn, pad){

  newfn <- newfnfn(fn, "PADDED")
  # now call sox and truncate
  system2("sox",
          c(fn,
            newfn,
            "pad",
            paste0(pad, "@0")))
  system2("mv", c(newfn, fn))

}


rateit <- function(fn, rate="48k"){
  newfn <- newfnfn(fn, "RATE")
  system2("sox",
          c(fn,
            newfn,
            "rate",
            rate))
  system2("mv", c(newfn, fn))
}

channelit <- function(fn, rate="48k"){
  newfn <- newfnfn(fn, "CHANNEL")
  system2("sox",
          c(fn,
            newfn,
            "channels 2"))
  system2("mv", c(newfn, fn))
}



