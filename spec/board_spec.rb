# board_spec.rb

require './lib/board'

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