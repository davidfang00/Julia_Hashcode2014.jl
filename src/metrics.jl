"""
    node_metric(node)
Returns the metric for the current node. Currently uses distance/time as the metric.
# Parameters
- `node::TreeNode`: the node in the BFS lookahead tree.
"""
function node_metric(node::TreeNode)
    m = node.distance_traveled / (node.time_elapsed)
    return m
end
