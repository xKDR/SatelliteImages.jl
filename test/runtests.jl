# Taken from https://github.com/JuliaData/DataFrames.jl/blob/main/test/runtests.jl
using SatelliteImages
using Test

fatalerrors = length(ARGS) > 0 && ARGS[1] == "-f"
quiet = length(ARGS) > 0 && ARGS[1] == "-q"
anyerrors = false

my_tests = ["aggregate.jl", "coordinate_system.jl", "data_io.jl", "f_apply.jl", "mask_area.jl", "polygons.jl", "sparse_cube.jl"]

println("Running tests:")

for my_test in my_tests
    try
        include(my_test)
        println("\t\033[1m\033[32mPASSED\033[0m: $(my_test)")
    catch e
        global anyerrors = true
        println("\t\033[1m\033[31mFAILED\033[0m: $(my_test)")
        if fatalerrors
            rethrow(e)
        elseif !quiet
            showerror(stdout, e, backtrace())
            println()
        end
    end
end

if anyerrors
    throw("Tests failed")
end
