"""
    find_nesw(city)
Finds the most north, east, south, and west points of a city by using the min/max latitude and longitude.
Returns result as a vector [N, E, S, W] with elements as junction indices.
# Parameters
- `city`: The city (as a City from HashCode2014)
"""
function find_nesw(city)
    result = Vector{Int}()
    junctions = city.junctions
    latitudes = [j.latitude for j in junctions]
    longitudes = [j.longitude for j in junctions]

    max_latitude = argmax(latitudes)
    min_latitude = argmin(latitudes)
    max_longitude = argmax(longitudes)
    min_longitude = argmin(longitudes)

    push!(result, max_latitude)
    push!(result, max_longitude)
    push!(result, min_latitude)
    push!(result, min_longitude)

    return result
end
