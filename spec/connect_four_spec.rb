# connect_four_spec.rb
require './lib/connect_four'

describe Cell do
  let(:cell) { Cell.new }
  describe '#empty?' do
    it 'returns true if @char is empty string' do
      expect(cell.empty?).to eql(true)
    end

    it 'returns false if @char is not empty' do
      cell.fill('X')
      expect(cell.empty?).to eql(false)
    end
  end

  describe '#fill' do
    it 'sets @char if cell is empty' do
      cell.fill('X')
      expect(cell.char).to eql('X')
    end

    it 'raises an error if the cell isn\'t empty' do
      cell.fill('X')
      expect {cell.fill('O')}.to raise_error('cell already filled')
    end
  end
end

describe Board do

  # empty board to be created for each test
  let(:board) { Board.new }

  describe '#full?' do
    it 'returns true if every space in grid is non-empty' do
      b = Board.new
      6.times do |_|
        7.times { |i| b.add_piece(i, 'X') }
      end
      expect(b.full?).to eql(true)
    end

    it 'returns false if at least one space is empty' do
      expect(board.full?).to eql(false)
    end
  end

  describe '#add_piece' do
    it 'adds a piece to bottom of empty column' do
      board.add_piece(2, 'O')
      expect(board.grid[0][2].char).to eql('O')
    end

    it 'stacks onto existing pieces in a column' do
      board.add_piece(2, 'O')
      board.add_piece(2, 'X')
      expect(board.grid[1][2].char).to eql('X')
    end
  end

  describe '#col_full?' do
    context 'column is open' do
      it 'returns false when column has free space' do
        5.times { board.add_piece(2, 'X') }
        expect(board.col_full?(2)).to eql(false)
      end
    end

    context 'column is full' do
      it 'returns true when column is full' do
        6.times { board.add_piece(2, 'X') }
        expect(board.col_full?(2)).to eql(true)
      end
    end
  end

  describe '#win?' do
    it 'returns true if 4 same pieces in horizontal' do
      4.times { |i| board.add_piece(i, 'O') }
      expect(board.win?('O')).to eql(true)
    end

    it 'returns true if 4 same pieces in a vertical' do
      4.times { board.add_piece(2, 'O') }
      expect(board.win?('O')).to eql(true)
    end

    it 'returns true if 4 same pieces in ascending diagonal' do
      (1..3).each { |i| i.times { board.add_piece(i, 'X') } }
      (0..3).each { |i| board.add_piece(i, 'O') }
      expect(board.win?('O')).to eql(true)
    end

    it 'returns true if 4 same pieces in descending diagonal' do
      (0..3).each { |i| (3-i).times { board.add_piece(i, 'X') } }
      (0..3).each { |i| board.add_piece(i, 'O') }
      expect(board.win?('O')).to eql(true)
    end

    it 'returns false if 3 or less in a row' do
      3.times { board.add_piece(2, 'X') }
      expect(board.win?('X')).to eql(false)
    end

    it 'returns false if 4 in a row are different pieces' do
      2.times { board.add_piece(2, 'X') }
      2.times { board.add_piece(2, 'O') }
      expect(board.win?('O')).to eql(false)
    end
  end

  describe '#tie?' do
    it 'returns true if the board is full and no win is identified' do
      6.times do |row|
        7.times do |col|
          board.add_piece(col, 'X')
        end
      end
      expect(board.tie?('Y','Z')).to eql(true)
    end
  end
end

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
