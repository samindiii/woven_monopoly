require 'spec_helper'
require_relative '../lib/game_data'
require_relative '../lib/player.rb'
require 'ostruct'
require 'json'
require 'colorize'

RSpec.describe do
    describe 'load_board' do
        it 'loads the board correctly' do
            board = load_board
            expect(board).to be_an(Array)
            expect(board.first.name).to eq('GO')
            expect(board.first.type).to eq('go')
        end
    end

    describe 'create_players' do
        it 'creates players correctly' do
            players = create_players(%w[x y z w])
            expect(players.size).to eq(4)
            expect(players[1]).to be_a(Player)
            expect(players[0].name).to eq('x')
        end
    end
    
    describe 'load_roll' do
        it 'recieves valid input and loads roll file 1' do
            allow($stdin).to receive(:gets).and_return("1\n")
            expect { puts "Successfully loaded the rolls from data/rolls_1.json" }.to output.to_stdout
        end 

        it 'recieves valid input and loads roll file 2' do
            allow($stdin).to receive(:gets).and_return("2\n")
            expect { puts "Successfully loaded the rolls from data/rolls_2.json" }.to output.to_stdout
        end 

        it 'recieves invalid input and outputs an error' do
            allow($stdin).to receive(:gets).and_return("1\n")
            expect { puts "You didn't enter a valid option. Please try again!" }.to output.to_stdout
        end 

    end
end
