# make checklist data
make_checklist <- function(meta, aud){

  tags$div(tags$p(paste0("This checklist was collected by ",
             meta$user,
             " on ",
             meta$date, " at ", meta$time, ". ")),
           tags$p("It was collected in a place called ",
             meta$location, "."),
           tags$p(meta$user, " saw and/or heard:"),
           make_audio_credits(meta, aud)
           )
}
