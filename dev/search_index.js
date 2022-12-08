var documenterSearchIndex = {"docs":
[{"location":"algos/","page":"Algorithms","title":"Algorithms","text":"CurrentModule = Julia_Hashcode2014","category":"page"},{"location":"algos/#Algorithms-in-Julia_Hashcode2014","page":"Algorithms","title":"Algorithms in Julia_Hashcode2014","text":"","category":"section"},{"location":"algos/","page":"Algorithms","title":"Algorithms","text":"Documentation for the algorithms in Julia_Hashcode2014.","category":"page"},{"location":"algos/","page":"Algorithms","title":"Algorithms","text":"This document outlines many separate algorithms that each described with performance in mind. It is then followed by the most optimal solution at the end of the document that incorporates all the separate algorithms together into one complete algorithm.","category":"page"},{"location":"algos/#Greedy","page":"Algorithms","title":"Greedy","text":"","category":"section"},{"location":"algos/","page":"Algorithms","title":"Algorithms","text":"The greedy approach is the one of the simplest approaches to implement that yields fairly sufficient results. In short, the greedy approach entails cars taking turns going down one street at a time and at each junction, the cars will determine the next street to take based off the following criteria:","category":"page"},{"location":"algos/","page":"Algorithms","title":"Algorithms","text":"Inspect all outgoing neighboring junctions. Out of the ones that are unvisited, the car will choose to go the junction where there is a maximum distance between its current junction and the next (while still obeying the time constraints).\nIf all outgoing neighbors have been visited, the car will choose a random junction to go to (while still obeying the time constraints). ","category":"page"},{"location":"algos/","page":"Algorithms","title":"Algorithms","text":"Greedy algorithms are designed for speed. Although the solution might not actually be the most optimal, we can be certain that at least the algorithm will be quick. For each car at each junction, the car must only look at its outgoing neighbors to make its next decision so its time complexity for each time step is O(V) where V is the number of vertices or junctions. This is certainly quite fast, considering there are usually not that many outgoing neighbors for each junction. ","category":"page"},{"location":"algos/","page":"Algorithms","title":"Algorithms","text":"Additionally, at each time/decision step for each car, we need to make a data structure of size O(V) for all the outgoing neighbors to see which candidate would be optimal to take. Thus, this requires an O(V) space complexity for each time step for each car, but considering that there usually are not that many outgoing neighbors at each junction, this is really not that bad.","category":"page"},{"location":"algos/","page":"Algorithms","title":"Algorithms","text":"The algorithm takes 1-2 seconds and achieves approximately 1.1-1.25 million meters traveled under the 54000 second time constraint.","category":"page"},{"location":"algos/#Greedy-Lookahead","page":"Algorithms","title":"Greedy Lookahead","text":"","category":"section"},{"location":"algos/","page":"Algorithms","title":"Algorithms","text":"A simple greedy algorithm can be better optimized with the addition of a lookahead approach. Under the lookahead approach, instead of the cars simply choosing the immediate street that offers the longest distance at each junction stop, the cars will now look at various paths from the current junction that contain the next 15 streets in sequence with the goal that that this path of 15 streets will be the longest distance covered in within the 15 timestamps. Thus, for each car, the greedy lookahead approach still uses a distance metric and utilizes BFS of 15 levels in order to find the most optimal path to take at a current junction.","category":"page"},{"location":"algos/","page":"Algorithms","title":"Algorithms","text":"Like before, we want to avoid taking visited streets as much as possible in order to increase coverage so BFS first looks through candidates of outgoing neighboring junctions to take that are unvisited. However, if all outgoing streets for a current junction lead to outgoing neighboring junctions have been visited, then a random candidate is chosen.","category":"page"},{"location":"algos/","page":"Algorithms","title":"Algorithms","text":"This algorithm will inherently be slower than a simple greedy algorithm and take more space as well. For each car, when it is ready to plan a path for the next 15 timestamps (getting ready to start a lookahead), it must first create a BFS tree from its current junction, which would be O(V) space complexity where V represents vertices or junctions. Traversing the BFS tree is also necessary to find an optimal path based on a distance metric so this would require O(V^15) time complexity to plan out a path for the next 15 steps (for the 15 levels of the BFS tree). Therefore, at the start of every 15 timestamps (beginning of lookahead), each car will have O(V^15) time complexity and O(V) space complexity.","category":"page"},{"location":"algos/","page":"Algorithms","title":"Algorithms","text":"Originally, we ran into efficiency and memory problems with our first BFS approach because we stored each possible path and their visited streets set into a list of lists. This consumed a lot of memory and was highly inefficient because we didn't need to store every possible path. To overcome this, we created a tree structure, which only stored nodes that should be tracked, and the paths could be retrieved by backtracking. This led to a speedup of around 2-3x compared to the first implementation.","category":"page"},{"location":"algos/","page":"Algorithms","title":"Algorithms","text":"This algorithm greatly increases the score, but makes a tradeoff in performance: the algorithm achieves 1.3-1.45 million meters traveled, but requires 20 seconds to run to completion. We are willing to make this tradeoff due to the needed increase in score.","category":"page"},{"location":"algos/#Greedy-LookaheadFandown","page":"Algorithms","title":"Greedy Lookahead+Fandown","text":"","category":"section"},{"location":"algos/","page":"Algorithms","title":"Algorithms","text":"This approach uses a fandown method that is then followed by a greedy lookahead approach. The rationale behind utilizing the fandown method stems from the fact that the headquarters is not located in the center of the map (it is in the upper left corner). Having a greedy lookahead approach start for the cars with this original starting point would not be ideal in terms of coverage because the cars would be disproportionately traversing the upper left corner area. ","category":"page"},{"location":"algos/","page":"Algorithms","title":"Algorithms","text":"Thus, the objective behind “fanning down” then is to initially move the cars down so that their starting positions can be closer to the center of the map. When greedy lookahead is then applied after, the coverage of the car paths will cover the map more evenly, due to a more central starting position. ","category":"page"},{"location":"algos/","page":"Algorithms","title":"Algorithms","text":"In order to fandown the cars, at each junction the cars will look at the outgoing neighbors and choose to go to the one that traverses in the south direction as much as possible (biggest difference in latitude values). However, we don’t want all the cars to take the same path down in the fandown process as this is wasted time that could be used to explore other streets. ","category":"page"},{"location":"algos/","page":"Algorithms","title":"Algorithms","text":"As a result, we still want the cars to take streets that lead them south near the center of the map, but we want to probabilistically have them take different streets at each junction. During the fandown process, at each junction the car must traverse a street that has not been visited before with a probability of 1/diff_rand, where diff_rand is a variable that can be fine-tuned. The default value of diff_rand is 5 so at each junction, there is ⅕ probability that the car must choose a street not visited before but has the next highest distance traveled south. ","category":"page"},{"location":"algos/","page":"Algorithms","title":"Algorithms","text":"The remaining algorithm after the fandown process completes follows the protocol of the greedy lookahead approach with no further changes.","category":"page"},{"location":"algos/","page":"Algorithms","title":"Algorithms","text":"The fandown process is quite efficient and does not add much extra space. The fandown process runs for a predetermined number of iterations (100 is the default value) and runs for a predetermined number of cars (4 cars if total number of cars is 8). At each time step, each car must look only at its outgoing neighbors, which is a time complexity of O(V). Again, we only add O(V) space complexity at each time/decision step for each car but this is marginal considering most junctions have few outgoing neighbors.","category":"page"},{"location":"algos/","page":"Algorithms","title":"Algorithms","text":"The greedy+fandown approach increases in score slightly, but decreases time by ~25%: this algorithm yields a score of 1.35-1.47 million meters and runs for 15 seconds.","category":"page"},{"location":"algos/#Dijkstras","page":"Algorithms","title":"Dijkstras","text":"","category":"section"},{"location":"algos/","page":"Algorithms","title":"Algorithms","text":"Rather than probabilistically sending cars down to a certain location at the start, another approach would be to determine set locations that we want to send cars to and do so in the most optimal way. In short, we want to increase coverage as much as possible by sending cars to explore all sides and areas as much as possible. Thus, this approach entails first finding 4 junctions : one at the largest latitude, one at the lowest latitude, one at the largest longitude, and one at the lowest longitude. The rationale is to move the cars in these positions so that they start in areas that cover the north, east, south, and west sections. ","category":"page"},{"location":"algos/","page":"Algorithms","title":"Algorithms","text":"Once the 4 junctions have been found that sends them into the north, east, south, and west positions, Dijkstra's algorithm is used to send 4 cars to these positions in the shortest amount of time. ","category":"page"},{"location":"algos/","page":"Algorithms","title":"Algorithms","text":"With the priority queue using Julia's DataStructure package to improve efficiency, Dijkstra's algorithm runs in O((E + V) log(V)). Additionally, we are only running Dijkstra's for the first 4 cars, so it is not such a huge hit on performance.","category":"page"},{"location":"algos/","page":"Algorithms","title":"Algorithms","text":"This algorithm does not run on its own and is used in addition to the next algorithm discussed that combines all algorithms together (Greedy Lookahead+Dijkstras+Fandown).","category":"page"},{"location":"algos/","page":"Algorithms","title":"Algorithms","text":"(Image: Dijkatra's NESW) Dijkstra's is used to send the first 4 cars to the NESW points","category":"page"},{"location":"algos/#Greedy-LookaheadDijkstraFandown","page":"Algorithms","title":"Greedy Lookahead+Dijkstra+Fandown","text":"","category":"section"},{"location":"algos/","page":"Algorithms","title":"Algorithms","text":"This algorithm is a combination of the greedy lookahead, Dijkstra's, and fandown approach. To begin, the first 4 cars are sent in the north, east, south, and west positions using Dijkstra's. It is not necessary to send the cars all the way to the very ends/boundary of the map during this process so we stop the cars ~85% of the way during their respective Dijkstra's paths. ","category":"page"},{"location":"algos/","page":"Algorithms","title":"Algorithms","text":"Next, the other remaining cars will fandown into a lower position of the map. At this point all cars have properly moved into their new starting positions and are ready to explore using the greedy lookahead approach.","category":"page"},{"location":"algos/","page":"Algorithms","title":"Algorithms","text":"However, we have modified the greedy lookahead approach to also take into account boundaries of sections we want each car to explore. In order to ensure we are increasing coverage as much as possible, we want to discourage cars from exploring areas that other cars are already traversing. In order to do so, we first split the map into 4 sections: upper-right, lower-right, lower-left, and upper-left quadrants. Each of the first 4 cars will be assigned to the above sections respectively in that order, where the section bounds are the halfway mark between the maximum and minimum latitude and the halfway mark between the maximum and minimum longitude. ","category":"page"},{"location":"algos/","page":"Algorithms","title":"Algorithms","text":"(Image: Quandrants) The 4 bounded quadrants that the first 4 cars will explore","category":"page"},{"location":"algos/","page":"Algorithms","title":"Algorithms","text":"For the remaining 4 cars, they will explore sections with slightly different boundaries. The 5th car will explore the upper half of the map (anything above the mid-value latitude), the 6th car will explore the right half of the map (anything above the mid-value longitude), the 7th car will explore the bottom half of the map (anything below the mid-value latitude), and the 8th car will explore the left half of the map (anything below the mid-value longitude). ","category":"page"},{"location":"algos/","page":"Algorithms","title":"Algorithms","text":"Of course, this setup is ideal if we have 8 cars, but if we have less we simply assign the cars to the sections mentioned in the respective order until we run out of cars: upper-right, lower-right, lower-left, upper-left, upper-half, right-half, bottom-half, and finally left-half.","category":"page"},{"location":"algos/","page":"Algorithms","title":"Algorithms","text":"At this point, we have cars in strategic starting positions: 4 near the perimeter (located in the north, east, south, and west) and 4 near the center that are randomly slightly spaced out. The next step is to run greedy lookahead on the cars.","category":"page"},{"location":"algos/","page":"Algorithms","title":"Algorithms","text":"The greedy lookahead works similar to the one mentioned above except that we use BFS with a speed metric instead of a distance metric. Additionally, to ensure that the cars are traversing in their respective sections without crossing bounds, if a street leads a car to a junction that crosses its respective section’s boundary, a discount factor is applied to the perceived distance so that the speed appears to be lower in the BFS tree and that street is less likely to get chosen. Again, we also choose unvisited streets first before visited ones. ","category":"page"},{"location":"algos/","page":"Algorithms","title":"Algorithms","text":"An interesting artifact that results from the greedy lookahead approach is that sometimes duplicate street paths are taken. For example, let’s say there are junctions 1 and 2. With the algorithm, a car might hypothetically have the following path: [1, 2, 1, 2, 4, 5 ,6...]. Obviously, going from 1 to 2 back to 1 to 2 again is wasted time. As a result, once greedy-lookahead is applied, we inspect to see what duplicates exist and we remove them. We then add back time that was wasted from the duplicates and run the greedy lookahead again with the remaining time that is left.","category":"page"},{"location":"algos/","page":"Algorithms","title":"Algorithms","text":"This is the ideal solution that runs in 20 seconds and achieves a score of 1.65-1.8 million. It's no surprise that time is around the same as the previous solutions discussed because time complexity has already been explained in previous sections and no further additions would exceedingly add to this time complexity. Additionally, no other space complexity is added due to the only other significant data structures being added outside of the adjacency matrix were the lookahead trees (BFS trees), which has already been discussed.","category":"page"},{"location":"","page":"Home","title":"Home","text":"CurrentModule = Julia_Hashcode2014","category":"page"},{"location":"#Julia_Hashcode2014","page":"Home","title":"Julia_Hashcode2014","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Documentation for Julia_Hashcode2014.","category":"page"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [Julia_Hashcode2014]","category":"page"},{"location":"#Julia_Hashcode2014.AdjacencyGraph","page":"Home","title":"Julia_Hashcode2014.AdjacencyGraph","text":"AdjacencyGraph\n\nStore a city in the form of an weighted adjacency graph. Weights are based on length. \n\nFields\n\noutneighbors::Vector{Vector{Int}}: junctions\nweights::Vector{Vector{Float64}}: weights based on length for each street.\ntimes::Dict{Tuple{Int,Int},Float64}: the time it takes to travel a street.\n\n\n\n\n\n","category":"type"},{"location":"#Julia_Hashcode2014.TreeNode","page":"Home","title":"Julia_Hashcode2014.TreeNode","text":"TreeNode\n\nStores nodes in a graph. Each node only has 1 parent node. Used for backtracking BFS lookahead trees.\n\nFields\n\nparent::Union{TreeNode, Nothing}: The parent node/junction.\njunction::Int64: The junction index.\ntime_elapsed::Float64: the total time that has elapsed to reach this junction from the start.\ndistance_traveled::Float64: the total distrance traveled to reach this junction from the start.\npath_visited::Set{Tuple{Int64, Int64}}: the (u, v) paths taken to reach this junction from the start.\n\n\n\n\n\n","category":"type"},{"location":"#Julia_Hashcode2014.dijkstra-Tuple{AdjacencyGraph, Any}","page":"Home","title":"Julia_Hashcode2014.dijkstra","text":"dijkstra(g, s)\n\nFinds the shortest path (in terms of time) from the source to all other points in the graph g and the parents list to reconstruct the shortest path. Returns a tuple (shortest_path, parents).\n\nParameters\n\ng: The city as a AdjacencyGraph.\ns: The source junction index.\n\n\n\n\n\n","category":"method"},{"location":"#Julia_Hashcode2014.edge_time-Tuple{AdjacencyGraph, Any, Any}","page":"Home","title":"Julia_Hashcode2014.edge_time","text":"edge_time(g, u, v)\n\nReturns the time it takes to traverse the path (u, v) based on an AdjacencyGraph g.\n\nParameters\n\ng::AdjacencyGraph: The adjacency graph.\nu: a node u.\nv: a node v.\n\n\n\n\n\n","category":"method"},{"location":"#Julia_Hashcode2014.edge_weight-Tuple{AdjacencyGraph, Any, Any}","page":"Home","title":"Julia_Hashcode2014.edge_weight","text":"edge_weight(g, u, v)\n\nReturns the distance that the path (u, v) will traverse based on an AdjacencyGraph g.\n\nParameters\n\ng::AdjacencyGraph: The adjacency graph.\nu: a node u.\nv: a node v.\n\n\n\n\n\n","category":"method"},{"location":"#Julia_Hashcode2014.fandown_greedy","page":"Home","title":"Julia_Hashcode2014.fandown_greedy","text":"fandown_greedy(city, n_lookahead = 15, seq_steps = 7, init_iter = 100, diff_rand = 5)\n\nA greedy algorithm that uses BFS to lookahead from the start node throughout the graph while obeying the time constraints. At the start, has all cars \"fandown\" to reach a more center position in the city. Uses a distance metric to select best itinerary.\n\nTakes around 15 seconds to run (with default parameters) and obtains a score of around 1.35-1.47 million.\n\nParameters\n\ncity: The city (as a City from HashCode2014)\nn_lookahead: The number of BFS levels to lookahead.\nseq_steps: the number of steps to take for each car per round.\ninit_iter: number of iterations to fandown the cars in the beginning\ndiff_rand: probability must taking the same path\n\n\n\n\n\n","category":"function"},{"location":"#Julia_Hashcode2014.find_bound","page":"Home","title":"Julia_Hashcode2014.find_bound","text":"find_bound(city, nb_cars = 8, time = 54000)\n\nFinds the maximum distance bound for a city based on the number of cars and the time constraint. Sorts the streets by speed, and takes turns sending cars down each successive street until the time constraint is met.\n\nParameters\n\ncity::City: the city.\nnb_cars::Int: the number of cars.\ntime::Float64: the time constraint in seconds. \n\n\n\n\n\n","category":"function"},{"location":"#Julia_Hashcode2014.find_nesw-Tuple{HashCode2014.City}","page":"Home","title":"Julia_Hashcode2014.find_nesw","text":"find_nesw(city)\n\nFinds the most north, east, south, and west points of a city by using the min/max latitude and longitude. Returns result as a vector [N, E, S, W] with elements as junction indices.\n\nParameters\n\ncity::City: The city (as a City from HashCode2014)\n\n\n\n\n\n","category":"method"},{"location":"#Julia_Hashcode2014.get_valid_candidates-NTuple{5, Any}","page":"Home","title":"Julia_Hashcode2014.get_valid_candidates","text":"get_valid_candidates(graph, current, candidates, time_elapsed, time_remaining)\n\nReturns a list of valid neighboring junctions from the current junction.  A neighbor is valid if the time it requires to travel there fits within the time requirement.\n\nParameters\n\ngraph::AdjacencyGraph: The AdjacencyGraph representing the city.\ncurrent: the current junction index.\ncandidates: neighboring junctions.\ntime_elapsed: the time elapsed so far.\ntime_remaining: the remaining time for the car to travel.\n\n\n\n\n\n","category":"method"},{"location":"#Julia_Hashcode2014.greedy-Tuple{HashCode2014.City}","page":"Home","title":"Julia_Hashcode2014.greedy","text":"greedy(city)\n\nImplements a greedy algorithm for routing. Cars will take turns going down one street at a time based on the follow criteria:\n\nCheck if the neighboring node has been visited. If not, take the maximum distance path while obeying time constraints.\nIf a neighboring node has been visited, check the next node.\nIf all neighboring nodes have been visited, choose a random path to go down while obeying the time constraint.\n\nTakes around 1-2 seconds to run and obtains a score of around 1.1-1.25 million.\n\nParameters\n\ncity::City: The city (as a City from HashCode2014)\n\n\n\n\n\n","category":"method"},{"location":"#Julia_Hashcode2014.greedy_lookahead","page":"Home","title":"Julia_Hashcode2014.greedy_lookahead","text":"greedy_lookahead(city, n_lookahead, seq_steps)\n\nA greedy algorithm that uses BFS to lookahead from the start node throughout the graph while obeying the time constraints. Uses a distance metric to select best itinerary.\n\nTakes around 20 seconds to run (with default parameters) and obtains a score of around 1.3-1.45 million.\n\nParameters\n\ncity::City: The city (as a City from HashCode2014)\nn_lookahead: The number of BFS levels to lookahead.\nseq_steps: the number of steps to take for each car per round.\n\n\n\n\n\n","category":"function"},{"location":"#Julia_Hashcode2014.greedy_lookahead_dijkstras_fandown","page":"Home","title":"Julia_Hashcode2014.greedy_lookahead_dijkstras_fandown","text":"function greedy_lookahead_dijkstras_fandown(city, n_lookahead = 15, seq_steps = 15)\n\nA greedy algorithm that uses BFS to lookahead from the start node throughout the graph while obeying the time constraints.  Sends 4 cars to the N/E/S/W corners using Dijkstra's and uses fandown for the remaining cars. Uses lookaheadtreebounded as a lookahead algorithm and uses a speed metric to select best itinerary. Removes duplicates and repeats the lookahead algorithm.\n\nTakes around 30 seconds to run (with default parameters) and obtains a score of around 1.65-1.8 million.\n\nParameters\n\ncity::City: The city (as a City from HashCode2014)\nn_lookahead: The number of BFS levels to lookahead.\nseq_steps: the number of steps to take for each car per round.\n\n\n\n\n\n","category":"function"},{"location":"#Julia_Hashcode2014.lookahead_tree-Tuple{AdjacencyGraph, Any, Any, Any, Any}","page":"Home","title":"Julia_Hashcode2014.lookahead_tree","text":"lookahead_tree(graph, start, visited, n, time_remaining)\n\nUses BFS to lookahead from the start node throughout the graph while obeying the time constraints.  Uses a distance metric to select best itinerary. Any paths already traveled are heavily discounted in the metric. Returns a (best distance, best itinerary) tuple. \n\nParameters\n\ngraph::AdjacencyGraph: The AdjacencyGraph representing the city.\nstart: The starting junction index.\nvisited: the (u, v) paths that have already been taken by any cars.\nn: the number of levels to iterate for BFS.\ntime_remaining: the remaining time for the car to travel.\n\n\n\n\n\n","category":"method"},{"location":"#Julia_Hashcode2014.lookahead_tree_bounded-NTuple{10, Any}","page":"Home","title":"Julia_Hashcode2014.lookahead_tree_bounded","text":"lookahead_tree_bounded(graph, start, visited, n, time_remaining, city, lat_min, lat_max, long_min, long_max)\n\nUses BFS to lookahead from the start node throughout the graph while obeying the time constraints.  Uses a speed metric to select best itinerary. Any paths already traveled are heavily discounted in the metric. Any junctions outside the min/max latitude/longitude are also heavily discounted. Returns a (best distance, best itinerary) tuple. \n\nParameters\n\ngraph::AdjacencyGraph: The AdjacencyGraph representing the city.\nstart: The starting junction index.\nvisited: the (u, v) paths that have already been taken by any cars.\nn: the number of levels to iterate for BFS.\ntime_remaining: the remaining time for the car to travel.\ncity: the city.\nlat_min: the minimum latitude.\nlat_max: the maximum latitude.\nlong_min: the minimum longitude.\nlong_max: the maximum longitude.\n\n\n\n\n\n","category":"method"},{"location":"#Julia_Hashcode2014.node_metric-Tuple{TreeNode}","page":"Home","title":"Julia_Hashcode2014.node_metric","text":"node_metric(node)\n\nReturns the metric for the current node. Currently uses distance/time as the metric.\n\nParameters\n\nnode::TreeNode: the node in the BFS lookahead tree.\n\n\n\n\n\n","category":"method"},{"location":"#Julia_Hashcode2014.outneighbors-Tuple{AdjacencyGraph, Any}","page":"Home","title":"Julia_Hashcode2014.outneighbors","text":"outneighbors(g, u)\n\nReturns the outneighbors of node u based on an AdjacencyGraph g.\n\nParameters\n\ng::AdjacencyGraph: The adjacency graph.\nu: a node u.\n\n\n\n\n\n","category":"method"},{"location":"#Julia_Hashcode2014.recalculate_times-Tuple{Any, Any}","page":"Home","title":"Julia_Hashcode2014.recalculate_times","text":"recalculate_times(graph, itineraries)\n\nCalculates the amount of time needed to fulfill the itineraries.\n\nParameters\n\ngraph::AdjacencyGraph: The AdjacencyGraph representing the city.\nitinerary::Vector{Vector{Int64}}: the vector itinerary of a car.\n\n\n\n\n\n","category":"method"},{"location":"#Julia_Hashcode2014.remove_dups-Tuple{Any}","page":"Home","title":"Julia_Hashcode2014.remove_dups","text":"remove_dups(itinerary)\n\nReturns the itinerary after removing duplicates.  Removed duplicates that are in the form [...,1,2,1,2,...] -> [...,1,2,...].\n\nParameters\n\nitinerary::Vector{Int64}: the vector itinerary of a car.\n\n\n\n\n\n","category":"method"},{"location":"#Julia_Hashcode2014.spath-Tuple{Any, Vector{Float64}, Any, Vector{Int64}}","page":"Home","title":"Julia_Hashcode2014.spath","text":"spath(x, dists, source, parents)\n\nReturns the shortest path (in terms of time) from the source to the junction x.\n\nParameters\n\nx: The target junction index.\ndists: The shortest paths in terms of time from dijkstra.\nsource: The source junction index.\nparents: The parents array from dijkstra.\n\n\n\n\n\n","category":"method"}]
}
