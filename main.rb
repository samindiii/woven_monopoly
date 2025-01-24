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

#try for both one and two
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


def winners(players, board)

    #displaying the winners
    i = 1
    sorted_winners = players.sort! { |a, b| b.money <=> a.money }
    puts "---------------------------------------------------------------------------------------------------------------------------".colorize(background: :blue)
    puts ""
    puts "Game Over".colorize(background: :red)
    puts "\nThanks for playing Woven Monopoly--a game where dice rolls are entirely fixed so you have absolutely no chances of winning through luck.\n \nThe winner of this game is \u{1F3C6}#{sorted_winners[0].name}\u{1F3C6} and the loser of this game is \u{1F61E}#{sorted_winners[3].name}\u{1F61E}!\n \nHere are the final standings: \n ".bold
    
    max_name_length = sorted_winners.map{ |element| element.name.length}.max
    max_money_length = sorted_winners.map{ |element| element.money.to_s.length}.max
    

    puts "Final Standings:".colorize(background: :magenta)
    puts ""
    sorted_winners.each_with_index do |element, index|
        puts " #{index + 1}. #{element.name.ljust(max_name_length)}  ||  Remaining Money:  #{element.money.to_s.rjust(max_money_length)}   ||  Current Space:  #{board[element.position].name}  "
    end
    puts ""
    puts "Properties Owned:".colorize(background: :magenta)
    puts ""
    sorted_winners.each_with_index do |element, index|
        puts " #{index + 1}. #{element.name.ljust(max_name_length)}  :  #{element.properties.join(', ')} "
    end
    puts ""



    puts "---------------------------------------------------------------------------------------------------------------------------".colorize(background: :blue)

end



#current player index
i = 0
#current dice roll index
x = 0

# this loop will go through each player, but will stop when the players money reaches 0
while players[i].money > 0
    # increment the players position based on the roll. 
    players[i].position += rolls[x]
    
    #what to do if the player's position exceeds the board length? Player is on position 8 but the board is only a length of 5
    #maybe we can find the difference and make that the players new position???


    if players[i].position >= board.length
        difference = players[i].position - board.length 
        players[i].position = difference
    end

    #Changes to Player Money, Properties
    #what happens if player lands on GO!: Need to increase their money by $1
    if  board[players[i].position].name == "GO"
        players[i].money += 1
    
    #if the board is not owned? they must buy it!! So reduce their money by the price. Append their properties array? Maybe I can print at the end
    # change the owned == false to true so no one else can buy it!!
    elsif board[players[i].position].owned == false
        if players[i].money >= board[players[i].position].price
            players[i].money -= board[players[i].position].price
            board[players[i].position].owned = true
            players[i].properties << board[players[i].position].name
            board[players[i].position].owner = i
        end

    # if the board is owned? We need to pay rent.. This money needs to go to the owner of that property (we need a attribute in board called owner)
    # also the current players money needs to reduce by the price (i decided maybe to use the property price as the rent price because its already low)
    elsif board[players[i].position].owned == true
        #is their money more than the rent? if it is--do the above??
        if players[i].money >= board[players[i].position].price
            players[i].money -= board[players[i].position].price
            players[board[players[i].position].owner].money += board[players[i].position].price
        else 
        #if the money is less than rent? Maybe we can like go bankrupt and say game over bcs technically they dont have money to pay rent! Game over and exit the loop??
            puts "---------------------------------------------------------------------------------------------------------------------------".colorize(background: :blue)
            puts ""
            puts "Important Message".colorize(background: :red) 
            puts ""
            puts "Hi #{players[i].name}, technically you owe #{players[board[players[i].position].owner].name} another $#{players[i].money.abs}.\nThey are kind enough to end the game without putting you in generational debt. \nThe game is now over! You lost, boo hoo :(".bold
            puts ""
            players[i].money = 0
            winners(players, board)
            exit
        end
    end
    #counts to increment the index and the rolls 
    x += 1
    i += 1 

    #makes sure that there are turns: like go from player1 to 4 and then back to 1...
    if i == 4
        i = 0
    end
end

#calls function
winners(players, board)

#to dos
#move the while statement to functions to increase code readability
#maybe make it so the user types in which roll they want to use? 
#Better annotations-rn its super crowded and hard to read
#print the user properties since we have an array of properties for each user??