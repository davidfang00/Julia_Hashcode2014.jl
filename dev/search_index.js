var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"CurrentModule = Julia_Hashcode2014","category":"page"},{"location":"#Julia_Hashcode2014","page":"Home","title":"Julia_Hashcode2014","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Documentation for Julia_Hashcode2014.","category":"page"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [Julia_Hashcode2014]","category":"page"},{"location":"#Julia_Hashcode2014.AdjacencyGraph","page":"Home","title":"Julia_Hashcode2014.AdjacencyGraph","text":"AdjacencyGraph\n\nStore a city in the form of an weighted adjacency graph. Weights are based on length. \n\nFields\n\noutneighbors::Vector{Vector{Int}}: junctions\nweights::Vector{Vector{Float64}}: weights based on length for each street.\ntimes::Dict{Tuple{Int,Int},Float64}: the time it takes to travel a street.\n\n\n\n\n\n","category":"type"},{"location":"#Julia_Hashcode2014.TreeNode","page":"Home","title":"Julia_Hashcode2014.TreeNode","text":"TreeNode\n\nStores nodes in a graph. Each node only has 1 parent node.\n\nFields\n\nparent::Union{TreeNode, Nothing}: The parent node/junction.\njunction::Int64: The junction index.\ntime_elapsed::Float64: the total time that has elapsed to reach this junction from the start.\ndistance_traveled::Float64: the total distrance traveled to reach this junction from the start.\npath_visited::Set{Tuple{Int64, Int64}}: the (u, v) paths taken to reach this junction from the start.\n\n\n\n\n\n","category":"type"},{"location":"#Julia_Hashcode2014.create_graph-Tuple{HashCode2014.City}","page":"Home","title":"Julia_Hashcode2014.create_graph","text":"create_graph(city)\n\nCreate an AdjacencyGraph based on a city.\n\n\n\n\n\n","category":"method"},{"location":"#Julia_Hashcode2014.edge_time-Tuple{AdjacencyGraph, Any, Any}","page":"Home","title":"Julia_Hashcode2014.edge_time","text":"edge_time(g, u, v)\n\nReturns the time it takes to traverse the path (u, v) based on an AdjacencyGraph g.\n\n\n\n\n\n","category":"method"},{"location":"#Julia_Hashcode2014.edge_weight-Tuple{AdjacencyGraph, Any, Any}","page":"Home","title":"Julia_Hashcode2014.edge_weight","text":"edge_weight(g, u, v)\n\nReturns the distance that the path (u, v) will traverse based on an AdjacencyGraph g.\n\n\n\n\n\n","category":"method"},{"location":"#Julia_Hashcode2014.greedy-Tuple{HashCode2014.City}","page":"Home","title":"Julia_Hashcode2014.greedy","text":"greedy(city)\n\nImplements a greedy algorithm for routing. Cars will take turns going down one street at a time based on the follow criteria:\n\nCheck if the neighboring node has been visited. If not, take the maximum distance path while obeying time constraints.\nIf a neighboring node has been visited, check the next node.\nIf all neighboring nodes have been visited, choose a random path to go down while obeying the time constraint.\n\n\n\n\n\n","category":"method"},{"location":"#Julia_Hashcode2014.greedy_lookahead","page":"Home","title":"Julia_Hashcode2014.greedy_lookahead","text":"greedy_lookahead(city, n_lookahead = 15, seq_steps = 7)\n\nA greedy algorithm that uses BFS to lookahead from the start node throughout the graph while obeying the time constraints. Uses a distance metric to select best itinerary.\n\nParameters\n\ncity: The city (as a City from HashCode2014)\nn_lookahead: The number of BFS levels to lookahead.\nseq_steps: the number of steps to take for each car per round.\n\n\n\n\n\n","category":"function"},{"location":"#Julia_Hashcode2014.lookahead_tree-NTuple{5, Any}","page":"Home","title":"Julia_Hashcode2014.lookahead_tree","text":"lookahead_tree(graph, start, visited, n, time_remaining)\n\nUses BFS to lookahead from the start node throughout the graph while obeying the time constraints. Uses a distance metric to select best itinerary. Returns a (best distance, best itinerary) tuple.\n\nParameters\n\ngraph::AdjacencyGraph: The AdjacencyGraph representing the city.\nstart: The starting junction index.\nvisited: the (u, v) paths that have already been taken by any cars.\nn: the number of levels to iterate for BFS.\ntime_remaining: the remaining time for the car to travel.\n\n\n\n\n\n","category":"method"},{"location":"#Julia_Hashcode2014.outneighbors-Tuple{AdjacencyGraph, Any}","page":"Home","title":"Julia_Hashcode2014.outneighbors","text":"outneighbors(g, u)\n\nReturns the outneighbors of node u based on an AdjacencyGraph g.\n\n\n\n\n\n","category":"method"}]
}
