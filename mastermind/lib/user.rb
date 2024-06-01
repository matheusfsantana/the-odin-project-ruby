require_relative 'player_basics'

class User < PlayerBasic
  def valid_code?(input)
    input.length == 4 && input.all? { |number| number.between?(1, 6) }
  end

  def input_code
    input = []
    puts 'Type 4 numbers combinations between 1 and 6: (ex: 1234)'
    valid_input = false
    until valid_input
      input = gets.chomp.chars.map(&:to_i)
      valid_input = valid_code?(input)
      puts 'Invalid input. Please enter a 4-number combination using digits between 1 and 6.' unless valid_input
    end
    input
  end

  def create_code
    @code = input_code
  end

  def guess_code
    @guess = input_code
  end
end
