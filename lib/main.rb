# driver script for starting connect four game

require './lib/cell'
require './lib/player'
require './lib/game'
require './lib/board'

def new_game
  game = Game.new
  game.initialize_players
  game.choose_starting_player
  game.play_turns
  game.game_over_message
  prompt_play_again
end

def prompt_play_again
  answer = 'nil'
  until answer.downcase == 'y' || answer.downcase == 'n'
    print 'Would you like to play again? (y/n): '
    answer = gets.chomp 
  end
  if answer == 'y'
    new_game
  else
    puts 'Game over'
  end
end

new_game