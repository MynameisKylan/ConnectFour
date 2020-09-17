# cell.rb

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
