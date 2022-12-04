"""
    fandown_greedy(city, n_lookahead = 15, seq_steps = 7, init_iter = 100, diff_rand = 5)
A greedy algorithm that uses BFS to lookahead from the start node throughout the graph while obeying the time constraints. At the start, has all cars "fandown" to reach a more center position in the city. Uses a distance metric to select best itinerary.

Takes around 15 seconds to run (with default parameters) and obtains a score of around 1.35-1.47 million.

# Parameters
- `city`: The city (as a City from HashCode2014)
- `n_lookahead`: The number of BFS levels to lookahead.
- `seq_steps`: the number of steps to take for each car per round.
- `init_iter`: number of iterations to fandown the cars in the beginning
- `diff_rand`: probability must taking the same path
"""
function fandown_greedy(city::City, n_lookahead=15, seq_steps=7, init_iter=100, diff_rand=5)
    (; total_duration, nb_cars, starting_junction, streets) = city
    # total_duration = 1000
    @info "Total Duration" (total_duration)
    graph = AdjacencyGraph(city)

    itineraries = [[starting_junction] for i in 1:nb_cars]
    times = zeros(nb_cars)
    terminate = falses(nb_cars)

    visited = Set{Union{Tuple{Int64,Int64},Int64}}()

    for iter in 1:init_iter
        for c in 1:nb_cars
            current_junction = last(itineraries[c])
            curr_y = (city.junctions[current_junction].latitude)

            least_diff = Base.Inf
            must_diff = rand(1:diff_rand)

            candidates = outneighbors(graph, current_junction)
            best_cand = candidates[1]

            for i in eachindex(candidates)
                candidate = candidates[i]
                cand_y = (city.junctions[candidate].latitude)
                curr_ydiff = cand_y - curr_y

                if curr_ydiff < least_diff &&
                    ((must_diff == 1 && in(candidate, visited) == false) || must_diff != 1)
                    least_diff = curr_ydiff
                    best_cand = candidate
                end
            end
            traverse_time = edge_time(graph, current_junction, best_cand)
            times[c] += traverse_time
            next_junction = best_cand

            push!(itineraries[c], next_junction)
            push!(visited, next_junction)
        end
    end

    while all(terminate) == false
        for c in 1:nb_cars
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
