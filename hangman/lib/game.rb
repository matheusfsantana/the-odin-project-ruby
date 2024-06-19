class Game
  WORDS_FILENAME = 'words_file.txt'.freeze
  attr_accessor :secret, :guess, :attempts, :wrong_guesses

  def initialize(secret=self.generate_secret, guess=[], attempts=7, wrong_guesses=[])
    # This logic is because the game can be loaded or started from 0
    if guess.empty?
      secret.length.times do
        guess << "-"
      end
    end

    @secret = secret
    @guess = guess
    @attempts = attempts
    @wrong_guesses = wrong_guesses
  end

  def save_game; end

  def load_game; end

  def generate_secret
    if File.exist? WORDS_FILENAME
        words = File.new(WORDS_FILENAME, 'r').map do |word| 
            word
        end
        secret = words.sample
        
        # Loop to ensure that the secret is always be between 5~12 letters
        until secret.length.between?(5,12)
          secret = words.sample
        end
        secret.chomp.split('')
    else
        puts "File '#{WORDS_FILENAME}' not found"
    end

   
  end

  def feedback
    if self.win?
      puts "Congratulations! The secret is '#{@secret.join("")}'"
    elsif self.lose?
      puts "You lose! The secret is '#{@secret.join("")}'"
    else
      puts "Remaining attempts: #{@attempts}"
      puts "Wrong guesses: #{@wrong_guesses.join("-")}"
    end
  end

  def win?
    @guess.eql?(@secret)
  end

  def lose?
    self.attempts == 0
  end

  def user_guess
    guess = ""
    until guess.length > 0
      puts "Type a letter: "
      guess = gets.chomp
      puts "Value not allowed" if guess.length == 0
    end
    guess
  end

  def start_game
    until self.win? || self.lose?
      puts @guess.join("")
      guess = self.user_guess
      self.check_guess(guess)
      self.feedback
    end
  end
  
  # Check the guess, and if the guess is ok, put the letter in the correct place, otherwise decrease the attempts and add the letter to wrong_guesses array
  def check_guess(guess)
    p guess
    indexes = @secret.each_index.select { |index| @secret[index] == guess }
    if indexes.length > 0
      indexes.each do |index|
        @guess[index] = guess
      end
    else
      @wrong_guesses << guess
      @attempts -= 1
    end
  end

  def check_saved_games
   
  end
end
