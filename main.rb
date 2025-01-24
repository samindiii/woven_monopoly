require 'ostruct'
require 'json'
require 'colorize'
require_relative 'lib/player'

#loading the board
board_file = 'data/board.json'
board = JSON.parse(File.read(board_file), object_class: OpenStruct)

# adding new attributes to the board: property owners and owned conditions( is it owned or not)
for i in 1..(board.length-1) do
    board[i].owned = false
    board[i].owner = -1
end

#loading the roll file
roll_file = 'data/rolls_2.json'
rolls = JSON.parse(File.read(roll_file))

#setting up the players
player1 = Player.new("Peter")
player2 = Player.new("Billy")
player3 = Player.new("Charlotte")
player4 = Player.new("Sweedal")

#load the players to an array
players = [player1, player2, player3, player4]


#current player index
i = 0
#current dice roll index
x = 0

# this loop will go through each player, but will stop when the players money reaches 0-- might change this so its not like an infiite loop
# while players[i].money > 0 
while x < 10
    # increment the players position based on the roll. 
    players[i].position += rolls[x]
    
    #what to do if the player's position exceeds the board length? Player is on position 8 but the board is only a length of 5
    #maybe we can find the difference and make that the players new position???

    if players[i].position >= board.length
        difference = players[i].position - board.length 
        players[i].position = difference
    end

    puts players[i].position
    puts players[i].name
    #counts to increment the index and the rolls 
    x += 1
    i += 1 

    #makes sure that there are turns: like go from player1 to 4 and then back to 1...
    if i == 4
        i = 0
    end

end


#to dos

#Changes to Money, Ownership
    #what happens if player lands on GO!: Need to increase their money by $1
    #if the board is not owned? they must buy it!! So reduce their money by the price. Append their properties array? Maybe I can print at the end
    # change the owned == false to true so no one else can buy it!!

    # if the board is owned? We need to pay rent. This money needs to go to the owner of that property (we need a attribute in board called owner)
    # also the current players money needs to reduce by the price (i decided maybe to use the property price as the rent price because its already low)
    #if the money is less than rent? Maybe we can like go bankrupt and say game over bcs technically they dont have money to pay rent! Game over and exit the loop??