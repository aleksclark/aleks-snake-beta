require_relative './board'
require_relative './snake'

# TODO: Use the information in board to decide your next move.
def move(game_info)
  board = Board.new(game_info)
  board.print
  snake = Snake.new(board)
  move = snake.move

  puts "MOVE: " + move
  { "move": move }
end
