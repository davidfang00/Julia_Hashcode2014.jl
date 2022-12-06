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

"""
    function greedy_lookahead_dijkstras_fandown(city, n_lookahead = 15, seq_steps = 15)
A greedy algorithm that uses BFS to lookahead from the start node throughout the graph while obeying the time constraints. 
Sends 4 cars to the N/E/S/W corners using Dijkstra's and uses fandown for the remaining cars.
Uses lookahead_tree_bounded as a lookahead algorithm and uses a speed metric to select best itinerary.
Removes duplicates and repeats the lookahead algorithm.

Takes around 20 seconds to run (with default parameters) and obtains a score of around 1.65-1.8 million.

# Parameters
- `city::City`: The city (as a City from HashCode2014)
- `n_lookahead`: The number of BFS levels to lookahead.
- `seq_steps`: the number of steps to take for each car per round.
"""
function greedy_lookahead_dijkstras_fandown(city, n_lookahead=15, seq_steps=15)
    total_duration = city.total_duration
    nb_cars = city.nb_cars
    starting_junction = city.starting_junction
    graph = AdjacencyGraph(city)

    itineraries = [[starting_junction] for i in 1:nb_cars]
    times = zeros(nb_cars)
    terminate = falses(nb_cars)
    @info "Total Duration" (total_duration)

    visited = Set{Tuple{Int64,Int64}}()

    nesw = find_nesw(city)
    nesw_junctions = city.junctions[nesw]
    # finds the latitude and longitude bounds by using NESW points
    mid_lat = (nesw_junctions[1].latitude + nesw_junctions[3].latitude) / 2
    mid_long = (nesw_junctions[2].longitude + nesw_junctions[4].longitude) / 2
    lat25 = (nesw_junctions[3].latitude + mid_lat) / 2
    lat75 = (nesw_junctions[1].latitude + mid_lat) / 2
    long25 = (mid_long + nesw_junctions[4].longitude) / 2
    long75 = (mid_long + nesw_junctions[2].longitude) / 2

    # sends cars out to NESW points
    dists, parents = dijkstra(graph, starting_junction)
    for c in 1:min(length(nesw), nb_cars)
        current_junction = starting_junction
        target = nesw[c]
        path = spath(target, dists, starting_junction, parents)
        # sends the cars about 86% of the way towards the bound ends
        for stops in 2:trunc(Int, length(path) / 1.15)
            next_junction = path[stops][1]
            traverse_time = edge_time(graph, current_junction, next_junction)
            times[c] += traverse_time

            push!(itineraries[c], next_junction)
            push!(visited, (current_junction, next_junction))
            push!(visited, (next_junction, current_junction))
            current_junction = next_junction
        end
    end

    # fandowns the rest of the cars (5-8)
    init_iter = 40
    diff_rand = 5
    for iter in 1:init_iter
        for c in 5:nb_cars
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
            push!(visited, (current_junction, next_junction))
        end
    end

    # 1 runthrough of lookahead method, stops at loop_count bc it gets slow after that point
    for c in 1:nb_cars
        loop_count = 0
        while terminate[c] == false
            loop_count += 1

            current_junction = last(itineraries[c])
            lat_min, lat_max, long_min, long_max = 0, 1000, 0, 1000
            if c == 1
                lat_min, lat_max, long_min, long_max = mid_lat, 1000, mid_long, 1000
            elseif c == 2
                lat_min, lat_max, long_min, long_max = 0, mid_lat, mid_long, 1000
            elseif c == 3
                lat_min, lat_max, long_min, long_max = 0, mid_lat, 0, mid_long
            elseif c == 4
                lat_min, lat_max, long_min, long_max = mid_lat, 1000, 0, mid_long
            elseif c == 5
                lat_min, lat_max, long_min, long_max = mid_lat, 1000, 0, 1000
            elseif c == 6
                lat_min, lat_max, long_min, long_max = 0, 1000, mid_long, 1000
            elseif c == 7
                lat_min, lat_max, long_min, long_max = 0, mid_lat, 0, 1000
            elseif c == 8
                lat_min, lat_max, long_min, long_max = 0, 1000, 0, mid_long
            end

            dist, iten = lookahead_tree_bounded(
                graph,
                current_junction,
                visited,
                n_lookahead,
                total_duration - times[c],
                city,
                lat_min,
                lat_max,
                long_min,
                long_max,
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

            if loop_count >= 900
                terminate[c] = true
            end
        end
    end

    # removes duplicates (loop between two points) like when you go from junction 1 to junction 2
    # and then back
    for j in 1:5
        for i in 1:length(itineraries)
            itineraries[i] = remove_dups(itineraries[i])
        end
    end
    times = recalculate_times(graph, itineraries)
    terminate = falses(nb_cars)

    # when you take out the duplicate paths, you get time back so we run the lookahead_tree_bounded
    # again starting where the last run finished and just let the cars run for whatever amount of time they 
    # have saved after removing duplicates
    for c in nb_cars:-1:1
        loop_count = 0
        while terminate[c] == false
            loop_count += 1

            current_junction = last(itineraries[c])
            lat_min, lat_max, long_min, long_max = 0, 1000, 0, 1000
            dist, iten = lookahead_tree_bounded(
                graph,
                current_junction,
                visited,
                n_lookahead,
                total_duration - times[c],
                city,
                lat_min,
                lat_max,
                long_min,
                long_max,
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

            if loop_count >= 500
                terminate[c] = true
            end
        end
    end

    return Solution(itineraries)
end
