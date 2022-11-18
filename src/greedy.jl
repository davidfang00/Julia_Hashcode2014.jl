"""
    greedy(city)
Implements a greedy algorithm for routing. Cars will take turns going down one street at a time based on the follow criteria:
- Check if the node has been visited. If not, take the maximum distance while obeying time constraints.
- If a node has been visited, check the next node.
- If all possible nodes have been visited, choose a random node while obeying the time constraint.
"""
function greedy(city::City)
	(; total_duration, nb_cars, starting_junction, streets) = city
	# total_duration = 1000
	println(total_duration)
	graph = create_graph(city)
	
	itineraries = [[starting_junction] for i in 1:nb_cars]
	times = zeros(nb_cars)
	terminate = falses(nb_cars)
	println(itineraries, typeof(itineraries))
	println(times, typeof(times))
	println(terminate, typeof(terminate))
	
	visited = Set()

	while all(terminate) == false
		for c in 1:nb_cars
			# println(c, itineraries[c], times, terminate)
			if times[c] >= total_duration
				terminate[c] = true
				continue
			end

			current_junction = last(itineraries[c])
			candidates = outneighbors(graph, current_junction)
			if isempty(candidates)
				break
			end

			all_visited = true
			next_junction = false
			# println(current_junction, candidates, visited)
			
			for i in eachindex(candidates)
				candidate = candidates[i]
				traverse_time = edge_time(graph, current_junction, candidate)
				if traverse_time + times[c] <= total_duration && in(candidate, visited) == false
					all_visited = false
					times[c] += traverse_time
					next_junction = candidate
					# println(candidate)
					break
				end
			end
			
			if all_visited
				for i in eachindex(candidates)
					candidate = rand(candidates[1:min(4,end)])
					traverse_time = edge_time(graph, current_junction, candidate)
					if traverse_time + times[c] <= total_duration
						times[c] += traverse_time
						next_junction = candidate
						break
					end
				end
			end
			# println(c, next_junction)
			
			if next_junction == false
				# println(c)
				terminate[c] = true
			else
				push!(itineraries[c], next_junction)
				push!(visited, next_junction)
			end
		end
	end
	print(times)
	return Solution(itineraries)		
end