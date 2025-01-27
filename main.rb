require 'ostruct'
require 'json'
require 'colorize'
require_relative 'lib/player'
require_relative 'lib/game_data.rb'

#global variables
$colours = [['Brown',0], ['Red',0],['Green',0],['Blue',0]]

#method for getting user input based on certain options
def user_input(options)
    options.each.with_index(1) do |option, index|
        puts "#{index}. #{option}"
    end
    print '> '
    input = gets.chomp.to_i
    return input
end

#prints the sorted table at the end of each turn and at the end of the game
def print_standings(players,board)
    standings = players.sort { |a, b| b.money <=> a.money }
    max_name_length = standings.map{ |element| element.name.length}.max
    max_money_length = standings.map{ |element| element.money.to_s.length}.max

    puts ""
    standings.each_with_index do |element, index|
        puts " #{index + 1}. #{element.name.ljust(max_name_length)}  ||  Remaining Money:  #{element.money.to_s.rjust(max_money_length)}   ||  Current Space:  #{board[element.position].name}"
    end
end

#this is called at the end of every turn 
def end_turn (players,board,turn)
    puts " \nTurn #{turn} is over!\n"
    options = ["View Standings", "Continue Game"]

    #prompts the user to either view the current winner or continue game
    puts "Would you like to view the current standings or continue the game? "

    #loops until valid option is selected
    loop do 
        input = user_input(options)
        if input == 1
            puts ""
            puts "Current Standings:".colorize(background: :magenta)
            print_standings(players,board)
            puts "\nPress enter to continue the game.. "
            gets
            break
        elsif input == 2
            break
        else 
            puts "You didn't enter a valid option. Please try again!"
        end 
    end
end
 
#sorts the players based on current money and displays the final standings
def winners(players, board)

    #displaying the winners
    i = 1
    puts "---------------------------------------------------------------------------------------------------------------------------".colorize(background: :blue)
    puts ""
    puts "Game Over".colorize(background: :red)
    sorted_winners = players.sort { |a, b| b.money <=> a.money }
    max_name_length = sorted_winners.map{ |element| element.name.length}.max
    puts "\nThanks for playing Woven Monopoly--a game where dice rolls are entirely fixed so you have absolutely no chances of winning through luck.\n \nThe winner of this game is \u{1F3C6}#{sorted_winners[0].name}\u{1F3C6} and the loser of this game is \u{1F61E}#{sorted_winners[3].name}\u{1F61E}!\n \nHere are the final standings: \n ".bold
    puts ""
    puts "Final Standings:".colorize(background: :magenta)
    print_standings(players,board)
    puts ""
    puts "Properties Owned:".colorize(background: :magenta)
    puts ""
    sorted_winners.each_with_index do |element, index|
        puts " #{index + 1}. #{element.name.ljust(max_name_length)}  :  #{element.properties.join(', ')} "
    end
    puts ""
    puts "---------------------------------------------------------------------------------------------------------------------------".colorize(background: :blue)

end

#this is called if a player lands on an owned property
def pay_rent(players,board,i)
    colour_count = 0 

    case board[players[i].position].colour

    when "Brown"
        colour_count = $colours[0][1]
    
    when "Red"
        colour_count = $colours[1][1]

    when "Green"
        colour_count = $colours[2][1]
    
    when "Blue"
        colour_count = $colours[3][1]
    end


    #if player can afford rent, he should pay rent to the owner of the space (this owner's money increases by price)
    #rent is doubled if the colour_count == 2
    if players[i].money >= board[players[i].position].rent
        if colour_count == 2
            puts "#{board[players[i].position].name} is owned by #{players[board[players[i].position].owner].name} so #{players[i].name} has to pay $#{ board[players[i].position].price} rent to #{players[board[players[i].position].owner].name}"
            players[i].money -= board[players[i].position].price #rent is now the same as property price as it is doubled!
            players[board[players[i].position].owner].money += board[players[i].position].price
        else 
            puts "#{board[players[i].position].name} is owned by #{players[board[players[i].position].owner].name} so #{players[i].name} has to pay $#{ board[players[i].position].rent} rent to #{players[board[players[i].position].owner].name}"
            players[i].money -= board[players[i].position].rent
            players[board[players[i].position].owner].money += board[players[i].position].rent
        end

    #if they cannot afford it, player goes bankrupt and game is over
    else 
        puts "#{players[i].name} landed on #{board[players[i].position].name} but cannot afford the rent! This means they are bankrupt"
        puts "---------------------------------------------------------------------------------------------------------------------------".colorize(background: :blue)
        puts ""
        puts "Important Message".colorize(background: :red) 
        puts ""
        puts "Hi #{players[i].name}, technically you owe #{players[board[players[i].position].owner].name} another $#{players[i].money.abs}.\nThey are kind enough to end the game without putting you in generational debt. \nThe game is now over! You lost, boo hoo :(".bold
        puts ""
        players[i].money = 0
    end
end

