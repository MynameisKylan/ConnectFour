# game.rb

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