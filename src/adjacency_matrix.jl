abstract type AbstractWeightedGraph end

"""
    AdjacencyGraph
Store a city in the form of an weighted adjacency graph. Weights are based on length. 
# Fields
- `outneighbors::Vector{Vector{Int}}`: junctions
- `weights::Vector{Vector{Float64}}`: weights based on length for each street.
- `times::Dict{Tuple{Int,Int},Float64}`: the time it takes to travel a street.
"""
Base.@kwdef struct AdjacencyGraph <: AbstractWeightedGraph
    outneighbors::Vector{Vector{Int}}
    weights::Vector{Vector{Float64}}
    times::Dict{Tuple{Int,Int},Float64}
end

function AdjacencyGraph(city::City)
    n = length(city.junctions)
    edges = Tuple{Int,Int,Float64,Float64}[]

    for edge in city.streets # edges are stored as (u, v, length, time)
        push!(edges, (edge.endpointA, edge.endpointB, edge.distance, edge.duration))
        if edge.bidirectional
            push!(edges, (edge.endpointB, edge.endpointA, edge.distance, edge.duration))
        end
    end

    outneighbors = [Int[] for v in 1:n]
    weights = [Float64[] for v in 1:n]
    times = Dict{Tuple{Int,Int},Float64}()
    for (u, v, l, t) in sort(edges; rev=true, by=edges -> edges[3]) # sort by longest length
        push!(outneighbors[u], v)
        push!(weights[u], l)
        times[(u, v)] = t
    end
    return AdjacencyGraph(outneighbors, weights, times)
end

nb_vertices(g::AdjacencyGraph) = length(g.outneighbors)

"""
    edge_weight(g, u, v)
Returns the distance that the path (u, v) will traverse based on an [`AdjacencyGraph`](@ref) g.
"""
function edge_weight(g::AdjacencyGraph, u, v)
    k = searchsortedfirst(sort(g.outneighbors[u]), v)
    return g.weights[u][k]
end

"""
    edge_time(g, u, v)
Returns the time it takes to traverse the path (u, v) based on an [`AdjacencyGraph`](@ref) g.
"""
function edge_time(g::AdjacencyGraph, u, v)
    return g.times[(u, v)]
end

"""
    outneighbors(g, u)
Returns the outneighbors of node u based on an [`AdjacencyGraph`](@ref) g.
"""
function outneighbors(g::AdjacencyGraph, u)
    return g.outneighbors[u]
end

"""
    create_graph(city)
Create an [`AdjacencyGraph`](@ref) based on a city.
"""
function create_graph(city::City)
    return AdjacencyGraph(city)
end
