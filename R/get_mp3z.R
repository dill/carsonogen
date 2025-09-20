# get some mp3z d00d
get_mp3z <- function(aud_df, tmpdir="tmp/"){
  aud_df$dfile <- NA
  for(i in 1:nrow(aud_df)){
    dest <- paste0(tmpdir,
                   sub(".*?(\\d+).download", "\\1", aud_df$file[i]),
                   ".mp3")
    download.file(aud_df$file[i], dest)
    aud_df$dfile[i] <- dest
  }
  aud_df
}
