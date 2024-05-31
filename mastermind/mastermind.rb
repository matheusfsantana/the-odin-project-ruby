class PlayerBasic
  attr_reader :code, :guess

  def initialize
    @code = []
    @guess = []
  end
end

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

class Computer < PlayerBasic
  def create_code
    4.times do
      @code.push(Random.rand(1..6))
    end
    @code
  end
end

module GameBasics
  def compare(code, guess)
    exact_matches = 0
    number_matches = 0
    code_count = Hash.new(0)
    guess_count = Hash.new(0)

      code.each_with_index do |num, idx|
        if num == guess[idx]
          exact_matches += 1
        else
          code_count[num] += 1
          guess_count[guess[idx]] += 1
        end
      end

      guess_count.each_key do |num|
        number_matches += code_count[num] if code_count[num] >= 1
      end
      give_feedback(exact_matches, number_matches)
  end

  def give_feedback(exact, matches)
    puts "Exact Matches: #{exact}"
    puts "Number Matches: #{matches}"
  end

  def win?(code, guess)
    code == guess
  end
end

class Game
  include GameBasics
  attr_writer :code, :guess

  def initialize
    @user = User.new
    @computer = Computer.new
    @player = breaker_or_player
  end

  def breaker_or_player
    choice = nil
    until [1, 2].include?(choice)
      puts 'Do you want to create the code (1) or be the code breaker (2)?'
      choice = gets.chomp.to_i
      if choice != 1 && choice != 2
        puts 'Invalid choice. Please enter 1 to be the code creator or 2 to be the code breaker.'
      end
    end
    return 'Computer' if choice == 1

    'User' if choice == 2
  end

  def start_game
    if @player == 'User'
      @code = @computer.create_code
    end

    until win?(@code, @guess)
        @guess = @user.guess_code
        compare(@code, @guess)
    end

    puts "Code was broken by #{@player}"
  end
end

Game.new.start_game
