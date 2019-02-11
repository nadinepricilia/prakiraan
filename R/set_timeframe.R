#' Menentukan Jangka Waktu dan Siklus
#'
#' Fungsi untuk menentukan jangka
#'
#' @param dir alamat direktori berkas netCDF gfs.0p25
#' @param from tanggal awal dalam format "YYYY-MM-DD"
#' @param to tanggal akhir dalam format "YYYY-MM-DD"
#' @param cycles siklus yang akan diambil
#'
#' @import stringr purrr
#'
#' @return vektor karakter dari alamat berkas
#'
#' @examples
#' dir <- "/home/nadinepricilia/Documents/meteonesia/MVP 1 Weather Forecast Surabaya/Stats_PostPro_GFS/Data_mentah/netCDF"
#' from <- "2015-01-15"
#' to <- "2015-01-17"
#' cycles <- seq(from = 6, to = 60, by = 6)
#' paths <- set_timeframe(dir = dir, from = from, to = to, cycles = cycles)
#' paths
#'
#' @export

set_timeframe <- function(dir, from, to, cycles) {
  timeframe <- seq(from = as.Date(from), to = as.Date(to), by = "day") %>%
    format("%Y%m%d")
  cycles <-
    cycles %>%
    as.character() %>%
    str_pad(width = 3, pad = "0") %>%
    str_c("f", .)
  list_files <- list.files(path = dir, full.names = TRUE)
  sublist_files <- map(timeframe, str_subset, string = list_files) %>%
    unlist()
  res <- map(cycles, str_subset, string = sublist_files) %>%
    unlist()
  return(res)
}
