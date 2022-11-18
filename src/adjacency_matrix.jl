"""
    AdjacencyGraph
Store a city in the form of an weighted adjacency graph. Weights are based on length. 
# Fields
- `outneighbors`: junctions
- `weights`: weights based on length for each street.
- `times`: the time it takes to travel a street. Stored as a dictionary keyed by (u, v).
"""

begin
    abstract type AbstractWeightedGraph end

	struct AdjacencyGraph <: AbstractWeightedGraph
		outneighbors::Vector{Vector{Int}}
		weights::Vector{Vector{Float64}}
        times::Dict{Tuple{Int, Int}, Float64}
	end
	
	function AdjacencyGraph(city)
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
        times = Dict()
		for (u, v, l, t) in sort(edges, rev=true, by=edges->edges[3]) # sort by longest length
			push!(outneighbors[u], v)
			push!(weights[u], l)
            times[(u, v)] = t
		end
		return AdjacencyGraph(outneighbors, weights, times)
	end

    nb_vertices(g::AdjacencyGraph) = length(g.outneighbors)

    """
        edge_weight(g, u, v)
    Returns the distance that the path (u, v) will traverse.
    """
    function edge_weight(g::AdjacencyGraph, u, v)
        k = searchsortedfirst(g.outneighbors[u], v)
        return g.weights[u][k]
    end

    """
        edge_time(g, u, v)
    Returns the time it takes to traverse the path (u, v).
    """
    function edge_time(g::AdjacencyGraph, u, v)
        return g.times((u, v))
    end

    """
        outneighbors(g, u)
    Returns the outneighbors of node u.
    """
    function outneighbors(g::AdjacencyGraph, u)
        return g.outneighbors[u]
    end
end