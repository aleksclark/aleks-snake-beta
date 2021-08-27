class Board

  attr_reader :grid, :width, :height, :self_id, :food_locs, :head, :my_len

  # own body: m
  # other snake body: s
  # own head: V
  # other snake head: H
  # food: @
  def initialize(game_info)
    puts game_info
    @width = game_info[:board][:width]
    @height = game_info[:board][:height]
    @self_id = game_info[:you][:id]
    @grid = (0..width - 1).map do |_|
      (0..height - 1).map do |__|
        ' '
      end
    end
    @food_locs = []
    @head = game_info[:you][:head]
    @my_len = game_info[:you][:length]

    add_food(game_info[:board][:food])
    add_snakes(game_info[:board][:snakes])
  end

  def add_food(food)
    food.each do |loc|
      food_locs.push(loc)
      add_loc(loc, '@')
    end
  end

  def add_snakes(snakes)
    snakes.each do |snake|
      char = snake[:id] == self_id ? 'm' : 's'
      snake[:body].each do |loc|
        add_loc(loc, char)
      end

      add_loc(snake[:head], snake[:id] == self_id ? 'V' : 'H')
      add_head_surround(snake[:head]) if snake[:id] != self_id && snake[:length] >= my_len
    end
  end

  def add_head_surround(loc)
    x = loc[:x]
    y = loc[:y]
    potential_locs = [
      [x, y - 1],
      [x, y + 1],
      [x - 1, y],
      [x + 1, y]
    ]

    potential_locs.each do |pot|
      if grid[pot[0]] && grid[pot[0]][pot[1]]
        grid[pot[0]][pot[1]] = 'X' if grid[pot[0]][pot[1]] == ' '
      end
    end
  end

  def add_loc(loc, char)
    grid[loc[:x]][loc[:y]] = char
  end

  def print
    str = "-" * (width + 2) + "\n"
    (height - 1).downto(0).each do |y|
      row = "|"
      (0..(width - 1)).each do |x|
        row << grid[x][y]
      end
      row << "|\n"
      str << row
    end
    str << "-" * (width + 2) + "\n"
    puts str
  end
end


