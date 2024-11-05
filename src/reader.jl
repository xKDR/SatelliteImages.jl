# Define a function that sorts the files in a folder by date
function sort_files_by_date(folder_path, start_date=Date(0), end_date=Date(today()))
    function extract_date(filename)
        # Extract the date range using regex
        m = match(r"_(\d{8})-\d{8}_", filename)
        return m == nothing ? nothing : DateTime(Date(m[1], "yyyymmdd"))
    end
    # Get the list of file names in the directory
    files = readdir(folder_path)
    # Filter out files that we couldn't extract a date from and are not within the date range
    files = filter(x -> (d = extract_date(x)) != nothing && start_date <= d <= end_date, files)
    # Sort files based on the date they contain
    sort!(files, by=extract_date)
    # Extract the list of dates
    dates = map(extract_date, files)
    # Return the sorted files and their corresponding dates
    return files, dates
end

# Helper function: make_datacube (kept the same as before)
function make_datacube(path::String, start_date::Date, end_date::Date, geom::Any)
    files, sorted_dates = sort_files_by_date(path, start_date, end_date)
    raster_list = [crop(Raster(i, lazy = true), to = geom) for i in path .* files]
    raster_series = RasterSeries(raster_list, Ti(sorted_dates))
    return Rasters.combine(raster_series, Ti)
end

function make_datacube(path::String, start_date::Date, end_date::Date, xlims::Any, ylims::Any)
    files, sorted_dates = sort_files_by_date(path, start_date, end_date)
    lims = xlims, ylims
    raster_list = [Raster(i, lazy = true)[lims...] for i in path .* files]
    raster_series = RasterSeries(raster_list, Ti(sorted_dates))
    return Rasters.combine(raster_series, Ti)
end

function make_datacube(path::String, start_date::Date, end_date::Date)
    files, sorted_dates = sort_files_by_date(path, start_date, end_date)
    raster_list = [Raster(i, lazy = true) for i in path .* files]
    raster_series = RasterSeries(raster_list, Ti(sorted_dates))
    return Rasters.combine(raster_series, Ti)
end

# Main readnl functions with multiple dispatch

# Case 1: Using geometry
function readraster(dataset::NighttimeLights, start_date::Date, end_date::Date, geom; rad_path = "/mnt/giant-disk/nighttimelights/monthly/rad/", cf_path = "/mnt/giant-disk/nighttimelights/monthly/cf/")
    rad_datacube = make_datacube(rad_path, start_date, end_date, geom)
    cf_datacube = make_datacube(cf_path, start_date, end_date, geom)
    return rad_datacube, cf_datacube
end

# Case 2: Using xlims and ylims
function readraster(dataset::NighttimeLights, start_date::Date, end_date::Date, xlims, ylims; rad_path = "/mnt/giant-disk/nighttimelights/monthly/rad/", cf_path = "/mnt/giant-disk/nighttimelights/monthly/cf/")
    rad_datacube = make_datacube(rad_path, start_date, end_date, xlims, ylims)
    cf_datacube = make_datacube(cf_path, start_date, end_date, xlims, ylims)
    return rad_datacube, cf_datacube
end

# Case 3: Without any spatial limits
function readraster(dataset::NighttimeLights, start_date::Date, end_date::Date; rad_path = "/mnt/giant-disk/nighttimelights/monthly/rad/", cf_path = "/mnt/giant-disk/nighttimelights/monthly/cf/")
    rad_datacube = make_datacube(rad_path, start_date, end_date)
    cf_datacube = make_datacube(cf_path, start_date, end_date)
    return rad_datacube, cf_datacube
end

function readraster(dataset::MODIS, start_date::Date, end_date::Date)
    path = "/mnt/giant-disk/modis/$(dataset.dataset_name)/"
    datacube = make_datacube(path, start_date, end_date)
    return datacube
end
