# frozen_string_literal: true

# 1. Ask user for Human vs Human or Human vs Computer
# 2. Display the board and the assigned symbol for each p
# 3. Score counter for players
# 4. Count rounds
# 5. Start the game
#   a. keep the game running until a win or draw
#   b. display the p positions
#   c. display score board for each p
# 6. Ask for a rematch

# RULES:
#   1. Players can't assing symbols but their own (X or O)
#   2. Players can't re-allocate a position
#   3. Players can't select position out of 1 to 9 range

require_relative 'board'
require_relative 'players'

require 'colorize'

# game.rb
class Game
  attr_reader :player_one_score, :player_two_score

  PATTERNS = [
    [1, 2, 3], [4, 5, 6], [7, 8, 9],
    [1, 4, 7], [2, 5, 8], [3, 6, 9],
    [1, 5, 9], [3, 5, 7]
  ].freeze

  def initialize
    @board = Board.new
    welcome_message
  end

  def welcome_message
    puts "#{'X'.colorize(:blue)} Tic-Tac-Toe #{'O'.colorize(:red)}"
    display_board
    puts <<~WELCOME
      Instruction:
        1. Select mode
        2. Select position between 1 to 9
    WELCOME
    select_mode
  end

  def display_board
    puts @board.display_board
  end

  def select_mode
    puts <<~MODE
      [1] Human vs Human
      [2] Human vs Computer
    MODE
    @mode = gets.chomp.to_i
    @mode == 1 ? human_vs_human : human_vs_computer
  end

  def players
    players = Players.new
    @players_n = [players.player_one_name, players.player_two_name]
    @players_s = [players.player_one_symbol, players.player_two_symbol]
  end

  def human_vs_human
    players
    puts "#{@players_n[0]} is #{@players_s[0]}, #{@players_n[1]} is #{@players_s[1]}"
    game_loop
  end

  def human_vs_computer
    players
    puts "#{@players_n[0]} is #{@players_n[0]}, Computer is #{@players_s[1]}"
    game_loop
  end

  def game_loop
    loop do
      play_game
      break unless rematch?

      reset_board
    end
    puts 'Thanks for playing'
    update_score
  end

  def play_game
    9.times do |round|
      turn = current_turn(round)
      display_board
      promt_user(turn)

      update_game(@players_s[turn])

      break if game_over?(turn)
    end
  end

  def update_game(player_s)
    loop do
      position = gets.chomp.to_i
      if valid_position?(position)
        @board.cells[position - 1] = player_s
        break
      else
        puts 'Invalid position, try again!'
      end
    end
  end

  def current_turn(round)
    round.even? ? 0 : 1
  end

  def promt_user(turn)
    puts "#{@players_n[turn]} turn:"
  end

  def game_over?(turn)
    if win?(@players_s[turn])
      puts "The winner is #{@players_n[turn]}"
      display_board
      update_score
      true
    elsif draw?
      puts 'Draw!'
      true
    end
  end

  def valid_position?(position)
    @board.cells[position - 1].is_a?(Integer) && (1..9).include?(position)
  end

  def win?(player_s)
    PATTERNS.any? do |pattern|
      pattern.all? { |cell| @board.cells[cell - 1] == player_s }
    end
  end

  def draw?
    @board.cells.all? { |cell| cell.is_a?(String) } &&
      !win?(@players_s[0]) && !win?(@players_s[1])
    puts 'Draw!'
  end

  def update_score
    @player_one_score ||= 0
    @player_two_score ||= 0

    if win?(@players_s[0])
      @player_one_score += 1
    elsif win?(@players_s[1])
      @player_two_score += 1
    end
    puts "#{@players_n[0]} score: #{@player_one_score}, #{@players_n[1]} score: #{@player_two_score}"
  end

  def rematch?
    puts 'Do you want a rematch? (y/n):'
    response = gets.chomp.downcase
    response == 'y'
  end

  def reset_board
    @board = Board.new
  end

  def computer_choice(choice)
    choice.any?(@board.cells.is_a?(Integer)).shuffle
  end
end
