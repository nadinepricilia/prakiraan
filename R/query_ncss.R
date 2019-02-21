#' Antarmuka The NetCDF Subset Service (NCSS)
#'
#' Fungsi antarmuka dari NetCDF Subset Service
#'
#' @param host nama peladen, misalnya thredds.ucar.edu
#' @param context "thredds"
#' @param service "ncss"
#' @param dataset path dataset dari katalog
#' @param var nama variabel
#' @param query tambahan query
#'
#' @import easyNCDF
#' @importFrom glue glue
#' 
#' @return kueri NCSS
#'
#' @export

query_ncss <- function(
  host = "thredds.ucar.edu",
  context = "thredds",
  service = "ncss",
  dataset = "grib/NCEP/GEFS/Global_1p0deg_Ensemble/members/GEFS_Global_1p0deg_Ensemble_20190213_0000.grib2",
  var = "Total_precipitation_surface_6_Hour_Accumulation_ens",
  query = "&north=6&west=90&east=141&south=-11&temporal=all"
) {
  res <- glue::glue("http://{host}/{context}/{service}/{dataset}?var={var}{query}")

  return(res)
}
