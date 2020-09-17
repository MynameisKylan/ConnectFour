require 'pry'

class Player
  attr_reader :name, :symbol
  def initialize(name, number)
    @name = name
    @symbol = number == 1 ? "\u2460".encode('utf-8') : "\u2461".encode('utf-8')
  end
end

class Cell
  attr_reader :char
  def initialize
    @char = ''
  end

  def empty?
    @char == ''
  end

  def fill(char)
    raise 'cell already filled' unless empty?

    @char = char
  end
end

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

class Game
  attr_reader :p1, :p2, :board, :active_player
  def initialize
    @p1 = nil
    @p2 = nil
    @board = Board.new
    @active_player = nil
  end

  def initialize_players
    print 'Player 1, what is your name: '
    name = gets.chomp
    @p1 = Player.new(name, 1)

    print 'Player 2, what is your name: '
    name = gets.chomp
    @p2 = Player.new(name, 2)
  end

  def choose_starting_player
    @active_player = [@p1, @p2].sample
  end

  def switch_active_player
    @active_player = @active_player == @p1 ? @p2 : @p1
  end

  def input_move
    print "#{@active_player.name}: choose a column to drop your piece (1-7): "
    move = gets.chomp.to_i - 1
    return move if valid_move?(move)

    if !move.between?(0, 6)
      puts 'Invalid column. Please chooose a number between 1 and 7.'
    else
      puts 'That column is full already, please choose another'
    end
    input_move
  end

  def valid_move?(move)
    return false unless move.between?(0, 6) && !board.col_full?(move)

    true
  end

  def play_turns
    puts "#{@active_player.name} will start!"
    board.display
    until board.win?(p1.symbol) || \
          board.win?(p2.symbol) || \
          board.tie?(p1.symbol, p2.symbol)
      col = input_move
      board.add_piece(col, active_player.symbol)
      board.display
      switch_active_player
    end
  end

  def game_over_message
    puts "#{p1.name} wins!" if board.win?(p1.symbol)
    puts "#{p2.name} wins!" if board.win?(p2.symbol)
    puts "It's a tie!" if board.tie?(p1.symbol, p2.symbol)
  end
end