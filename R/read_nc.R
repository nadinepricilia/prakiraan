#' Membaca netCDF gfs.0p25
#'
#' Menghasilkan dataframe untuk parameter akumulasi presipitasi, temperatur minimum, temperatur maksimum, lintang, dan bujur yang berasal dari data gfs.0p25.
#'
#' @param path array dari netCDF. Gunakan NcToArray untuk menghasilkan array dari netCDF.
#'
#' @import easyNCDF arrayhelpers dplyr stringr tidyr
#'
#' @return dataframe
#'
#' @export

read_nc <- function(path) {
  path %>%
    NcOpen() %>%
    NcToArray(vars_to_read = str_subset(NcReadVarNames(.), pattern = "^(APCP|TMAX|TMIN|lat|lon)"))
    array2df() %>%
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
    spread(key = var, value = x) %>%
    arrange(lon_0, lat_0) %>%
    fill(lon) %>%
    arrange(lat_0, lon_0) %>%
    fill(lat) %>%
    select(-lon_0, -lat_0)
}
