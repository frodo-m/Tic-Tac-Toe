# frozen_string_literal: true

require 'colorize'

# players.rb
class Players
  attr_accessor :symbol1, :symbol2

  def initialize
    symbols = ['X'.colorize(:blue), 'O'.colorize(:red)].shuffle
    @symbol1 = symbols[0]
    @symbol2 = symbols[1]
  end
end
