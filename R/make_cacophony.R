# "Taking a close look at - at what's around us there - there is some sort of a harmony. It is the harmony of... overwhelming and collective murder."
make_cacophony <- function(aud){

  audlist <- list()

  # get all the clip lengths
  lens <- lapply(aud$length, function(x){
    spl <- as.numeric(strsplit(x, ":")[[1]])
    spl[1]*60+spl[2]
  })
  mlu <- max(unlist(lens))/2

  for(i in seq_along(aud)){

    # generate a delay
    delay <- runif(1, 0, mlu)*1000

    audlist[[i]] <- tags$audio(src = aud$file[i], type = "audio/mp3",
             autoplay = TRUE, controls = NA, style="display:none;",
    # wee bit of javascript to play delayed
    # https://stackoverflow.com/questions/11973673/have-audio-tag-play-after-a-delay
             onloadeddata=paste0("var audioPlayer",i," = this; setTimeout(function() { audioPlayer",i,".play(); },", delay, ")"))
  }

  audlist
}
