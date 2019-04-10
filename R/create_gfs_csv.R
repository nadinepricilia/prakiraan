library(easyNCDF)
library(stringr)
library(tibble)
library(dplyr)
library(tidyr)

nc <- NcToArray(file_to_read = "latest_gfs.nc", vars_to_read = NcReadVarNames("latest_gfs.nc"))

varnames <- c(
  attr(nc, "variables")[[1]]$abbreviation, # Total precipitation (accumulation)
  attr(nc, "variables")[[2]]$abbreviation, # Total cloud cover (average)
  attr(nc, "variables")[[3]]$abbreviation, # Maximum temperature 2m (maximum)
  attr(nc, "variables")[[4]]$abbreviation, # Minimum temperature 2m (minimum)
  attr(nc, "variables")[[5]]$dim[[1]]$name, # Forecast hour
  attr(nc, "variables")[[6]]$dim[[1]]$name, # Latitude
  attr(nc, "variables")[[7]]$dim[[1]]$name, # Longitude
  attr(nc, "variables")[[8]]$dim[[1]]$name # Height above ground
)

nc %>%
  arrayhelpers::array2df() %>%
  as_tibble() %>%
  janitor::clean_names() %>% 
  #select(-initial_time0_hours)
  mutate(
    var = recode(var,
                 `1` = varnames[1],
                 `2` = varnames[2],
                 `3` = varnames[3],
                 `4` = varnames[4],
                 `5` = varnames[5],
                 `6` = varnames[6],
                 `7` = varnames[7],
                 `8` = varnames[8])
  ) -> xx
  spread_(key = "var", value = "x")
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