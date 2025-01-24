# Load the board

require 'json'
require 'ostruct'

board_file = 'data/board.json'
board = JSON.parse(File.read(board_file), object_class: OpenStruct)

for i in 1..(board.length-1) do
    board[i].owned = false
end



#need to think of a way to display the board 
puts "Woven Monopoly Board:"
puts board

# maybe this can manage the board spaces!
#ideas for later: if you roll a 6, move twice? 