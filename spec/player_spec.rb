
require 'spec_helper'
require_relative '../lib/player'

RSpec.describe Player do
  let(:player) { Player.new('test') }

  #does the player class work in the way intended 
  it 'initializes with starting attributes' do
    expect(player.name).to eq('test')
    expect(player.money).to eq(16)
    expect(player.position).to eq(0)
    expect(player.properties).to eq([])
  end

  #can certain atributes, such as position, be updated
  it 'allows attributes to be updated' do
    player.money = 10
    player.position = 5
    player.properties << 'YOMG'

    expect(player.money).to eq(10)
    expect(player.position).to eq(5)
    expect(player.properties).to include('YOMG')
  end
end
