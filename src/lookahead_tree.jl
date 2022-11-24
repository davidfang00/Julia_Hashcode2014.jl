"""
    lookahead_tree(graph, start, visited, n, time_remaining)
Uses BFS to lookahead from the start node throughout the graph while obeying the time constraints. 
Uses a distance metric to select best itinerary. Any paths already traveled are heavily discounted in the metric.
Returns a (best distance, best itinerary) tuple. 
# Parameters
- `graph::AdjacencyGraph`: The [`AdjacencyGraph`](@ref) representing the city.
- `start`: The starting junction index.
- `visited`: the (u, v) paths that have already been taken by any cars.
- `n`: the number of levels to iterate for BFS.
- `time_remaining`: the remaining time for the car to travel.
"""
function lookahead_tree(graph::AdjacencyGraph, start, visited, n, time_remaining)
    start_node = TreeNode(nothing, start, 0.0, 0.0, Set{Tuple{Int64,Int64}}())
    current_junctions = [start_node]
    best_node = start_node

    count = 1
    while count <= n
        new_junctions = []
        for junc in current_junctions
            current_junction = junc.junction
            curr_time = junc.time_elapsed
            dist_traveled = junc.distance_traveled
            candidates = outneighbors(graph, current_junction)

            for i in eachindex(candidates)
                path_visited = deepcopy(junc.path_visited)
                candidate = candidates[i]
                traverse_time = edge_time(graph, current_junction, candidate)
                dist = edge_weight(graph, current_junction, candidate)

                if curr_time + traverse_time <= time_remaining &&
                    in((current_junction, candidate), visited) == false &&
                    in((current_junction, candidate), path_visited) == false
                    push!(path_visited, (current_junction, candidate))
                    push!(path_visited, (candidate, current_junction))

                    new_node = TreeNode(
                        junc,
                        candidate,
                        curr_time + traverse_time,
                        dist_traveled + dist,
                        path_visited,
                    )

                    push!(new_junctions, new_node)

                    if new_node.distance_traveled > best_node.distance_traveled
                        best_node = new_node
                    end
                end
            end

            if isempty(new_junctions)
                for i in eachindex(candidates)
                    path_visited = deepcopy(junc.path_visited)
                    candidate = rand(candidates)
                    traverse_time = edge_time(graph, current_junction, candidate)
                    dist = edge_weight(graph, current_junction, candidate)

                    if curr_time + traverse_time <= time_remaining
                        push!(path_visited, (current_junction, candidate))
                        push!(path_visited, (candidate, current_junction))

                        new_node = TreeNode(
                            junc,
                            candidate,
                            curr_time + traverse_time,
                            dist_traveled + dist / 1000.0,
                            path_visited,
                        )

                        push!(new_junctions, new_node)

                        if new_node.distance_traveled > best_node.distance_traveled
                            best_node = new_node
                        end
                        break
                    end
                end
            end
        end
        current_junctions = new_junctions
        count += 1
    end

    best_itinerary = Vector{Int}()
    best_dist = best_node.distance_traveled

    while isnothing(best_node) == false
        push!(best_itinerary, best_node.junction)
        best_node = best_node.parent
    end
    reverse!(best_itinerary)
    return best_dist, best_itinerary
end
