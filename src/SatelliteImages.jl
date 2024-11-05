module 

using Rasters, DataFrames, Shapefile, StatsBase, Plots, Dates, DimensionalData, CubicSplines, SparseArrays, NCDatasets, ArchGDAL

using HTTP, Gumbo, JSON, Printf, Dates, Downloads

import Downloads.download

include("reader.jl")
export readraster, MODIS, NighttimeLights
end