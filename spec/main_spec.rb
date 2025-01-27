require 'spec_helper'
require_relative '../main'
require_relative '../lib/game_data'
require_relative '../lib/player'
require 'ostruct'
require 'json'
require 'colorize'

RSpec.describe do
    #loads the attributes to be used
    before do
        @board = load_board
        @rolls =  [5, 5, 6, 2, 1, 5, 1, 2]
        @players = create_players(%w[x y z w]) 

    end

    #does the purchase_property method add property to player, reduce their money 
    #and change the property ownership to player
    describe 'purchase_property' do 
        it 'adds the property to the players property array' do
            allow(STDOUT).to receive(:puts)
            initial_position = @players[0].position
            expect(@players[0].properties).to be_empty
            move_player(@players[0],@board,@rolls[0])
            expect(@players[0].position).to eq(initial_position + @rolls[0])
            purchase_property(@players,@board,i=0)
            expect(@players[0].properties).to include(@board[@players[0].position].name)
        end

        it 'reduces player money by the property price' do
            allow(STDOUT).to receive(:puts)
            inital_money = @players[0].money
            move_player(@players[0],@board,@rolls[0])
            purchase_property(@players,@board,i=0)
            expect(@players[0].money).to eq( inital_money - @board[@players[0].position].price)
        end


        it 'changes the property ownership to the players index' do
            allow(STDOUT).to receive(:puts)
            expect(@board[@players[0].position].owner).to be(nil)
            move_player(@players[0],@board,@rolls[0])
            purchase_property(@players,@board,i=0)
            expect(@board[@players[0].position].owner).to eq(0)

        end
    end

    #does the pay_rent method reduce player money and pay rent to the owner of the space
    describe 'pay_rent' do
        before do 
            allow(STDOUT).to receive(:puts)
            move_player(@players[0],@board,@rolls[0])
            purchase_property(@players,@board,i=0)
        end
       
        it 'reduces player money by the rent price' do 
            allow(STDOUT).to receive(:puts)
            inital_money = @players[1].money
            move_player(@players[1],@board,@rolls[1])
            pay_rent(@players,@board,i=1)
            expect(@players[1].money).to eq( inital_money - @board[@players[1].position].rent)

        end

        it 'pays the rent to the owner of the space' do 
            allow(STDOUT).to receive(:puts)
            move_player(@players[1],@board,@rolls[1])
            pay_rent(@players,@board,i=1)
            #player 0's money was 13 after buying the property. After player 0 
            #paid rent, their money increased back to 16
            expect(@players[0].money).to eq(14.5)
        end

    end
    
    #does the move_player method move the player based on the dice roll? 
    #is it accurate in moving?
    describe 'move_player' do
        it 'moves the player based on the dice roll' do
            initial_position = @players[0].position
            expect(@players[0].position).to eq(0)
            move_player(@players[0],@board,@rolls[0])
            expect(@players[0].position).to eq(initial_position + @rolls[0])

        end
    end   
end