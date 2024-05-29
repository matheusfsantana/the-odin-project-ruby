# frozen_string_literal: true

# Board game
class TicTacToe
  WIN_CONDITION = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]].freeze

  attr_accessor :board

  def initialize
    @board = Array.new(9, '-')
  end

  def draw_board
    p @board[0..2]
    p @board[3..5]
    p @board[6..8]
  end

  def draw_x
    puts 'Player X - Choose a position: '
    position = gets.to_i
    position = gets.to_i until valid_position?(position)
    @board[position] = 'X'
  end

  def draw_o
    puts 'Player O - Choose a position: '
    position = gets.to_i
    position = gets.to_i until valid_position?(position)
    @board[position] = 'O'
  end

  def valid_position?(position = - 1)
    if position < 0 || position > 8
      puts 'Invalid position. Choose 0..8'
      false
    elsif @board[position] == '-'
      true
    else
      puts 'Invalid position. This position is already taken'
      false
    end
  end

  def check_game
    if board_full? == true && player_o_has_won? != true && player_x_has_won? != true
      puts 'Draw!'
      reset_game
    elsif player_x_has_won?
      puts 'Player X Won!'
      reset_game
    elsif player_o_has_won?
      puts 'Player O Won!'
      reset_game
    end
  end

  def board_full?
    @board.none? { |line| line == '-' }
  end

  def player_x_has_won?
    WIN_CONDITION.any? do |line|
      line.all? { |position| @board[position] == 'X' }
    end
  end

  def player_o_has_won?
    WIN_CONDITION.any? do |line|
      line.all? { |position| @board[position] == 'O' }
    end
  end

  def reset_game
    @board = Array.new(9, '-')
  end

  def play_game
    loop do
      check_game
      draw_board
      draw_x
      draw_board
      check_game
      draw_o
      draw_board
    end
  end
end

game = TicTacToe.new
game.play_game
