# Assemble the status
make_status <- function(x){
  paste0("On ",
         x$date,
         ", ",
         x$user,
         " submitted a checklist from ",
         x$location,
         " and observed: ",
         paste(x$com_nm[1:(length(x$com_nm)-1)], collapse=", "),
         ", and ",
         x$com_nm[length(x$com_nm)],
         ".")
}
