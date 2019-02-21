#' Mengunduh GFS 0.25 Terkini
#'
#' Fungsi untuk mengunduh GFS 0.25 terkini dengan memanfaatkan NetCDF Subset Service
#'
#' @param var nama variabel, jika lebih dari satu pisahkan dengan tanda koma tanpa spasi
#' @param query tambahan query
#' @param destfile destinasi berkas GFS unduhan
#'
#' @importFrom xml2 read_html
#' @importFrom rvest html_table
#' @importFrom glue glue
#' @importFrom magrittr %>%
#' @importFrom utils download.file
#' 
#' @return berkas GFS dan URL NCSS
#'
#' @export

get_latest_gfs <- function(
  var = "Total_precipitation_surface_Mixed_intervals_Accumulation",
  query = "&north=6&west=90&east=141&south=-11&temporal=all",
  destfile = "latest_gfs.nc"
){
  dataset <- 
    read_html("http://thredds.ucar.edu/thredds/catalog/grib/NCEP/GFS/Global_0p25deg/latest.html") %>% 
    html_table() %>% 
    `[[`(c(1,1))
  gfs_url <- glue::glue("http://thredds.ucar.edu/thredds/ncss/grib/NCEP/GFS/Global_0p25deg/{dataset}?var={var}{query}")
  
  download.file(gfs_url, destfile = destfile)
  invisible(gfs_url)
}