require_relative 'player_basics'

class Computer < PlayerBasic
  attr_reader :exact, :not_exact

  def initialize
    super
    @exact = {} # store the idx and the value of exact match
    @not_exact = [] # store the value of the not exact match
  end

  def create_code
    4.times do
      @code.push(Random.rand(1..6))
    end
    @code
  end

  def guess_code(code)
    code_count = Hash.new(0)
    guess_count = Hash.new(0)

    new_guess = []

    if @guess.empty?
      @guess = create_code
      puts "\nComputer guess: #{@guess}"
      return @guess
    else
      4.times do |i|
        new_guess[i] = (@exact[i] || @not_exact.sample || Random.rand(1..6))
      end
      @not_exact = []
    end

    code.each_with_index do |num, idx|
      if @guess[idx] == num
        @exact[idx] = num
      else
        code_count[num] += 1
        guess_count[@guess[idx]] += 1
      end
    end

    guess_count.each do |key, num|
      not_exact.push(num) if code_count[key] >= 1
    end
    puts "\nComputer guess: #{new_guess}"
    @guess = new_guess
  end
end
