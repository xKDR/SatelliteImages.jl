using HTTP
using Gumbo
using Downloads
import Downloads.download

base_url = "https://neo.gsfc.nasa.gov/archive/geotiff/"
giant_disk_path = "/mnt/giant-disk/modis"

# Function to extract links from a URL
function get_links(url)
    response = HTTP.get(url)
    html = parsehtml(String(response.body))
    return [base_url * a["href"] for a in eachmatch("a", html.root) if a["href"] != "../"]
end

# Get main links (folders) from the base URL
main_links = get_links(base_url)

# Iterate over each folder, create directories on the giant disk, and download files
for folder_url in main_links
    folder_name = split(folder_url, "/")[end]
    folder_path = joinpath(giant_disk_path, folder_name)
    mkdir(folder_path; recursive=true)  # Create the folder if it doesn’t exist

    # Get file links for the current folder
    file_links = get_links(folder_url)
    
    for file_url in file_links
        file_name = split(file_url, "/")[end]
        file_path = joinpath(folder_path, file_name)
        
        # Check if file exists before downloading
        if !isfile(file_path)
            println("Downloading $file_name to $file_path")
            download(file_url, file_path)
        else
            println("File $file_name already exists. Skipping download.")
        end
    end
end
