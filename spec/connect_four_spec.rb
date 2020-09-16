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

    it 'raises an error if the column is full' do
      6.times { board.add_piece(2,'X') }
      expect { board.add_piece(2,'X') }.to raise_error('column already full')
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
  describe '@switch_active_player' do

  end
end