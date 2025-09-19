# make credits for the audio
make_audio_credits <- function(obs, aud){

  sci_com <- data.frame(sci_nm = obs$sci_nm,
                        com_nm = obs$com_nm)
  alldat <- merge(aud, sci_com, all=TRUE)

  lis <- lapply(seq_along(alldat$sci_nm), function(i){
    this <- alldat[i, ]
    if(is.na(this$url)){
      return(tags$li(this$com_nm))
    }
    tags$li(this$com_nm,
      tags$a("(audio source)", href=paste0("https:", this$url)))
  })

  tags$ul(lis)

}
