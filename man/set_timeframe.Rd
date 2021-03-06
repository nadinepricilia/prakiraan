% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/set_timeframe.R
\name{set_timeframe}
\alias{set_timeframe}
\title{Menentukan Jangka Waktu dan Siklus}
\usage{
set_timeframe(dir, from, to, cycles)
}
\arguments{
\item{dir}{alamat direktori berkas netCDF gfs.0p25}

\item{from}{tanggal awal dalam format "YYYY-MM-DD"}

\item{to}{tanggal akhir dalam format "YYYY-MM-DD"}

\item{cycles}{siklus yang akan diambil}
}
\value{
vektor karakter dari alamat berkas
}
\description{
Fungsi untuk menentukan jangka
}
\examples{
dir <- "/home/nadinepricilia/Documents/meteonesia/MVP 1 Weather Forecast Surabaya/Stats_PostPro_GFS/Data_mentah/netCDF"
from <- "2015-01-15"
to <- "2015-01-17"
cycles <- seq(from = 6, to = 60, by = 6)
paths <- set_timeframe(dir = dir, from = from, to = to, cycles = cycles)
paths

}
