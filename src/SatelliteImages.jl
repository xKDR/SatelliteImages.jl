module SatelliteImages

using Rasters, DataFrames, Shapefile, StatsBase, Plots, Dates, DimensionalData, CubicSplines, SparseArrays, NCDatasets, ArchGDAL
using HTTP, Gumbo, JSON, Printf, Dates, Downloads

import Downloads.download

include("datasources.jl")
include("reader.jl")
include("modis_scraper.jl")

export readraster, MODIS, VIIRSNTL, fetch_and_show_new_files

end