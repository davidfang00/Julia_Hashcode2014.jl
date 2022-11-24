"""
    TreeNode
Stores nodes in a graph. Each node only has 1 parent node. Used for backtracking BFS lookahead trees.
# Fields
- `parent::Union{TreeNode, Nothing}`: The parent node/junction.
- `junction::Int64`: The junction index.
- `time_elapsed::Float64`: the total time that has elapsed to reach this junction from the start.
- `distance_traveled::Float64`: the total distrance traveled to reach this junction from the start.
- `path_visited::Set{Tuple{Int64, Int64}}`: the (u, v) paths taken to reach this junction from the start.
"""
Base.@kwdef struct TreeNode
    parent::Union{TreeNode,Nothing}
    junction::Int64
    time_elapsed::Float64
    distance_traveled::Float64
    path_visited::Set{Tuple{Int64,Int64}}
end
