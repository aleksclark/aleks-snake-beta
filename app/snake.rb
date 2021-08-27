require_relative './pathfinder'

class Snake
  attr_reader :board
  def initialize(board)
    @board = board
  end

  def move
    selected_loc = nil
    selected_dist = 0

    board.food_locs.each do |loc|
      next_loc, distance = Pathfinder.new(board).next_to(board.head, loc)
      if distance <= selected_dist
        selected_dist = distance
        selected_loc = next_loc
      end
    rescue StandardError => e
      puts "lol #{e.message}"
    end

    if !selected_loc
      while (selected_loc == nil) do
        begin
          x = rand(0..board.width - 1)
          y = rand(0..board.height - 1)
          if board.grid[x][y] == ' '
            selected_loc, _ = Pathfinder.new(board).next_to(board.head, {x: x, y: y})
          end
        rescue StandardError => e
          puts "lol #{e.message}"
        end
      end
    end

    head = board.head
    if head[:x] == selected_loc[:x]
      if head[:y] > selected_loc[:y]
        'down'
      else
        'up'
      end
    else
      if head[:x] > selected_loc[:x]
        'left'
      else
        'right'
      end
    end
  end
end
