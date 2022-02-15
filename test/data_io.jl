
@testset "testing input output functions" begin 
    package_path = pathof(SatelliteImages)
    path_len = length(package_path)
    assets_path = package_path[1:path_len-22] * "assets"
    map_path = assets_path * "/mumbai_map/mumbai_districts.shp"
    radiance_jld_path = assets_path * "/mumbai_ntl/datacube/mumbai_radiance.jld"
    radiance_img_path = assets_path * "/mumbai_ntl/img/april2012.tif"
    @test length(size(load_datacube(radiance_jld_path))) == 3
    @test length(size(load_img(radiance_img_path))) == 2
    @test sizeof(load_shapefile(map_path)) > 0
end