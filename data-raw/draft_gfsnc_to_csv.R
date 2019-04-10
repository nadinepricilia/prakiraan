library(prakiraan)
library(tidyverse)
library(raster)

varnames <- c("Total_precipitation_surface_Mixed_intervals_Accumulation",
              "Total_cloud_cover_entire_atmosphere_Mixed_intervals_Average",
              "Maximum_temperature_height_above_ground_Mixed_intervals_Maximum",
              "Minimum_temperature_height_above_ground_Mixed_intervals_Minimum")

gfsnc2csv_latest <-
  function(destfile = "latest_gefs.nc",
           varnames = c(
             "Total_precipitation_surface_Mixed_intervals_Accumulation",
             "Total_cloud_cover_entire_atmosphere_Mixed_intervals_Average",
             "Maximum_temperature_height_above_ground_Mixed_intervals_Maximum",
             "Minimum_temperature_height_above_ground_Mixed_intervals_Minimum"
           )) {
    latest_gfs <-
      get_latest_gfs(var = paste0(varnames, collapse = ","),
                     destfile = destfile)
    latest_time <-
      latest_gfs %>%
      str_extract(pattern = "\\d{8}_\\d{4}") %>%
      as.POSIXct(format = "%Y%m%d_%H%M", tz = "UTC")
    res <- map(
      varnames,
      ~ brick(x = destfile, varname = .x) %>%
        rasterToPoints() %>%
        as_tibble() %>%
        gather(key = "time",
               value = !!enquo(.x),-x,-y) %>%
        rename(lon = x,
               lat = y) %>%
        mutate(time = parse_number(time),
               time = latest_time + time * 3600)
    )
    res <- reduce(res, left_join)
    return(res)
  }

latest_gfs <- gfsnc2csv_latest(varnames = varnames)
write_csv(latest_gfs, "data-raw/latest_gfs.csv")
