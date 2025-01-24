# Load the board

require 'json'
require 'ostruct'

board_file = 'data/board.json'
board = JSON.parse(File.read(board_file), object_class: OpenStruct)

#need to think of a way to display the board 
puts "Woven Monopoly Board:"
puts board

# maybe this can manage the board spaces!