# get bird noises (quacks)

get_quack <- function(sci_nm){

  # now get some noises
  # api key
  xc_key <- readLines("xenocanto_api_key")

  a_sci_nm <- curl::curl_escape(sci_nm)

  for(quality in letters[1:5]){

    # docos https://xeno-canto.org/explore/api
    xc_url <- paste0('https://xeno-canto.org/api/3/recordings?query=sp:"',
                     a_sci_nm,
                     '"+q:', quality,
                     '+lic:"BY-NC-SA"',
                     '+len:"<40"',
                     '&per_page=10',
                     '&key=', xc_key)
    con <- curl(xc_url)
    #quack <- jsonlite::parse_json(readLines(con, warn=FALSE))
    quack <- jsonlite::parse_json(readLines(con))
    close(con)

    if(length(quack) > 0) break
  }

  if(length(quack$recordings) == 0){
    return(list())
  }

  aquack <- quack$recordings[[sample(1:length(quack$recordings), 1)]]

  aquack_meta <- data.frame(sci_nm = sci_nm,
                            user = aquack$rec,
                            loc  = aquack$loc,
                            url  = aquack$url,
                            length  = aquack$length,
                            file  = aquack$file)

  aquack_meta
}
