
function test_func(x)
    function max_missing(x)
        """Finds the maximum value of a array where missing are present.""" 
            y = replace(copy(x), missing => 0)
            return(maximum(y))
        end        
    max = max_missing(x)
    return x.+ max
end

@testset "cross_apply" begin
    for i in 1:10
        x = rand(10:30)
        y = rand(10:30)
        z = rand(10:30)
        rad = rand(20:100.0, x, y, z)
        @test size(cross_apply(test_func, rad)) == size(rad)
    end
end

@testset "long_apply" begin
    for i in 1:10
        x = rand(10:30)
        y = rand(10:30)
        z = rand(10:30)
        rad = rand(20:100.0, x, y, z)
        mask = rand(0:1, x, y)
        @test size(long_apply(test_func, rad, mask)) == size(rad)
    end
end