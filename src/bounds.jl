"""
    find_bound(city, nb_cars = 8, time = 54000)
Finds the maximum distance bound for a city based on the number of cars and the time constraint.
Sorts the streets by speed, and takes turns sending cars down each successive street until the time constraint is met.

# Parameters
- `city::City`: the city.
- `nb_cars::Int`: the number of cars.
- `time::Float64`: the time constraint in seconds. 
"""
function find_bound(city::City, nb_cars::Int=8, time::Float64=54000.0)
    streets_by_speed = sort(city.streets; by=x -> x.distance / x.duration, rev=true)
    d = 0
    s = 1
    times = zeros(nb_cars)
    terminate = falses(nb_cars)
    while all(terminate) == false
        for c in 1:nb_cars
            if s > length(streets_by_speed)
                return d
            end

            if times[c] + streets_by_speed[s].duration <= time
                times[c] += streets_by_speed[s].duration
                d += streets_by_speed[s].distance
                s += 1
            else
                terminate[c] = true
            end
        end
    end
    return d
end
