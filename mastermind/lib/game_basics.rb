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
      number_matches += 1 if code_count[num] >= 1
    end
    give_feedback(exact_matches, number_matches)
  end

  def give_feedback(exact, matches)
    puts "Exact Matches: #{exact}"
    puts "Number Matches: #{matches}\n"
  end

  def win?(code, guess)
    code == guess
  end
end
