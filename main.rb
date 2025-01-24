# will contain the main method that calls the other objects

#for each dice roll, add the position of the player until it reaches 10. 

require 'json'
require_relative 'lib/player'


require 'ostruct'

board_file = 'data/board.json'
board = JSON.parse(File.read(board_file), object_class: OpenStruct)

for i in 1..(board.length-1) do
    board[i].owned = false
    board[i].owner = null
end


roll_file = 'data/rolls_1.json'
rolls = JSON.parse(File.read(roll_file))

#setting up the players
player1 = Player.new("Peter")
player2 = Player.new("Billy")
player3 = Player.new("Charlotte")
player4 = Player.new("Swedal")
   
players = [player1, player2, player3, player4]

i = 0
x = 0
while players[i].money > 0
    players[i].position += rolls[x]

    if players[i].position >= board.length
        difference = players[i].position - board.length 
        players[i].position = difference
    end

    if board[player[i].position].owned == false
        if player[i]money >= board[player[i].position].price
            player[i].money -= board[player[i].price]
            board[player[i].position].owned = true
            player[i].properties << board[player[i].position].name
            board[player[i].position].owner = i
        end

    else 
    #for each property in the current position, reduce money from player based on price
    #if property owned = false and we have money then reduce from player 

    # players[i].money -= 5
    puts players[i].position
    puts players[i].name

    #loops the players
    x += 1
    i += 1 
    if i == 4
        i = 0
    end
end





