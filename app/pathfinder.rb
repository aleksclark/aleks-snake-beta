class Pathfinder
  INFINITY = 1 << 64
  attr_reader :board, :nodes, :graph

  def initialize(board, allow_food = false)
    @board = board
    @graph = {}
    @allow_food = allow_food
    board.grid.each_with_index do |col, x|
      col.each_with_index do |_, y|
        if allowed_cell?(x, y)
          @graph["#{x}-#{y}"] = compute_edges(x, y)
        end
      end
    end
    x, y = board.head[:x], board.head[:y]
    @graph["#{x}-#{y}"] = compute_edges(x, y)

    @nodes = graph.keys
  end

  def compute_edges(x, y)
    edges = {}
    potential_locs = [
      [x, y - 1],
      [x, y + 1],
      [x - 1, y],
      [x + 1, y]
    ]
    potential_locs.each do |loc|
      pot_x, pot_y = loc
      edges["#{pot_x}-#{pot_y}"] = 1 if allowed_cell?(pot_x, pot_y)
    end

    edges
  end

  # ripped off from https://gist.github.com/jithinabraham/63d34bdf1c94a01d6e91864d4dc583f4
  def next_to(src, dest)
    src_node = "#{src[:x]}-#{src[:y]}"
    dest_node = "#{dest[:x]}-#{dest[:y]}"
    distance = {}
    previous = {}
    nodes.each do |node| #initialization
      distance[node] = INFINITY # Unknown distance from source to vertex
      previous[node] = -1 # Previous node in optimal path from source
    end

    distance[src_node] = 0 # Distance from source to source

    unvisited_nodes = nodes.compact - [src_node]#All nodes initially in Q (unvisited nodes)

    current_node = src_node

    while (unvisited_nodes.size > 0)

      graph[current_node].keys.each do |neighbor_node|
        if unvisited_nodes.include?(neighbor_node)
          through_dist = distance[current_node] + graph[current_node][neighbor_node]
          if through_dist < distance[neighbor_node]
            distance[neighbor_node] = through_dist
            previous[neighbor_node] = current_node
          end
        end
      end

      unvisited_nodes = unvisited_nodes - [current_node]

      selected_distance = INFINITY
      unvisited_nodes.each do |node|
        if distance[node] <= selected_distance
          current_node = node
          selected_distance = distance[node]
        end
      end
      break if current_node == dest_node
    end

    final_distance = distance[dest_node]
    if final_distance == INFINITY
      raise 'No path!'
    end
    path = [dest_node]
    current_node = dest_node

    while current_node != src_node
      path << current_node
      current_node = previous[current_node]
    end
    next_move = {
      x: path[-1].split('-')[0].to_i,
      y: path[-1].split('-')[1].to_i
    }

    return next_move, distance[dest_node]
  end

  def allowed_cell?(x, y)
    return false if x < 0 || x >= board.width
    return false if y < 0 || y >= board.height
    cell = board.grid[x][y]
    cell == ' ' || cell == '@'
  end


end
