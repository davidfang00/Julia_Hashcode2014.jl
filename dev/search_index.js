var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"CurrentModule = Julia_Hashcode2014","category":"page"},{"location":"#Julia_Hashcode2014","page":"Home","title":"Julia_Hashcode2014","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Documentation for Julia_Hashcode2014.","category":"page"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [Julia_Hashcode2014]","category":"page"},{"location":"#Julia_Hashcode2014.AdjacencyGraph","page":"Home","title":"Julia_Hashcode2014.AdjacencyGraph","text":"AdjacencyGraph\n\nStore a city in the form of an weighted adjacency graph. Weights are based on length. \n\nFields\n\noutneighbors::Vector{Vector{Int}}: junctions\nweights::Vector{Vector{Float64}}: weights based on length for each street.\ntimes::Dict{Tuple{Int,Int},Float64}: the time it takes to travel a street.\n\n\n\n\n\n","category":"type"},{"location":"#Julia_Hashcode2014.TreeNode","page":"Home","title":"Julia_Hashcode2014.TreeNode","text":"TreeNode\n\nStores nodes in a graph. Each node only has 1 parent node. Used for backtracking BFS lookahead trees.\n\nFields\n\nparent::Union{TreeNode, Nothing}: The parent node/junction.\njunction::Int64: The junction index.\ntime_elapsed::Float64: the total time that has elapsed to reach this junction from the start.\ndistance_traveled::Float64: the total distrance traveled to reach this junction from the start.\npath_visited::Set{Tuple{Int64, Int64}}: the (u, v) paths taken to reach this junction from the start.\n\n\n\n\n\n","category":"type"},{"location":"#Julia_Hashcode2014.create_graph-Tuple{HashCode2014.City}","page":"Home","title":"Julia_Hashcode2014.create_graph","text":"create_graph(city)\n\nCreate an AdjacencyGraph based on a city.\n\n\n\n\n\n","category":"method"},{"location":"#Julia_Hashcode2014.dijkstra-Tuple{AdjacencyGraph, Any}","page":"Home","title":"Julia_Hashcode2014.dijkstra","text":"dijkstra(g, s)\n\nFinds the shortest path (in terms of time) from the source to all other points in the graph g and the parents list to reconstruct the shortest path. Returns a tuple (shortest_path, parents).\n\nParameters\n\ng: The city as a AdjacencyGraph.\ns: The source junction index.\n\n\n\n\n\n","category":"method"},{"location":"#Julia_Hashcode2014.edge_time-Tuple{AdjacencyGraph, Any, Any}","page":"Home","title":"Julia_Hashcode2014.edge_time","text":"edge_time(g, u, v)\n\nReturns the time it takes to traverse the path (u, v) based on an AdjacencyGraph g.\n\n\n\n\n\n","category":"method"},{"location":"#Julia_Hashcode2014.edge_weight-Tuple{AdjacencyGraph, Any, Any}","page":"Home","title":"Julia_Hashcode2014.edge_weight","text":"edge_weight(g, u, v)\n\nReturns the distance that the path (u, v) will traverse based on an AdjacencyGraph g.\n\n\n\n\n\n","category":"method"},{"location":"#Julia_Hashcode2014.fandown_greedy","page":"Home","title":"Julia_Hashcode2014.fandown_greedy","text":"fandown_greedy(city, n_lookahead = 15, seq_steps = 7, init_iter = 100, diff_rand = 5)\n\nA greedy algorithm that uses BFS to lookahead from the start node throughout the graph while obeying the time constraints. At the start, has all cars \"fandown\" to reach a more center position in the city. Uses a distance metric to select best itinerary.\n\nTakes around 15 seconds to run (with default parameters) and obtains a score of around 1.35-1.47 million.\n\nParameters\n\ncity: The city (as a City from HashCode2014)\nn_lookahead: The number of BFS levels to lookahead.\nseq_steps: the number of steps to take for each car per round.\ninit_iter: number of iterations to fandown the cars in the beginning\ndiff_rand: probability must taking the same path\n\n\n\n\n\n","category":"function"},{"location":"#Julia_Hashcode2014.find_bound","page":"Home","title":"Julia_Hashcode2014.find_bound","text":"find_bound(city, nb_cars = 8, time = 54000)\n\nFinds the maximum distance bound for a city based on the number of cars and the time constraint. Sorts the streets by speed, and takes turns sending cars down each successive street until the time constraint is met.\n\nParameters\n\ncity::City: the city.\nnb_cars::Int: the number of cars.\ntime::Float64: the time constraint in seconds. \n\n\n\n\n\n","category":"function"},{"location":"#Julia_Hashcode2014.find_nesw-Tuple{HashCode2014.City}","page":"Home","title":"Julia_Hashcode2014.find_nesw","text":"find_nesw(city)\n\nFinds the most north, east, south, and west points of a city by using the min/max latitude and longitude. Returns result as a vector [N, E, S, W] with elements as junction indices.\n\nParameters\n\ncity::City: The city (as a City from HashCode2014)\n\n\n\n\n\n","category":"method"},{"location":"#Julia_Hashcode2014.greedy-Tuple{HashCode2014.City}","page":"Home","title":"Julia_Hashcode2014.greedy","text":"greedy(city)\n\nImplements a greedy algorithm for routing. Cars will take turns going down one street at a time based on the follow criteria:\n\nCheck if the neighboring node has been visited. If not, take the maximum distance path while obeying time constraints.\nIf a neighboring node has been visited, check the next node.\nIf all neighboring nodes have been visited, choose a random path to go down while obeying the time constraint.\n\nTakes around 1-2 seconds to run and obtains a score of around 1.1-1.25 million.\n\nParameters\n\ncity::City: The city (as a City from HashCode2014)\n\n\n\n\n\n","category":"method"},{"location":"#Julia_Hashcode2014.greedy_lookahead","page":"Home","title":"Julia_Hashcode2014.greedy_lookahead","text":"greedy_lookahead(city, n_lookahead, seq_steps)\n\nA greedy algorithm that uses BFS to lookahead from the start node throughout the graph while obeying the time constraints. Uses a distance metric to select best itinerary.\n\nTakes around 20 seconds to run (with default parameters) and obtains a score of around 1.3-1.45 million.\n\nParameters\n\ncity::City: The city (as a City from HashCode2014)\nn_lookahead: The number of BFS levels to lookahead.\nseq_steps: the number of steps to take for each car per round.\n\n\n\n\n\n","category":"function"},{"location":"#Julia_Hashcode2014.lookahead_tree-Tuple{AdjacencyGraph, Any, Any, Any, Any}","page":"Home","title":"Julia_Hashcode2014.lookahead_tree","text":"lookahead_tree(graph, start, visited, n, time_remaining)\n\nUses BFS to lookahead from the start node throughout the graph while obeying the time constraints.  Uses a distance metric to select best itinerary. Any paths already traveled are heavily discounted in the metric. Returns a (best distance, best itinerary) tuple. \n\nParameters\n\ngraph::AdjacencyGraph: The AdjacencyGraph representing the city.\nstart: The starting junction index.\nvisited: the (u, v) paths that have already been taken by any cars.\nn: the number of levels to iterate for BFS.\ntime_remaining: the remaining time for the car to travel.\n\n\n\n\n\n","category":"method"},{"location":"#Julia_Hashcode2014.outneighbors-Tuple{AdjacencyGraph, Any}","page":"Home","title":"Julia_Hashcode2014.outneighbors","text":"outneighbors(g, u)\n\nReturns the outneighbors of node u based on an AdjacencyGraph g.\n\n\n\n\n\n","category":"method"},{"location":"#Julia_Hashcode2014.spath-NTuple{4, Any}","page":"Home","title":"Julia_Hashcode2014.spath","text":"spath(x, dists, source, parents)\n\nReturns the shortest path (in terms of time) from the source to the junction x.\n\nParameters\n\nx: The target junction index.\ndists: The shortest paths in terms of time from dijkstra.\nsource: The source junction index.\nparents: The parents array from dijkstra.\n\n\n\n\n\n","category":"method"}]
}
