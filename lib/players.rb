# frozen_string_literal: true

require 'colorize'

# players.rb
class Players
  attr_reader :player_one_symbol, :player_two_symbol
  attr_accessor :player_one_name, :player_two_name

  def initialize
    name_players
    shuffle_symbols
    @player_one_name = @names[0]
    @player_two_name = @names[1]
    @player_one_symbol = @symbols[0]
    @player_two_symbol = @symbols[1]
  end

  def name_players
    puts 'Player #1 name:'
    name_one = gets.chomp

    puts 'Player #2 name: [If Computer Press Enter]'
    name_two = gets.chomp

    @names = [name_one, name_two]
  end

  private

  def shuffle_symbols
    @symbols = ['X'.colorize(:blue), 'O'.colorize(:red)].shuffle
  end
end
