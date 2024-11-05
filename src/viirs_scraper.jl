using HTTP
using Gumbo
using JSON
using Printf
using Dates

# Retrieve credentials from environment variables
USERNAME = ENV["EOG_USERNAME"]
PASSWORD = ENV["EOG_PASSWORD"]
client_secret = "2677ad81-521b-4869-8480-6d05b9e57d48"  # Add client secret as needed

base_url = "https://eogdata.mines.edu/nighttime_light/monthly_notile/v10/%s/%s/vcmcfg/"
rade9h_links = String[]
cvg_links = String[]

# Add 2022-08 exception
push!(rade9h_links, "https://eogdata.mines.edu/nighttime_light/monthly_notile/v10/2022/202208/NOAA-20/vcmcfg/SVDNB_j01_20220801-20220831_global_vcmcfg_v10_c202209231200.avg_rade9h.tif")
push!(cvg_links, "https://eogdata.mines.edu/nighttime_light/monthly_notile/v10/2022/202208/NOAA-20/vcmcfg/SVDNB_j01_20220801-20220831_global_vcmcfg_v10_c202209231200.cf_cvg.tif")

# Retrieve file links for each year-month
function get_monthly_links(year, month)
    url = @sprintf(base_url, year, month)
    response = HTTP.get(url)
    html = parsehtml(String(response.body))
    for tag in eachmatch("a", html.root)
        link = url * tag["href"]
        if endswith(tag["href"], "avg_rade9h.tif")
            push!(rade9h_links, link)
        elseif endswith(tag["href"], "cf_cvg.tif")
            push!(cvg_links, link)
        end
    end
end

# Gather links for each month and year
for year in 2012:year(Dates.now())
    for month in 1:12
        get_monthly_links(year, lpad(month, 2, '0'))
    end
end

# Access token function
function get_access_token()
    token_url = "https://eogauth.mines.edu/auth/realms/master/protocol/openid-connect/token"
    params = Dict(
        "client_id" => "eogdata_oidc",
        "client_secret" => client_secret,
        "username" => USERNAME,
        "password" => PASSWORD,
        "grant_type" => "password"
    )
    response = HTTP.post(token_url, [("Content-Type", "application/x-www-form-urlencoded")], URIParams(params))
    return JSON.parse(String(response.body))["access_token"]
end

# Download function
function download_link(link, directory)
    filename = split(link, "/")[end]
    filepath = joinpath(directory, filename)
    if isfile(filepath)
        println("$filename already exists. Skipping.")
        return
    end

    access_token = get_access_token()
    headers = ["Authorization" => "Bearer $access_token"]
    response = HTTP.get(link, headers)
    
    open(filepath, "w") do file
        write(file, response.body)
    end
    println("Downloaded $filename to $directory")
end

# Download all missing files in directory
function download_missing_files(links, directory)
    mkpath(directory)  # Create directory if it doesn't exist
    for link in links
        download_link(link, directory)
    end
end

# Set directories and download
download_missing_files(rade9h_links, "/mnt/giant-disk/nighttimelights/monthly/rad")
download_missing_files(cvg_links, "/mnt/giant-disk/nighttimelights/monthly/cf")
