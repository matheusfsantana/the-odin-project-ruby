def caesar_cipher(string, shift)
    letters = []
    string.each_char {|char| letters << char.ord}

    # a-z = 97-122
    # A-Z = 65-90
    letters.map! do |letter| 
        if letter.between?(97,122)
            # Caesar cipher formula -> En(x) = (x + n) mod 26
            # Adapted formula -> En(x) = (x - 97 + n) mod 26 + 97
            letter = ((letter - 97 + shift) % 26 + 97 ).chr
        elsif letter.between?(65,90)
            # Caesar cipher formula -> En(x) = (x + n) mod 26
            # Adapted formula -> En(x) = (x - 65 + n) mod 26 + 65
            letter = ((letter - 65 + shift) % 26 + 65).chr
        else
            letter = letter.chr
        end
    end
    letters.join
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