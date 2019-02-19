#' Membaca netCDF gfs.0p25
#'
#' Menghasilkan dataframe untuk parameter akumulasi presipitasi, temperatur minimum, temperatur maksimum, lintang, dan bujur yang berasal dari data gfs.0p25.
#'
#' @param path lokasi dokumen gfs.0p25 format nc
#'
#' @import easyNCDF dplyr stringr tidyr
#' @importFrom arrayhelpers array2df
#' @importFrom readr parse_number
#' @importFrom janitor clean_names
#' @importFrom tibble tibble
#'
#' @return [tibble][tibble::tibble-package]
#'
#' @examples
#'
#' read_nc(path = "/home/nadinepricilia/Documents/meteonesia/MVP 1 Weather Forecast Surabaya/Stats_PostPro_GFS/Data_mentah/netCDF/gfs.0p25.2015011500.f006.grib2.pricilia336642.nc")
#'
#' @export

read_nc <- function(path) {
  nc_file <- NcOpen(path)

  sub_nc <- nc_file %>%
    NcToArray(vars_to_read = str_subset(NcReadVarNames(.), pattern = "^(APCP|TMAX|TMIN|lat|lon)"))

  NcClose(nc_file)

  sub_nc %>%
    arrayhelpers::array2df() %>%
    as_tibble() %>%
    janitor::clean_names() %>%
    select(-initial_time0_hours) %>%
    mutate(
      var = recode(var,
                   `1` = "prec",
                   `2` = "tmax",
                   `3` = "tmin",
                   `4` = "lat",
                   `5` = "lon")
    ) %>%
    spread_(key = "var", value = "x") %>%
    arrange_("lon_0", "lat_0") %>%
    fill_("lon") %>%
    arrange_("lat_0", "lon_0") %>%
    fill_("lat") %>%
    mutate(
      issue_time = str_extract(path, pattern = "[0-9]{10}") %>%
        as.POSIXct(, format = "%Y%m%d%H", tz = "UCT"),
      cycle = str_extract(path, pattern = "f[0-9]{3}") %>%
        parse_number()
    ) %>%
    select(issue_time, cycle, everything(), -lon_0, -lat_0)
}
