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

"""
    lookahead_tree_bounded(graph, start, visited, n, time_remaining, city, lat_min, lat_max, long_min, long_max)
Uses BFS to lookahead from the start node throughout the graph while obeying the time constraints. 
Uses a speed metric to select best itinerary. Any paths already traveled are heavily discounted in the metric.
Any junctions outside the min/max latitude/longitude are also heavily discounted.
Returns a (best distance, best itinerary) tuple. 
# Parameters
- `graph::AdjacencyGraph`: The [`AdjacencyGraph`](@ref) representing the city.
- `start`: The starting junction index.
- `visited`: the (u, v) paths that have already been taken by any cars.
- `n`: the number of levels to iterate for BFS.
- `time_remaining`: the remaining time for the car to travel.
- `city`: the city.
- `lat_min`: the minimum latitude.
- `lat_max`: the maximum latitude.
- `long_min`: the minimum longitude.
- `long_max`: the maximum longitude.
"""
function lookahead_tree_bounded(
    graph, start, visited, n, time_remaining, city, lat_min, lat_max, long_min, long_max
)
    start_node = TreeNode(nothing, start, 0.0001, 0.0, Set{Tuple{Int64,Int64}}())
    current_junctions = [start_node]
    best_node = start_node
    juncs = city.junctions

    count = 1
    while count <= n
        new_junctions = Vector{TreeNode}()
        for junc in current_junctions
            current_junction = junc.junction
            curr_time = junc.time_elapsed
            dist_traveled = junc.distance_traveled
            candidates = outneighbors(graph, current_junction)

            valid_candidates = get_valid_candidates(
                graph, current_junction, candidates, curr_time, time_remaining
            )

            for i in eachindex(valid_candidates)
                candidate = valid_candidates[i]

                if in((current_junction, candidate), visited) == true ||
                    in((current_junction, candidate), junc.path_visited) == true
                    continue
                end

                path_visited = copy(junc.path_visited)

                traverse_time = edge_time(graph, current_junction, candidate)
                dist = edge_weight(graph, current_junction, candidate)

                discount = (0.97^(count - 1))^0
                j = juncs[candidate]
                if (
                    (lat_min <= j.latitude <= lat_max) &&
                    (long_min <= j.longitude <= long_max)
                ) == false
                    discount *= 1 / 10.0 #discount factor if outside of bounds
                end

                dist *= discount
                new_node = TreeNode(
                    junc,
                    candidate,
                    curr_time + traverse_time,
                    dist_traveled + dist,
                    path_visited,
                )

                # prune really bad paths
                if count < n * 0.6 || node_metric(new_node) > node_metric(best_node) * 0.4
                    push!(new_junctions, new_node)
                    push!(path_visited, (current_junction, candidate))
                    push!(path_visited, (candidate, current_junction))
                end

                if node_metric(new_node) > node_metric(best_node)
                    best_node = new_node
                end
            end
        end

        if isempty(new_junctions)
            num_samples = rand([2, 2, 2, 2])
            for junc in current_junctions
                current_junction = junc.junction
                curr_time = junc.time_elapsed
                dist_traveled = junc.distance_traveled
                candidates = outneighbors(graph, current_junction)

                valid_candidates = get_valid_candidates(
                    graph, current_junction, candidates, curr_time, time_remaining
                )

                for i in 1:min(length(valid_candidates), num_samples)
                    path_visited = copy(junc.path_visited)
                    candidate = rand(valid_candidates)
                    traverse_time = edge_time(graph, current_junction, candidate)
                    dist = 1 / 1000000.0

                    new_node = TreeNode(
                        junc,
                        candidate,
                        curr_time + traverse_time,
                        dist_traveled + dist,
                        path_visited,
                    )
                    push!(new_junctions, new_node)

                    if node_metric(new_node) > node_metric(best_node)
                        best_node = new_node
                    end
                end
            end
        end

        current_junctions = new_junctions
        count += 1
    end

    best_itinerary = Vector{Int64}()
    best_dist = best_node.distance_traveled

    while isnothing(best_node) == false
        push!(best_itinerary, best_node.junction)
        best_node = best_node.parent
    end
    reverse!(best_itinerary)

    return best_dist, best_itinerary
end

"""
    get_valid_candidates(graph, current, candidates, time_elapsed, time_remaining)
Returns a list of valid neighboring junctions from the `current` junction. 
A neighbor is valid if the time it requires to travel there fits within the time requirement.
# Parameters
- `graph::AdjacencyGraph`: The [`AdjacencyGraph`](@ref) representing the city.
- `current`: the current junction index.
- `candidates`: neighboring junctions.
- `time_elapsed`: the time elapsed so far.
- `time_remaining`: the remaining time for the car to travel.
"""
function get_valid_candidates(graph, current, candidates, time_elapsed, time_remaining)
    valid_cand = Vector{Int64}()
    for cand in candidates
        traverse = edge_time(graph, current, cand)
        if traverse + time_elapsed <= time_remaining
            push!(valid_cand, cand)
        end
    end
    return valid_cand
end
