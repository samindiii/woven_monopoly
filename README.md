### WOVEN MONOPOLY (By Sam :)

Thank you for taking the time to test and play my game of woven monopoly!

### Game rules
* There are four players who take turns in the following order:
  * Peter
  * Billy
  * Charlotte
  * Sweedal
* Each player starts with $16
* Everybody starts on GO
* You get $1 when you pass GO (this excludes your starting move)
* If you land on a property, you must buy it
* If you land on a property and you cannot afford it, you stay there
* If you land on an owned property, you must pay rent to the owner
* Rent is calculated by diving property price in half
* If the same owner owns all property of the same colour, the rent is doubled
* Once someone is bankrupt, whoever has the most money remaining is the winner
* The board wraps around (i.e. you get to the last space, the next space is the first space)

###  Game Functionality
* Game starts with a prompt: which dice roll do you want to use? (1 or 2)
* The game logs will be printed to show 
* After every turn, the user is prompted to either view the current standings or continue game
* If they choose to view standings, a table with sorted players will be shown 
* The game ends when a player has $0 because they bought a property 
* The game also ends if a player cannot afford rent and becomes bankrupt 
* At the end of the game, the final standings will be shown to the user 
* The user will now be prompted to either continue game or exit 
* If they choose to continue they can choose another roll file to use 
* Additionally, the user can choose to enter their own custom dice rolls that will be used in a new game


### How to Test this Code

* I have written up rspecs for each ruby file that tests the core functionality 
* These can be run using "bundle exec rspec path/to/file"
* At the time of implementation, all of these specs passed which meant the core functionality works 


## How to run this code

* To run this code, you would obviously need ruby installed on your computer
* My version of ruby is 3.4.1 and the code works perfectly on my macbook!
* It may be necessary to run a bundle install to install any necessary gem files in this code 
* Finally, to run the actual command-line application, simply type in ruby main.rb and you should recieve a welcome message
* If there are any permission issues, please feel free to contact me at any time