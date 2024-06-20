require 'yaml'

class Hangman
  WORDS_FILENAME = 'words_file.txt'.freeze
  SAVED_GAMES_DIR = 'saved_games'.freeze

  attr_reader :guess, :secret, :attempts, :wrong_guesses

  def initialize
    @guess = []
    @secret = generate_secret
    @secret.length.times { @guess << '-' }
    @attempts = 7
    @wrong_guesses = []
  end

  def save_game
    Dir.mkdir(SAVED_GAMES_DIR) unless Dir.exist?(SAVED_GAMES_DIR) # rubocop:disable Lint/NonAtomicFileOperation
    files_length = Dir.new(SAVED_GAMES_DIR).children.length
    filename = SAVED_GAMES_DIR + "/game_#{files_length + 1}.yml"

    File.open(filename, 'w') do |file|
      YAML.dump(self, file)
    end
  end

  def load_game
    files = Dir.new(SAVED_GAMES_DIR).children
    return if files.empty?

    puts 'Load game? (y/n)'
    input = gets.chomp.downcase
    return unless input == 'y'

    puts 'Choose a saved game: '
    files.each_with_index do |file, index|
      puts "#{index + 1} - #{file}"
    end

    load_game = -1
    until load_game.between?(0, files.length - 1)
      load_game = gets.chomp.to_i - 1
      puts 'Invalid selection.' unless load_game.between?(0, files.length - 1)
    end

    game_file = "#{SAVED_GAMES_DIR}/#{files[load_game]}"
    File.open(game_file) do |f|
      game_obj = YAML.load(f) # rubocop:disable Security/YAMLLoad
      @guess = game_obj.guess
      @secret = game_obj.secret
      @attempts = game_obj.attempts
      @wrong_guesses = game_obj.wrong_guesses
    end
  end

  def generate_secret
    if File.exist? WORDS_FILENAME
      words = File.new(WORDS_FILENAME, 'r').map do |word|
        word
      end
      secret = words.sample

      # Loop to ensure that the secret is always be between 5~12 letters
      secret = words.sample until secret.length.between?(5, 12)
      secret.chomp.chars
    else
      puts "File '#{WORDS_FILENAME}' not found"
    end
  end

  def feedback
    if win?
      puts "Congratulations! The secret is '#{@secret.join}'"
    elsif lose?
      puts "You lose! The secret is '#{@secret.join}'"
    else
      puts "Remaining attempts: #{@attempts}"
      puts "Wrong guesses: #{@wrong_guesses.join('-')}"
      puts @guess.join
    end
  end

  def game_options
    option = nil
    until %w[1 3].include?(option)
      puts 'Options: '
      puts '1 - Continue'
      puts '2 - Save game'
      puts '3 - Reset game'
      puts '4 - Quit'
      option = gets.chomp

      case option
      in '1'
        puts 'Continue...'
      in '2'
        save_game
      in '3'
        reset_game
      in '4'
        exit
      else
        'Invalid input.'
      end
    end
  end

  def win?
    @guess.eql?(@secret)
  end

  def lose?
    @attempts.zero?
  end

  def reset_game
    initialize
    puts 'Game has been reset.'
  end

  def user_guess
    guess = ''
    until guess.length == 1
      puts 'Type a letter: '
      guess = gets.chomp.downcase
      puts 'Value not allowed' if guess.length > 1
    end
    guess
  end

  def start_game
    load_game
    until win? || lose?
      puts @guess.join
      guess = user_guess
      check_guess(guess)
      feedback
      game_options unless win? || lose?
    end
  end

  # Check the guess, and if the guess is ok, put the letter in the correct place
  # Otherwise decrease the attempts and add the letter to wrong_guesses array
  def check_guess(guess)
    indexes = @secret.each_index.select { |index| @secret[index] == guess }
    if indexes.length.positive?
      indexes.each do |index|
        @guess[index] = guess
      end
    else
      @wrong_guesses << guess
      @attempts -= 1
    end
  end
end
