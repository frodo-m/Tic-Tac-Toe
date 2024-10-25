# frozen_string_literal: true

require_relative 'board'
require_relative 'players'
require 'colorize'

# game.rb
class Game
  LINES = [
    [1, 2, 3], [4, 5, 6], [7, 8, 9],
    [1, 4, 7], [2, 5, 8], [3, 6, 9],
    [1, 5, 9], [3, 5, 7]
  ].freeze

  def initialize
    @board = Board.new
    @player_one_score = 0
    @player_two_score = 0
    welcome_message
  end

  def welcome_message
    puts 'Tic Tac Toe'.colorize(:magenta)
    display_board
    puts <<~MODE
      #{'Select mode:'.colorize(:light_yellow)}
      #{'[1] Human vs Human'.colorize(:light_red)}
      #{'[2] Human vs Computer'.colorize(:blue)}
    MODE
    mode = gets.chomp.to_i
    select_mode(mode)
  end

  def select_mode(mode)
    mode == 1 ? human_vs_human : human_vs_computer
  end

  def players
    players = Players.new
    @player_names = [players.player_one_name, players.player_two_name]
    @player_symbols = [players.player_one_symbol, players.player_two_symbol]
  end

  def human_vs_human
    players
    puts "#{@player_names[0]} is #{@player_symbols[0]} & #{@player_names[1]} is #{@player_symbols[1]}"
    game_loop
  end

  def human_vs_computer
    players
    puts "#{@player_names[0]} is #{@player_symbols[0]} & #{@player_names[1] = 'Computer'} is #{@player_symbols[1]}"
    game_loop
  end

  def game_loop
    loop do
      play_rounds
      break unless rematch?

      reset_board
    end
    puts 'Hope you had fun!'.colorize(:light_green)
  end

  def play_rounds
    9.times do |round|
      turn = current_turn(round)
      display_board

      if computer_turn?(turn)
        computer_move
      else
        human_move(turn)
      end

      break if game_over?(turn)
    end
  end

  def computer_turn?(turn)
    @player_names[turn] == 'Computer'
  end

  def current_turn(round)
    round.even? ? 0 : 1
  end

  def make_move(turn)
    if computer_turn?(turn)
      computer_move
    else
      human_move(turn)
    end
  end

  def human_move(turn)
    loop do
      puts "#{@player_names[turn]} turn. Choose unselected position between (1 to 9):"
      position = gets.chomp.to_i
      if valid_position?(position)
        update_game(@player_symbols[turn], position)
        break
      else
        'Invalid position, try again!'.colorize(:red)
      end
    end
  end

  def computer_move
    available_cells = @board.cells.select { |cell| cell.is_a?(Integer) }
    position = available_cells.sample
    puts "Computer selects #{position}".colorize(:light_blue)
    update_game(@player_symbols[1], position)
  end

  def update_game(symbol, position)
    @board.cells[position - 1] = symbol
  end

  def valid_position?(position)
    (1..9).include?(position) && @board.cells[position - 1].is_a?(Integer)
  end

  def game_over?(turn)
    if win?(@player_symbols[turn])
      puts "#{@player_names[turn]} wins!".colorize(:cyan)
      update_score(turn)
      true
    elsif draw?
      puts 'Draw!'
      true
    else
      false
    end
  end

  def win?(symbol)
    LINES.any? { |line| line.all? { |cell| @board.cells[cell - 1] == symbol } }
  end

  def draw?
    @board.cells.all? { |cell| cell.is_a?(String) }
  end

  def update_score(winner)
    winner.zero? ? @player_one_score += 1 : @player_two_score += 1
    display_score
  end

  def display_score
    display_board
    puts "#{@player_names[0]} score: #{@player_one_score} & #{@player_names[1]} score: #{@player_two_score}"
      .colorize(:yellow)
  end

  def rematch?
    puts 'Do you want a rematch? (y/n)'
    gets.chomp.downcase == 'y'
  end

  def display_board
    puts @board.display
  end

  def reset_board
    @board = Board.new
  end
end
