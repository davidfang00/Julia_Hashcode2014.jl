"""
    greedy(city)
Implements a greedy algorithm for routing. Cars will take turns going down one street at a time based on the follow criteria:
- Check if the neighboring node has been visited. If not, take the maximum distance path while obeying time constraints.
- If a neighboring node has been visited, check the next node.
- If all neighboring nodes have been visited, choose a random path to go down while obeying the time constraint.
"""
function greedy(city::City)
    total_duration = city.total_duration
    nb_cars = city.nb_cars
    starting_junction = city.starting_junction
    # total_duration = 1000
    @info "Total Duration" (total_duration)
    graph = create_graph(city)

    itineraries = [[starting_junction] for i in 1:nb_cars]
    times = zeros(nb_cars)
    terminate = falses(nb_cars)

    visited = Set()

    while all(terminate) == false
        for c in 1:nb_cars
            current_junction = last(itineraries[c])
            candidates = outneighbors(graph, current_junction)

            all_visited = true
            next_junction = false

            for i in eachindex(candidates)
                candidate = candidates[i]
                traverse_time = edge_time(graph, current_junction, candidate)
                if traverse_time + times[c] <= total_duration &&
                    in(candidate, visited) == false
                    all_visited = false
                    times[c] += traverse_time
                    next_junction = candidate
                    break
                end
            end

            if all_visited
                for i in eachindex(candidates)
                    candidate = rand(candidates[1:min(4, end)])
                    traverse_time = edge_time(graph, current_junction, candidate)
                    if traverse_time + times[c] <= total_duration
                        times[c] += traverse_time
                        next_junction = candidate
                        break
                    end
                end
            end

            if next_junction == false
                terminate[c] = true
            else
                push!(itineraries[c], next_junction)
                push!(visited, next_junction)
            end
        end
    end
    @info "End" times
    return Solution(itineraries)
end
