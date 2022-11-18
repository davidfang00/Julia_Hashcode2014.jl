var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"CurrentModule = Julia_Hashcode2014","category":"page"},{"location":"#Julia_Hashcode2014","page":"Home","title":"Julia_Hashcode2014","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Documentation for Julia_Hashcode2014.","category":"page"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [Julia_Hashcode2014]","category":"page"},{"location":"#Julia_Hashcode2014.AdjacencyGraph","page":"Home","title":"Julia_Hashcode2014.AdjacencyGraph","text":"AdjacencyGraph\n\nStore a city in the form of an weighted adjacency graph. Weights are based on length. \n\nFields\n\noutneighbors::Vector{Vector{Int}}: junctions\nweights::Vector{Vector{Float64}}: weights based on length for each street.\ntimes::Dict{Tuple{Int,Int},Float64}: the time it takes to travel a street.\n\n\n\n\n\n","category":"type"},{"location":"#Julia_Hashcode2014.City","page":"Home","title":"Julia_Hashcode2014.City","text":"City\n\nStore a city made of Junctions and Streets, along with additional instance parameters.\n\nFields\n\ntotal_duration::Int: total time allotted for the car itineraries (in seconds)\nnb_cars::Int: number of cars in the fleet\nstarting_junction::Int: junction at which all the cars are located initially\njunctions::Vector{Junction}: list of junctions\nstreets::Vector{Street}: list of streets\n\n\n\n\n\n","category":"type"},{"location":"#Julia_Hashcode2014.Junction","page":"Home","title":"Julia_Hashcode2014.Junction","text":"Junction\n\nStore a city junction.\n\nFields\n\nlatitude::Float64: latitude (in decimal degrees)\nlongitude::Float64: longitude (in decimal degrees)\n\n\n\n\n\n","category":"type"},{"location":"#Julia_Hashcode2014.Solution","page":"Home","title":"Julia_Hashcode2014.Solution","text":"Solution\n\nStore a set of itineraries, one for each car.\n\nFields\n\nitineraries::Vector{Vector{Int}}: each itinerary is a vector of junction indices\n\n\n\n\n\n","category":"type"},{"location":"#Julia_Hashcode2014.Street","page":"Home","title":"Julia_Hashcode2014.Street","text":"Street Store an edge between two Junctions.\n\nFields\n\nendpointA::Int: index of the first junction\nendpointB::Int: index of the second junction\nbidirectional::Bool: whether B -> A is allowed\nduration::Int: time cost of traversing the street (in seconds)\ndistance::Int: length of the street (in meters)\n\n\n\n\n\n","category":"type"},{"location":"#Julia_Hashcode2014.edge_time-Tuple{AdjacencyGraph, Any, Any}","page":"Home","title":"Julia_Hashcode2014.edge_time","text":"edge_time(g, u, v)\n\nReturns the time it takes to traverse the path (u, v) based on an AdjacencyGraph g.\n\n\n\n\n\n","category":"method"},{"location":"#Julia_Hashcode2014.edge_weight-Tuple{AdjacencyGraph, Any, Any}","page":"Home","title":"Julia_Hashcode2014.edge_weight","text":"edge_weight(g, u, v)\n\nReturns the distance that the path (u, v) will traverse based on an AdjacencyGraph g.\n\n\n\n\n\n","category":"method"},{"location":"#Julia_Hashcode2014.get_street_end-Tuple{Integer, Street}","page":"Home","title":"Julia_Hashcode2014.get_street_end","text":"get_street_end(i, street)\n\nRetrieve the arrival endpoint of street when it starts at junction i.\n\n\n\n\n\n","category":"method"},{"location":"#Julia_Hashcode2014.greedy-Tuple{City}","page":"Home","title":"Julia_Hashcode2014.greedy","text":"greedy(city)\n\nImplements a greedy algorithm for routing. Cars will take turns going down one street at a time based on the follow criteria:\n\nCheck if the neighboring node has been visited. If not, take the maximum distance path while obeying time constraints.\nIf a neighboring node has been visited, check the next node.\nIf all neighboring nodes have been visited, choose a random path to go down while obeying the time constraint.\n\n\n\n\n\n","category":"method"},{"location":"#Julia_Hashcode2014.is_feasible-Tuple{Solution, City}","page":"Home","title":"Julia_Hashcode2014.is_feasible","text":"is_feasible(solution, city[; verbose=false])\n\nCheck if solution satisfies the constraints for the instance defined by city. The following criteria are considered (taken from the problem statement):\n\nthe number of itineraries has to match the number of cars of city\nthe first junction of each itinerary has to be the starting junction of city\nfor each consecutive pair of junctions on an itinerary, a street connecting these junctions has to exist in city (if the street is one directional, it has to be traversed in the correct direction)\nthe duration of each itinerary has to be lower or equal to the total duration of city\n\n\n\n\n\n","category":"method"},{"location":"#Julia_Hashcode2014.is_street-Tuple{Integer, Integer, Street}","page":"Home","title":"Julia_Hashcode2014.is_street","text":"is_street(i, j, street)\n\nCheck if the trip from junction i to junction j corresponds to a valid direction of street.\n\n\n\n\n\n","category":"method"},{"location":"#Julia_Hashcode2014.is_street_start-Tuple{Integer, Street}","page":"Home","title":"Julia_Hashcode2014.is_street_start","text":"is_street_start(i, street)\n\nCheck if junction i corresponds to a valid starting point of street.\n\n\n\n\n\n","category":"method"},{"location":"#Julia_Hashcode2014.outneighbors-Tuple{AdjacencyGraph, Any}","page":"Home","title":"Julia_Hashcode2014.outneighbors","text":"outneighbors(g, u)\n\nReturns the outneighbors of node u based on an AdjacencyGraph g.\n\n\n\n\n\n","category":"method"},{"location":"#Julia_Hashcode2014.plot_streets","page":"Home","title":"Julia_Hashcode2014.plot_streets","text":"plot_streets(city, solution=nothing; path=nothing)\n\nPlot a City and an optional Solution using the Python library folium, save the result as an HTML file at path.\n\n\n\n\n\n","category":"function"},{"location":"#Julia_Hashcode2014.read_city","page":"Home","title":"Julia_Hashcode2014.read_city","text":"read_city(path)\n\nRead and parse a City from a file located at path. The default path is an artifact containing the official challenge data.\n\n\n\n\n\n","category":"function"},{"location":"#Julia_Hashcode2014.read_solution-Tuple{Any}","page":"Home","title":"Julia_Hashcode2014.read_solution","text":"read_solution(solution, path)\n\nRead and parse a Solution from a file located at path.\n\n\n\n\n\n","category":"method"},{"location":"#Julia_Hashcode2014.total_distance-Tuple{Solution, City}","page":"Home","title":"Julia_Hashcode2014.total_distance","text":"total_distance(solution, city)\n\nCompute the total distance of all itineraries in solution based on the street data from city. Streets visited several times are only counted once.\n\n\n\n\n\n","category":"method"},{"location":"#Julia_Hashcode2014.write_city-Tuple{City, Any}","page":"Home","title":"Julia_Hashcode2014.write_city","text":"write_city(city, path)\n\nWrite a City to a file located at path.\n\n\n\n\n\n","category":"method"},{"location":"#Julia_Hashcode2014.write_solution-Tuple{Solution, Any}","page":"Home","title":"Julia_Hashcode2014.write_solution","text":"write_solution(solution, path)\n\nWrite a Solution to a file located at path.\n\n\n\n\n\n","category":"method"}]
}
