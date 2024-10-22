# frozen_string_literal: true

# require_relative 'players'
# require_relative '../colorize'

# Set up the board
class Board
  attr_reader :cells

  @cells = [1, 2, 3, 4, 5, 6, 7, 8, 9]
  @patterns = [
    [1, 2, 3], [4, 5, 6], [7, 8, 9],
    [1, 4, 7], [2, 5, 8], [3, 6, 9],
    [1, 5, 9], [3, 5, 7]
  ]

  # method display: Print the board
  @board = <<HEREDOC

         #{@cells[0]} | #{@cells[1]} | #{@cells[2]}
        ---+---+---
         #{@cells[3]} | #{@cells[4]} | #{@cells[5]}
        ---+---+---
         #{@cells[6]} | #{@cells[7]} | #{@cells[8]}

HEREDOC

  def self.display_board
    puts @board
  end
  # takes a position and player symbol, and updates the board

  # valid_move: checks if a selected position is available

  # pattern_complete?: return true if a pattern gets matched
end

Board.display_board
