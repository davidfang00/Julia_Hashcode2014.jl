"""
    remove_dups(itinerary)
Returns the itinerary after removing duplicates. 
Removed duplicates that are in the form `[...,1,2,1,2,...]` -> `[...,1,2,...]`.
# Parameters
- `itinerary::Vector{Int64}`: the vector itinerary of a car.
"""
function remove_dups(itinerary)
    if length(itinerary) > 6 #make sure there are at least 6 junctions in the itinerary
        repeats_removed = Vector{Int64}()
        i = 1
        while i <= length(itinerary)
            if i <= length(itinerary) - 4 &&
                itinerary[i] == itinerary[i + 2] &&
                itinerary[i + 1] == itinerary[i + 3]
                push!(repeats_removed, itinerary[i])
                push!(repeats_removed, itinerary[i + 1])
                i += 4
            else
                push!(repeats_removed, itinerary[i])
                i += 1
            end
        end
        return repeats_removed
    end
    return itinerary
end

"""
    recalculate_times(graph, itineraries)
Calculates the amount of time needed to fulfill the itineraries.
# Parameters
- `graph::AdjacencyGraph`: The [`AdjacencyGraph`](@ref) representing the city.
- `itinerary::Vector{Vector{Int64}}`: the vector itinerary of a car.
"""
function recalculate_times(graph, itineraries)
    times = zeros(length(itineraries))
    for c in 1:length(itineraries)
        iten = itineraries[c]
        for idx in 1:(length(iten) - 1)
            times[c] += edge_time(graph, iten[idx], iten[idx + 1])
        end
    end
    return times
end
