# board.rb

class Board
  attr_reader :grid
  def initialize
    @grid = Array.new(6) { Array.new(7) { Cell.new } }
  end

  def win?(symbol)
    horizontal?(symbol) || vertical?(symbol) || diagonal?(symbol)
  end

  def tie?(p1_symbol, p2_symbol)
    full? unless win?(p1_symbol) || win?(p2_symbol)
  end

  def full?
    @grid.flatten.none?(&:empty?)
  end

  def col_full?(col)
    (0..5).each do |row|
      return false if grid[row][col].empty?
    end
    true
  end

  def add_piece(col, symbol)
    cell = nil
    row = 0
    # find first row in that column with an empty cell
    until cell || row > 5
      cell = grid[row][col] if grid[row][col].empty?
      row += 1
    end

    cell.fill(symbol)
  end

  def display
    grid = @grid.reverse
    grid.each do |row|
      puts row.map { |cell| cell.char == '' ? ' ' : cell.char }.join(' | ')
      puts '-' * 25
    end
  end

  private

  def diagonal?(symbol)
    # check ascending
    (0..2).each do |row|
      (0..3).each do |col|
        return true if \
        grid[row][col].char == symbol && \
        grid[row + 1][col + 1].char == symbol && \
        grid[row + 2][col + 2].char == symbol && \
        grid[row + 3][col + 3].char == symbol
      end
    end
    # check descending
    (3..5).each do |row|
      (0..3).each do |col|
        return true if \
        grid[row][col].char == symbol && \
        grid[row - 1][col + 1].char == symbol && \
        grid[row - 2][col + 2].char == symbol && \
        grid[row - 3][col + 3].char == symbol
      end
    end
    false
  end

  def vertical?(symbol)
    (0...grid[0].length).each do |col|
      count = 0
      (0...grid.length).each do |row|
        if grid[row][col].char == symbol
          count += 1
        else
          count = 0
        end
        return true if count >= 4
      end
    end
    false
  end

  def horizontal?(symbol)
    (0...grid.length).each do |row|
      count = 0
      (0...grid[0].length).each do |col|
        if grid[row][col].char == symbol
          count += 1
        else
          count = 0
        end
        return true if count >= 4
      end
    end
    false
  end
end
