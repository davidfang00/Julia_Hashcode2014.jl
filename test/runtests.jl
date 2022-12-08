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
        graph = AdjacencyGraph(city)
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
        graph = AdjacencyGraph(city)
        dists, parents = dijkstra(graph, city.starting_junction)
        nesw = find_nesw(city)
        path = spath(city.starting_junction, dists, city.starting_junction, parents)
        path2 = spath(
            outneighbors(graph, city.starting_junction)[1],
            dists,
            city.starting_junction,
            parents,
        )
        @test dists[nesw] ≈ [587.0, 1124.0, 984.0, 1027.0]
        @test length(path) == 1
        @test length(path2) == 2
        @test path[1] == city.starting_junction
        @test path2 ==
            [city.starting_junction, outneighbors(graph, city.starting_junction)[1]]
    end

    @testset verbose = true "Test Bounds" begin
        city = read_city()
        large_bound = find_bound(city, 8, 54000.0)
        small_bound = find_bound(city, 8, 18000.0)
        @test large_bound > 0
        @test small_bound > 0
    end

    @testset verbose = true "Test Metrics" begin
        new_node = TreeNode(nothing, 10, 15.0, 150.0, Set())
        m = node_metric(new_node)
        @test m ≈ 10.0
    end

    @testset verbose = true "Test Remove Dups" begin
        i = [1, 2, 3, 1, 2, 1, 2, 8, 4, 5]
        removed_it = remove_dups(i)
        i2 = [1, 2, 3, 1, 2]
        removed_it2 = remove_dups(i2)
        @test removed_it == [1, 2, 3, 1, 2, 8, 4, 5]
        @test removed_it2 == i2
    end

    @testset verbose = true "Test Greedy Lookahead Dijkstras Fandown" begin
        city = read_city()
        solution = greedy_lookahead_dijkstras_fandown(city)
        @test is_feasible(solution, city)
    end
end
