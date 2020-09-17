# game_spec.rb
require './lib/game'
require './lib/player'

describe Game do

  let(:game) { Game.new }
  let(:player1) { Player.new('player', 1) }
  let(:player2) { Player.new('player', 2) }

  before do
    game.instance_variable_set(:@p1, player1)
    game.instance_variable_set(:@p2, player2)
  end

  describe '#switch_active_player' do
    it 'switches the active player' do
      game.instance_variable_set(:@active_player, player1)
      game.switch_active_player
      expect(game.active_player).to eql(player2)
    end
  end

  describe '#initialize_players' do
    it 'creates new players' do
      allow(game).to receive(:gets).and_return('dummy_name')
      game.initialize_players
      expect(game.p1.name).to eql('dummy_name')
      expect(game.p1.symbol).to eql("\u2460".encode('utf-8'))
      expect(game.p2.name).to eql('dummy_name')
      expect(game.p2.symbol).to eql("\u2461".encode('utf-8'))
    end
  end

  describe '#valid_move?' do
    it 'returns true if move is valid' do
      allow(game.board).to receive(:col_full?).and_return(false)
      expect(game.valid_move?(2)).to eql(true)
    end

    it 'returns false if move is out of range (1-7)' do
      expect(game.valid_move?(-1)).to eql(false)
      expect(game.valid_move?(12)).to eql(false)
    end

    it 'returns false if target column is full' do
      allow(game.board).to receive(:col_full?).and_return(true)
      expect(game.valid_move?(2)).to eql(false)
    end
  end

  describe '#input_move' do
    it 'returns the column to add the piece if move is valid' do
      game.instance_variable_set(:@active_player, player1)
      allow(game).to receive(:gets).and_return('3')
      expect(game.input_move).to eql(2)
    end
  end
end
