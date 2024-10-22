# frozen_string_literal: true

# board.rb
class Board
  attr_accessor :cells

  def initialize
    @cells = (1..9).to_a
  end

  def display_board
    <<~BOARD

       #{@cells[0]} | #{@cells[1]} | #{@cells[2]}
      ---+---+---
       #{@cells[3]} | #{@cells[4]} | #{@cells[5]}
      ---+---+---
       #{@cells[6]} | #{@cells[7]} | #{@cells[8]}

    BOARD
  end
end

