#loads the json file and adds new attributes to the board
#returns parsed board
def load_board 
    board_file = 'data/board.json'
    board = JSON.parse(File.read(board_file), object_class: OpenStruct)

    # adding new attributes to the board: property owners and owned conditions( is it owned or not)
    for i in 1..(board.length-1) do
        board[i].owned = false
        board[i].owner = -1
    end

    return board
end

#prompts the user to decide between roll 1 or 2 and then uses that roll file for the game
#returns parsed file
def load_roll 
    puts "---------------------------------------------------------------------------------------------------------------------------".colorize(background: :blue)
    puts "\n \n"
    puts "Hi! Welcome to Woven Monopoly. I have two roll files! Please enter the index of the roll file you'd like to use (1 or 2)"
    rolls = nil
    options = ['Roll 1', 'Roll 2']

    #loops until valid option is selected
    loop do 
        options.each.with_index(1) do |option, index|
            puts "#{index}. #{option}"
        end
        print '> '
        input = gets.chomp.to_i

        if input == 1
            roll_file = 'data/rolls_1.json'
            rolls = JSON.parse(File.read(roll_file))
            puts "Successfully loaded the rolls from #{roll_file}"
            puts "\n"
            break 
        elsif input == 2
            roll_file = 'data/rolls_2.json'
            rolls = JSON.parse(File.read(roll_file))
            puts "Successfully loaded the rolls from #{roll_file} \n"
            puts "\n"
            break
        else 
            puts "You didn't enter a valid option. Please try again!"
        end 
    end
    rolls
end 

#creates the players for the game using the Player class
#this allows more players to be added if needed
def create_players (player_names)
    temp_players = []
    for x in player_names 
        player = Player.new(x)
        temp_players << player
    end 
    return temp_players
end 


