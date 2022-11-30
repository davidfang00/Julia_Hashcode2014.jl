"""
    greedy_lookahead(city, n_lookahead, seq_steps)
A greedy algorithm that uses BFS to lookahead from the start node throughout the graph while obeying the time constraints. Uses a distance metric to select best itinerary.

Takes around 20 seconds to run (with default parameters) and obtains a score of around 1.3-1.45 million.

# Parameters
- `city::City`: The city (as a City from HashCode2014)
- `n_lookahead`: The number of BFS levels to lookahead.
- `seq_steps`: the number of steps to take for each car per round.
"""
function greedy_lookahead(city::City, n_lookahead=15, seq_steps=5)
    total_duration = city.total_duration
    nb_cars = city.nb_cars
    starting_junction = city.starting_junction
    # total_duration = 1000
    @info "Total Duration" (total_duration)
    graph = AdjacencyGraph(city)

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
