function node_metric(node::TreeNode)
    m = node.distance_traveled / (node.time_elapsed)
    return m
end
