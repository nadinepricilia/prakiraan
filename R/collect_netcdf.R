# collect_netcdf <- function(path, date, cyc) {
#   source("R/make_df.R")
#   cyc <-
#     cyc %>%
#     as.character() %>%
#     str_pad(width = 3, pad = "0") %>%
#     str_c("f", .)
#
#   list.files(path = path, pattern = date, full.names = TRUE) %>%
#     str_subset(pattern = cyc) %>%
#     map_df(
#       ~ NcOpen(.x) %>%
#         NcToArray(vars_to_read = str_subset(NcReadVarNames(.), pattern = "^(APCP|TMAX|TMIN|lat|lon)")) %>%
#         make_df() %>%
#         mutate(
#           cycle = .x %>%
#             str_extract(pattern = "f[0-9]{3}") %>%
#             parse_number(),
#           issue_time = .x %>%
#             str_extract(pattern = "[0-9]{10}") %>%
#             as.POSIXct(format = "%Y%m%d%H", tz = "UTC")
#         ) %>%
#         select(issue_time, cycle, everything())
#     )
# }
