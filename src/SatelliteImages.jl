module SatelliteImages
using Dates, ArchGDAL, GeoArrays, DataFrames, Shapefile, GeoInterface, ProgressMeter, SparseArrays, StatsBase, Statistics, RecursiveArrayTools, JLD, CubicSplines
# Write your package code here.

export load_img, load_datacube, save_img, save_datacube, 
lat_to_row, row_to_lat, lat_to_row, long_to_column, column_to_long, translate_geometry, Coordinate, CoordinateSystem, image_to_coordinate,
polygon_mask, load_shapefile, mask_area, long_apply, cross_apply, apply_mask, view_img, aggregate, aggregate_timeseries, aggregate_dataframe, bias_correction,  sparse_cube, make_datacube, load_example, radiance_datacube, clouds_datacube, mumbai_map, MUMBAI_COORDINATE_SYSTEM, INDIA_COORDINATE_SYSTEM, coordinate_to_image, aggregate_per_area_dataframe

include("data_io.jl")
include("view_image.jl")
include("coordinate_system.jl")
include("polygons.jl")
include("area.jl")
include("f_apply.jl")
include("sparse_datacube.jl")
include("aggregate.jl")
include("example.jl")
include("masks.jl")
include("luxor_functions.jl")
end