#this is called if the player landed on an unowned property 
def purchase_property(players,board,i)
    #If they can afford it: the players money reduces by property price, the property is now owned by the player
    if players[i].money >= board[players[i].position].price 
        puts "#{players[i].name} purchased #{board[players[i].position].name} for $#{ board[players[i].position].price}"
        players[i].money -= board[players[i].position].price
        board[players[i].position].owned = true
        players[i].properties << board[players[i].position].name
        board[players[i].position].owner = i

        #updating colours array
        case board[players[i].position].colour

        when "Brown"
            $colours[0][1] += 1
        
        when "Red"
            $colours[1][1] += 1

        when "Green"
            $colours[2][1] += 1
        
        when "Blue"
            $colours[3][1] += 1
        end
    
    #if they cannot afford it: a game log is printed and the player stays there
    elsif players[i].money < board[players[i].position].price
        puts "#{players[i].name} cannot afford #{board[players[i].position].name}"
    end
end

#moves the player based on dice rolls and resets position if it exceeds the board length.
def move_player(player,board,roll)
    player.position += roll

    #The difference between board length and player position is the players new position  
    if player.position >= board.length
        difference = player.position - board.length 
        player.position = difference
    end
end

# manages player movement, property purchases and rent
# and has a counter(i) that resets back to 0 when it reaches 4 to mark a turn
def start_game(players, board, rolls)

    i = 0
    x = 0
    turn = 1
    puts ""
    puts "Starting turn 1..."

    #ends the game if the player has $0
    while players[i].money > 0

        #moves the player based on the current roll
        move_player(players[i],board,rolls[x])
        puts "#{players[i].name} rolled a #{rolls[x]} and landed on #{board[players[i].position].name} "

        #player recieves $1 for landing on GO
        if  board[players[i].position].name == "GO"
            players[i].money += 1
            puts "#{players[i].name} recieved a $1 for landing on GO!"
        
        #player has to purchase property if it is not owned 
        #break condition if the player pays for the property and has $0 left
        elsif board[players[i].position].owned == false
            purchase_property(players,board,i)
            if players[i].money <= 0
                players[i].money = 0
                break 
            end
        
        #player has to pay rent if property is owned 
        #conditional AND statement to ensure player does not pay rent to himself
        elsif board[players[i].position].owned == true && board[players[i].position].owner != i
            pay_rent(players,board,i)
            if players[i].money <= 0
                players[i].money = 0
                break 
            end
        end

        x += 1
        i += 1 

        #this is mainly for custom rolls 
        #if the user only enters 4 nums and the game requires more
        #the rolls will iterate over and over again to continue the game until win condition is met
        if x == rolls.length 
            x = 0
        end

        #turn logic 
        #if the i counter == 4 the turn is over
        #this is because there are only 4 players 
        if i == 4
            end_turn(players,board,turn)
            i = 0
            turn +=1
            puts ""
            puts "Starting Turn #{turn}..."
        end
    end
end


# Starts Woven Monopoly, prints standings when a player reaches $0,
# and lets the user decide to play another game(using roll files or custom) or exit.
def main
    #rolls are defined here because i implemented the functionality of custom rolls
    rolls = load_roll 
    while true
        #load the board
        board = load_board
        for x in $colours
            x[1]= 0
        end

        #load players
        player_names = ["Peter","Billy","Charlotte","Sweedal"]
        players = create_players(player_names) 

        puts "The game data has been loaded! Press any key to start the amazing game of Woven Monopoly \n"
        gets
        puts "Printing Game Logs..."

        #start game
        start_game(players, board, rolls)


        #output winners
        puts "The game has finished as a player has reached $0. Press enter to view the final standings..."
        gets 
        winners(players, board)

        #prompt user to play another game
        puts "\n Would you like to play another game or exit?"
        options = ["Another Game","Another game with custom rolls", "Exit"]
        input = user_input(options)

        #loop until the user picks a valid option
        loop do
            if input == 1
                puts "Let me load you into another game..."
                rolls = load_roll
                break
            elsif input == 2
                puts "You love this game, don't you?!\nI'll let you enter any amount of rolls and we'll play the game using those dice rolls :)"
                rolls = []

                #loads custom rolls into an array and uses those for a new game
                while true
                    print "Please enter your dice rolls(remember 1-6)! Type in 'done' when you're ready: "
                    new_rolls = gets.chomp  
                    break if new_rolls.downcase == "done" 
                    if new_rolls.to_i.to_s == new_rolls && new_rolls.to_i.between?(1, 6)
                        rolls.push(new_rolls.to_i)  
                    else
                        puts "Sorry, I can't add that:( Please enter a number between 1-6!!"
                    end
                end
                puts "You've entered the following dice rolls #{rolls}"
                puts "Let me load you into another game!!!" 
                break
            elsif input == 3
                puts "Thank you so much for playing my game!!"
                exit
            else 
                puts "That input was not valid"
            end
        end
    end
end
    
#had to do this so specs don't wait for the input prompts
if __FILE__ == $0
    main 
end

