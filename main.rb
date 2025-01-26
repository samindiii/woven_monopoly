require 'ostruct'
require 'json'
require 'colorize'
require_relative 'lib/player'
require_relative 'lib/game_data.rb'

def user_input(options)
    options.each.with_index(1) do |option, index|
        puts "#{index}. #{option}"
    end
    print '> '
    input = gets.chomp.to_i
    return input
end

def print_standings(players,board)
    standings = players.sort { |a, b| b.money <=> a.money }
    max_name_length = standings.map{ |element| element.name.length}.max
    max_money_length = standings.map{ |element| element.money.to_s.length}.max

    puts ""
    standings.each_with_index do |element, index|
        puts " #{index + 1}. #{element.name.ljust(max_name_length)}  ||  Remaining Money:  #{element.money.to_s.rjust(max_money_length)}   ||  Current Space:  #{board[element.position].name}"
    end
end


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

def start_game(players, board, rolls)

    i = 0
    x = 0
    turn = 1
    puts ""
    puts "Starting turn 1..."

    while players[i].money > 0
     
        players[i].position += rolls[x]
        
        if players[i].position >= board.length
            difference = players[i].position - board.length 
            players[i].position = difference
        end

        puts "#{players[i].name} rolled a #{rolls[x]} and landed on #{board[players[i].position].name} "

        if  board[players[i].position].name == "GO"
            players[i].money += 1
            puts "#{players[i].name} recieved a $1 for landing on GO!"
        
        elsif board[players[i].position].owned == false
            if players[i].money >= board[players[i].position].price 
                puts "#{players[i].name} purchased #{board[players[i].position].name} for $#{ board[players[i].position].price}"
                players[i].money -= board[players[i].position].price
                board[players[i].position].owned = true
                players[i].properties << board[players[i].position].name
                board[players[i].position].owner = i
                break if players[i].money == 0
            elsif players[i].money < board[players[i].position].price
                puts "#{players[i].name} cannot afford #{board[players[i].position].name}"
            end

        elsif board[players[i].position].owned == true && board[players[i].position].owner != i

            if players[i].money >= board[players[i].position].price
                puts "#{board[players[i].position].name} is owned by #{players[board[players[i].position].owner].name} so #{players[i].name} has to pay $#{ board[players[i].position].price} rent to #{players[board[players[i].position].owner].name}"
                players[i].money -= board[players[i].position].price
                players[board[players[i].position].owner].money += board[players[i].position].price
                break if players[i].money == 0
            else 
                puts "#{players[i].name} landed on #{board[players[i].position].name} but cannot afford the rent! This means they are bankrupt"
                puts "---------------------------------------------------------------------------------------------------------------------------".colorize(background: :blue)
                puts ""
                puts "Important Message".colorize(background: :red) 
                puts ""
                puts "Hi #{players[i].name}, technically you owe #{players[board[players[i].position].owner].name} another $#{players[i].money.abs}.\nThey are kind enough to end the game without putting you in generational debt. \nThe game is now over! You lost, boo hoo :(".bold
                puts ""
                players[i].money = 0
                break
                
            end
        end

        x += 1
        i += 1 

        if x == rolls.length - 1
            x = 0
        end

        #after every turn, print the standings
        if i == 4
            puts " \nTurn #{turn} is over!\n"
            options = ["View Standings", "Continue Game"]
            puts "Would you like to view the current standings or continue the game? "
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

            i = 0
            turn +=1
            puts ""
            puts "Starting Turn #{turn}..."
        end
    
    end
end


rolls = load_roll 
while true

    board = load_board

    #load players
    player_names = ["Peter","Billy","Charlotte","Sweedal"]
    players = create_players(player_names) 

    puts "The game data has been loaded! Press any key to start the amazing game of Woven Monopoly \n"
    gets
    puts "Printing Game Logs..."

    start_game(players, board, rolls)
    puts "The game has finished as a player has reached $0. Press enter to view the final standings..."
    gets 
    winners(players, board)
    puts "\n Would you like to play another game or exit?"
    options = ["Another Game","Another game with custom rolls", "Exit"]
    input = user_input(options)
    loop do
        if input == 1
            puts "Let me load you into another game..."
            rolls = load_roll
            break
        elsif input == 2
            puts "You're super curious about this game, arent you!\nI'll let you enter any amount of rolls and we'll play the game using those dice rolls :)"
            rolls = []
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
    


