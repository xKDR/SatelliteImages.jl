using SatelliteImages
using Documenter

DocMeta.setdocmeta!(SatelliteImages, :DocTestSetup, :(using SatelliteImages); recursive=true)

makedocs(;
    modules=[SatelliteImages],
    authors="Ayush Patnaik, Ajay Shah, Anshul Tayal, Susan Thomas",
    repo="https://github.com/ayushpatnaikgit/SatelliteImages.jl/blob/{commit}{path}#{line}",
    sitename="SatelliteImages.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://ayushpatnaikgit.github.io/SatelliteImages.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/ayushpatnaikgit/SatelliteImages.jl",
    devbranch="main",
)
