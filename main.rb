# frozen_string_literal: true

class Computer
  attr_reader :game_over, :guesses

  def initialize
    @guesses = 1
    @game_over = false
    create_code
  end

  def recieve_guess(guess)
    print_feedback(guess)
    @guesses += 1
    if @guesses > 12
      loss
    end
  end

  private

  def win
    puts 'Congrats! You won!!!'
    puts "The correct code was #{@code}"
    @game_over = true
  end

  def loss
    puts 'O0f, you lost :('
    puts "The correct code was #{@code}"
    @game_over = true
  end

  def print_feedback(guess) # print guess number
    puts "Guess ##{@guesses}"
    if guess == @code
      win
    elsif guess.zero?
      loss
    else
      correct_position = 0
      for i in (0..3)
        if guess.to_s[i] == @code.to_s[i]
          correct_position += 1
        end
      end
      wrong_position = (guess.to_s.split('') & @code.to_s.split('')).length - correct_position
      puts "You got #{correct_position} in the right position with the corrrect number and #{wrong_position} with the right number but wrong position!"
      puts
    end
  end

  def create_code # oh yeah this doesn't actually work what was i thinking lmao
    digits = Array.new(4)
    4.times { digits.push(rand(1..6)) }
    @code = digits.join('')
  end
end

class Human
  def guess # TODO: has to be int from 1111 to 6666
    gets.chomp.to_i
  end
end

# TODO: module or instance function for printing instructions, or make some functions as part of the Game class/module

puts "Guess the code in 12 tries, type 0 or enter to give up."

computer = Computer.new
player = Human.new

until computer.game_over
  computer.recieve_guess(player.guess)
end
