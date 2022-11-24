using Julia_Hashcode2014
using HashCode2014
using Test
using Aqua
using Documenter
using JuliaFormatter

DocMeta.setdocmeta!(
    Julia_Hashcode2014, :DocTestSetup, :(using Julia_Hashcode2014); recursive=true
)

@testset verbose = true "Julia_Hashcode2014.jl" begin
    @testset verbose = true "Code quality (Aqua.jl)" begin
        Aqua.test_all(Julia_Hashcode2014; ambiguities=false)
    end

    @testset verbose = true "Code formatting (JuliaFormatter.jl)" begin
        @test format(Julia_Hashcode2014; verbose=true, overwrite=false)
    end

    @testset verbose = true "Doctests (Documenter.jl)" begin
        doctest(Julia_Hashcode2014)
    end

    @testset verbose = true "Test Greedy" begin
        city = read_city()
        solution = greedy(city)
        @test is_feasible(solution, city)
    end

    @testset verbose = true "Test Lookahead" begin
        city = read_city()
        graph = create_graph(city)
        dist, itinerary = lookahead_tree(graph, 100, Set(), 10, 500)
        @test length(itinerary) == 11
        @test dist > 0
    end

    @testset verbose = true "Test Greedy Lookahead" begin
        city = read_city()
        solution = greedy_lookahead(city)
        dist = total_distance(solution, city)
        @test is_feasible(solution, city)
        @test dist > 0
    end

    @testset verbose = true "Test Find NESW" begin
        city = read_city()
        nesw = find_nesw(city)
        @test length(nesw) == 4
    end

    @testset verbose = true "Test Greedy fandown" begin
        city = read_city()
        solution = fandown_greedy(city)
        @test is_feasible(solution, city)
    end

    @testset verbose = true "Test Dijkstra" begin
        city = read_city()
        graph = create_graph(city)
        dists, parents = dijkstra(graph, city.starting_junction)
        nesw = find_nesw(city)
        path = spath(city.starting_junction, dists, city.starting_junction, parents)
        @test dists[nesw] ≈ [587.0, 1124.0, 984.0, 1027.0]
        @test length(path) == 1
        @test path[1] == city.starting_junction
    end
end
