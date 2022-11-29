"""
    dijkstra(g, s)
Finds the shortest path (in terms of time) from the source to all other points in the graph `g` and the parents list to reconstruct the shortest path.
Returns a tuple (shortest_path, parents).
# Parameters
- `g`: The city as a [`AdjacencyGraph`](@ref).
- `s`: The source junction index.
"""
function dijkstra(g::AdjacencyGraph, s)
    dist = fill(Inf, nb_vertices(g))
    parents = fill(-1, nb_vertices(g))

    queue = PriorityQueue{Int,Float64}()
    enqueue!(queue, s => 0.0)
    while !isempty(queue)
        u, dist[u] = dequeue_pair!(queue)
        for v in outneighbors(g, u)
            dist_v = dist[u] + edge_time(g, u, v)  # weight by time
            if dist_v < dist[v]
                dist[v] = dist_v
                queue[v] = dist_v
                parents[v] = u
            end
        end
    end
    return dist, parents
end

"""
    spath(x, dists, source, parents)
Returns the shortest path (in terms of time) from the source to the junction `x`.
# Parameters
- `x`: The target junction index.
- `dists`: The shortest paths in terms of time from dijkstra.
- `source`: The source junction index.
- `parents`: The parents array from dijkstra.
"""
function spath(x, dists::Vector{Float64}, source, parents::Vector{Int64})
    return x == source ? x : [spath(parents[x], dists, source, parents) x]
end
