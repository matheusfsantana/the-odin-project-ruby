def caesar_cipher(string, shift)
  string.chars.map do |char|
    if char.between?("a", "z")
      lowercase_shift(char, shift)
    elsif char.between?("A", "Z")
      uppercase_shift(char, shift)
    else
      char
    end
  end.join
end

# Caesar cipher formula -> En(x) = (x + n) mod 26
# Adapted formula -> En(x) = (x - 97 + n) mod 26 + 97 ~ [97 is the numeric value of character]
def lowercase_shift(char, shift)
  (((char.ord - "a".ord + shift) % 26) + "a".ord).chr
end

# Caesar cipher formula -> En(x) = (x + n) mod 26
# Adapted formula -> En(x) = (x - 65 + n) mod 26 + 65 ~ [65 is the numeric value of character]
def uppercase_shift(char, shift)
  (((char.ord - "A".ord + shift) % 26) + "A".ord).chr
end

def main
  p "Enter the text to be encrypted: "
  plaintext = gets.chomp
  p "Enter a shift value"
  shift = gets.chomp.to_i
  ciphertext = caesar_cipher(plaintext, shift)

  puts "Plaintext: #{plaintext}\nCiphertext: #{ciphertext}"
end

main
