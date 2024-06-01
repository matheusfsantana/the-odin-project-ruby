require_relative 'game_basics'
require_relative 'user'
require_relative 'computer'

class Game
  include GameBasics
  attr_writer :code, :guess, :attempt

  def initialize
    @attempt = 1
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

  def end_game
    puts "\nGame over, the correct combination was #{@code}" if @attempt == 10 && !win?(@code, @guess)
    puts "\nCode was broken by #{@player}" if win?(@code, @guess)
  end

  def reset_game
    puts "\nTry again? (1) Yes (Any) No"
    reset = gets.chomp.to_i
    Game.new.start_game if reset == 1
  end

  def start_game
    @code = @computer.create_code if @player == 'User'
    @code = @user.create_code if @player == 'Computer'

    until win?(@code, @guess) || @attempt == 10
      @guess = @user.guess_code if @player == 'User'
      @guess = @computer.guess_code(@code) if @player == 'Computer'
      compare(@code, @guess)
      @attempt += 1
    end
    end_game
    reset_game
  end
end
