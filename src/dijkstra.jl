"""
    dijkstra(g, s)
Returns the shortest path (in terms of time) from the source `s` to all other points in the graph `g` and the parents to reconstruct the shortest path.
# Parameters
- `g`: The city as a [`AdjacencyGraph`](@ref).
- 's': The source junction index.
"""
function dijkstra(g, s)
    dist = fill(Inf, nb_vertices(g))  # here
    parents = fill(9999999, nb_vertices(g))

    queue = PriorityQueue{Int,Float64}()
    enqueue!(queue, s => 0.0)
    while !isempty(queue)
        u, dist[u] = dequeue_pair!(queue)
        for v in outneighbors(g, u)  # here
            dist_v = dist[u] + edge_time(g, u, v)  # here
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
Returns the shortest path (in terms of time) from the source `s` to the junction `x`.
# Parameters
- `x`: The target junction index.
- 'dists': The shortest paths in terms of time.
- 'source': The source junction index.
- 'parents': The parents array.
"""
function spath(x, dists, source, parents)
    return x == source ? x : [spath(parents[x], dists, source, parents) x]
end
