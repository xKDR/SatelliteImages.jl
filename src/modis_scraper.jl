using HTTP
using Gumbo
using Downloads
import Downloads.download

base_url = "https://neo.gsfc.nasa.gov/archive/geotiff/"
giant_disk_path = "/mnt/giant-disk/modis"
global new_modis_files = []

# List of folder links
folder_links = [
    "AMSRE_SSTAn_M/",
    "AQUARIUS_SSS_M/",
    "AVHRR_CLIM_M/",
    "AVHRR_SST_M/",
    "CERES_INSOL_M/",
    "CERES_NETFLUX_M/",
    "GISS_TA_M/",
    "GPM_3IMERGM/",
    "MCD43C3_M_BSA/",
    "MOD10C1_M_SNOW/",
    "MOD15A2_M_LAI/",
    "MOD_LSTAD_M/",
    "MOD_LSTAN_M/",
    "MOD_LSTD_CLIM_M/",
    "MOD_LSTD_E/",
    "MOD_LSTD_M/",
    "MOD_LSTN_CLIM_M/",
    "MOD_LSTN_E/",
    "MOD_LSTN_M/",
    "MOD_NDVI_16/",
    "MOD_NDVI_M/",
    "MOP_CO_M/",
    "MWOI_SST_M/",
    "MY1DMM_CHLORA/",
    "MYD28M/",
    "MYDAL2_E_SKY_WV/",
    "MYDAL2_M_AER_OD/",
    "MYDAL2_M_AER_RA/",
    "MYDAL2_M_CLD_OT/",
    "MYDAL2_M_SKY_W/",
    "MYDAL2_M_SKY_WV/",
    "README.txt",
    "TRMM_3B43M/"
]

# Function to extract links from a URL
function get_links(url)
    response = HTTP.get(url)
    html = parsehtml(String(response.body))
    links = []
    
    # Recursive function to traverse HTML tree
    function find_file_links(elem)
        if isa(elem, HTMLElement{:a}) && haskey(elem.attributes, "href") && elem.attributes["href"] != "../"
            push!(links, url * elem.attributes["href"])
        end
        
        if isa(elem, HTMLElement)
            for child in elem.children
                find_file_links(child)
            end
        end
    end
    
    find_file_links(html.root)
    return links
end

# Function to fetch links and show files which are new
function fetch_and_show_new_files(base_url, giant_disk_path)
    global new_modis_files
    new_modis_files = []

    # Iterate over each folder, create directories on the giant disk, and check for new files
    for folder_name in folder_links
        folder_url = base_url * folder_name
        folder_path = joinpath(giant_disk_path, folder_name)
        mkpath(folder_path)  # Create the folder and parent directories if needed

        # Get file links for the current folder
        file_links = get_links(folder_url)
        
        for file_url in file_links
            file_name = split(file_url, "/")[end]
            file_path = joinpath(folder_path, file_name)
            
            # Check if file exists before downloading
            if !isfile(file_path)
                println("File $file_name is new and needs to be downloaded.")
                push!(new_modis_files, (file_url, file_path))
            else
                println("File $file_name already exists. Skipping download.")
            end
        end
    end
end

# Function to download new files
function download_new_modis_files()
    global new_modis_files
    for (file_url, file_path) in new_modis_files
        println("Downloading $file_url to $file_path")
        download(file_url, file_path)
    end
end

# Fetch and show new files
fetch_and_show_new_files(base_url, giant_disk_path)

# Download new files
download_new_modis_files()
