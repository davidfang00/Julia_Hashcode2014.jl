"""
    TreeNode
Stores nodes in a graph. Each node only has 1 parent node.
# Fields
- `parent::Union{TreeNode, Nothing}`: The parent node/junction.
- `junction::Int64`: The junction index.
- `time_elapsed::Float64`: the total time that has elapsed to reach this junction from the start.
- `distance_traveled::Float64`: the total distrance traveled to reach this junction from the start.
- `path_visited::Set{Tuple{Int64, Int64}}`: the (u, v) paths taken to reach this junction from the start.
"""
Base.@kwdef struct TreeNode
    parent::Union{TreeNode,Nothing}
    junction::Int64
    time_elapsed::Float64
    distance_traveled::Float64
    path_visited::Set{Tuple{Int64,Int64}}
end

"""
    lookahead_tree(graph, start, visited, n, time_remaining)
Uses BFS to lookahead from the start node throughout the graph while obeying the time constraints. Uses a distance metric to select best itinerary.
Returns a (best distance, best itinerary) tuple.
# Parameters
- `graph::AdjacencyGraph`: The [`AdjacencyGraph`](@ref) representing the city.
- `start`: The starting junction index.
- `visited`: the (u, v) paths that have already been taken by any cars.
- `n`: the number of levels to iterate for BFS.
- `time_remaining`: the remaining time for the car to travel.
"""
function lookahead_tree(graph, start, visited, n, time_remaining)
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
    greedy_lookahead(city, n_lookahead, seq_steps)
A greedy algorithm that uses BFS to lookahead from the start node throughout the graph while obeying the time constraints. Uses a distance metric to select best itinerary.
# Parameters
- `city`: The city (as a City from HashCode2014)
- `n_lookahead`: The number of BFS levels to lookahead.
- `seq_steps`: the number of steps to take for each car per round.
"""
function greedy_lookahead(city, n_lookahead=15, seq_steps=5)
    total_duration = city.total_duration
    nb_cars = city.nb_cars
    starting_junction = city.starting_junction
    # total_duration = 1000
    @info "Total Duration" (total_duration)
    graph = create_graph(city)

    itineraries = [[starting_junction] for i in 1:nb_cars]
    times = zeros(nb_cars)
    terminate = falses(nb_cars)

    visited = Set{Tuple{Int64,Int64}}()

    while all(terminate) == false
        for c in 1:nb_cars
            if terminate[c]
                continue
            end
            current_junction = last(itineraries[c])
            dist, iten = lookahead_tree(
                graph, current_junction, visited, n_lookahead, total_duration - times[c]
            )

            if length(iten) >= 2
                for stops in 2:min(1 + seq_steps, length(iten))
                    next_junction = iten[stops][1]
                    traverse_time = edge_time(graph, current_junction, next_junction)
                    times[c] += traverse_time

                    push!(itineraries[c], next_junction)
                    push!(visited, (current_junction, next_junction))
                    push!(visited, (next_junction, current_junction))
                    current_junction = next_junction
                end
            else
                terminate[c] = true
            end
        end
    end

    @info "End" times
    return Solution(itineraries)
end
