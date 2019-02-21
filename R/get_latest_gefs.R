#' Mengunduh GEFS Terkini
#'
#' Fungsi untuk mengunduh GEFS terkini dengan memanfaatkan NetCDF Subset Service
#'
#' @param var nama variabel, jika lebih dari satu pisahkan dengan tanda koma tanpa spasi
#' @param query tambahan query
#' @param destfile destinasi berkas GEFS unduhan
#'
#' @importFrom xml2 read_html
#' @importFrom rvest html_table
#' @importFrom glue glue
#' @importFrom magrittr %>%
#' @importFrom utils download.file
#' 
#' @return berkas GEFS dan URL NCSS
#'
#' @export

get_latest_gefs <- function(
  var = "Total_precipitation_surface_6_Hour_Accumulation_ens",
  query = "&north=6&west=90&east=141&south=-11&temporal=all",
  destfile = "latest_gefs.nc"
){
  dataset <- 
    read_html("http://thredds.ucar.edu/thredds/catalog/grib/NCEP/GEFS/Global_1p0deg_Ensemble/members/latest.html") %>% 
    html_table() %>% 
    `[[`(c(1,1))
  gefs_url <- glue::glue("http://thredds.ucar.edu/thredds/ncss/grib/NCEP/GEFS/Global_1p0deg_Ensemble/members/{dataset}?var={var}{query}")
  
  download.file(gefs_url, destfile = destfile)
  invisible(gefs_url)
}
