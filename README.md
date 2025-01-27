### WOVEN MONOPOLY (By Sam :)

Thank you for taking the time to test and play my game of woven monopoly!


## Summary 

<details>
<summary>Game Rules</summary>

<ul>
<li>There are four players who take turns</li>
<li>Each player starts with $16</li>
<li>Everybody starts on GO</li>
<li>You get $1 when you pass GO (this excludes your starting move)</li>
<li>If you land on a property, you must buy it</li>
<li>If you land on a property and you cannot afford it, you stay there</li>
<li>If you land on an owned property, you must pay rent to the owner</li>
<li>Rent is calculated by diving property price in half</li>
<li>If the same owner owns all property of the same colour, the rent is doubled</li>
<li>Once someone is bankrupt, whoever has the most money remaining is the winner</li>
<li>The board wraps around (i.e. you get to the last space, the next space is the first space)</li>
</ul>
</details>

<details>
<summary>Game Functionality</summary>
<li>Game starts with a prompt: which dice roll do you want to use? (1 or 2)</li>
<li>The game logs will be printed to show how the game is progressing</li>
<li>After every turn, the user is prompted to either view the current standings or continue game</li>
<li>If they choose to view standings, a table with sorted players will be shown </li>
<li>The game ends when a player has $0 because they bought a property </li>
<li>The game also ends if a player cannot afford rent and becomes bankrupt </li>
<li>At the end of the game, the final standings will be shown to the user </li>
<li>The user will now be prompted to either continue game or exit </li>
<li>If they choose to continue they can choose another roll file to use </li>
<li>Additionally, the user can choose to enter their own custom dice rolls that will be used in a new game</li>
</details>

## Design 
* I wanted this game to allow for user interactivity, which is why the user gets so many options to choose from 
* I used the colorize gem to add backgrounds, bold text and colour to my code so it isn't boring 
* I used emojis through their unicode but it might not work depending on the OS being used (worked well on macOS)

## How to Test this Code
* I have written up rspecs for each ruby file that tests the core functionality 
* These can be run using "bundle exec rspec path/to/file"
* At the time of implementation, all of these specs passed which meant the core functionality works 

## How to run this code
* To run this code, you would obviously need ruby installed on your computer
* My version of ruby is 3.4.1 and the code works perfectly on my macbook!
* It may be necessary to run a bundle install to install any necessary gem files in this code 
* Finally, to run the actual command-line application, simply type in ruby main.rb and you should recieve a welcome message
* If there are any permission issues, please feel free to contact me at any time