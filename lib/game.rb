# frozen_string_literal: true

require_relative 'board'
require_relative 'players'

require 'colorize'

# game.rb
class Game
  attr_reader :player1_score, :player2_score

  PATTERNS = [
    [1, 2, 3], [4, 5, 6], [7, 8, 9],
    [1, 4, 7], [2, 5, 8], [3, 6, 9],
    [1, 5, 9], [3, 5, 7]
  ].freeze

  def initialize
    @board = Board.new
    @players = Players.new
    @players_symbols = [@players.symbol1, @players.symbol2]
    @current_player_index = 0
    @player1_score = 0
    @player2_score = 0

    puts <<~MODE
      Select game mode:
      [1] Human vs Human
      [2] Human vs Computer
    MODE
    @mode = gets.chomp.to_i
    start_game
  end

  def start_game
    display_board
    @mode == 1 ? human_vs_human : human_vs_computer
  end

  def human_vs_human
    puts "Player 1 is #{@players.symbol1} | Players 2 is #{@players.symbol2}"
    game_loop
  end

  # def human_vs_computer
  #   puts "Player is #{@players.symbol1} | Computer is #{@players.symbol2}"
  # end

  def game_loop
    while !winner?(@players_symbols[0]) && !draw?
      current_player_symbol = @players_symbols[@current_player_index]
      puts "Player #{current_player_symbol}'s turn!"

      move = gets.chomp.to_i

      if valid_move?(move)
        update(move, current_player_symbol)
        display_board

        if winner?(current_player_symbol)
          puts "Player #{current_player_symbol} wins!"
          update_score(current_player_symbol)
          break
        end

        @current_player_index = (@current_player_index + 1) % 2
      else
        puts 'INVALID INPUT! Try Again'.colorize(:red)
      end
      puts 'Tie!'.colorize(:yellow) if draw?
    end
    # puts "Scores: Player 1: #{@player1_score}, Player 2: #{@player2_score}"
  end

  def update(position, player_symbol)
    @board.cells[position - 1] = player_symbol
  end

  def valid_move?(position)
    (1..9).include?(position) && @board.cells[position - 1].is_a?(Integer)
  end

  def winner?(player_symbol)
    PATTERNS.any? do |pattern|
      pattern.all? { |cell| @board.cells[cell - 1] == player_symbol }
    end
  end

  def draw?
    @board.cells.all? { |cell| cell.is_a?(String) } && !winner?(@players_symbols[0]) && !winner?(@players_symbols[1])
  end

  def display_board
    puts @board.display_board
  end

  def update_score(winner_symbol)
    if winner_symbol == @players.symbol1
      @player1_score += 1
    else
      @player2_score += 1
    end
  end
end
