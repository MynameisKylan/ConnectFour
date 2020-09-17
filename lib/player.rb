# player.rb

class Player
  attr_reader :name, :symbol
  def initialize(name, number)
    @name = name
    @symbol = number == 1 ? "\u2460".encode('utf-8') : "\u2461".encode('utf-8')
  end
end