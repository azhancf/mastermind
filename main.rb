# frozen_string_literal: true

# put unused by both functions back into the computer class
# Is able to deal with the results of the guess
module GiveResultsable
  private

  def win_message(code, guesser)
    puts guesser == 'player_guesser' ? 'Congrats! You won!!!' : 'The computer guesssed your code!'
    puts "The correct code was #{code}"
  end

  def loss_message(code, guesser)
    puts guesser == 'player_guesser' ? 'O0f, you lost :(' : 'Nice, the computer was not able to guess your code.'
    puts "The correct code was #{code}"
  end

  def print_results(correct_position, wrong_position)
    puts "There was #{correct_position} in the right position with the corrrect number and #{wrong_position} with the right number but wrong position!"
    puts '---------------------------------'
    puts
  end

  def results(guess, guesses, code)
    puts "Guess ##{guesses}"
    correct_position = 0
    for i in (0..3)
      if guess.to_s[i] == code.to_s[i]
        correct_position += 1
      end
    end
    wrong_position = (guess.to_s.split('') & code.to_s.split('')).length - correct_position
    print_results(correct_position, wrong_position)
  end

  def check_game_over(guess, guesses, code, guesser)
    if guess == code
      win_message(code, guesser)
      self.game_over = true
    elsif guess.zero?
      loss_message(code, guesser)
      self.game_over = true
    else
      results(guess, guesses, code)
    end
  end
end

# The computer which plays with the player
class Computer
  include GiveResultsable

  attr_reader :game_over, :guesses

  def initialize
    @guesses = 1
    @game_over = false
    @code = create_code
  end

  def make_guess(code)
    computer_guess = create_code.to_i
    puts "The computer guessed #{computer_guess}"
    check_game_over(computer_guess, @guesses, code, 'computer_guesser')
    @guesses += 1
    if @guesses > 12
      puts 'The computer could not guess the code.'
      @game_over = true
    end
    'guess made'
  end

  def recieve_guess(guess)
    check_game_over(guess, @guesses, @code, 'player_guesser')
    @guesses += 1
    if @guesses > 12 && !game_over
      loss_message(@code)
      @game_over = true
    end
    'recieved guess'
  end

  private

  attr_writer :game_over

  def create_code
    digits = Array.new(4)
    4.times { digits.push(rand(1..6)) }
    digits.join('')
  end
end

# The human player which can input and interact with the program
class Player
  attr_reader :code

  def enter_code # check input
    puts "Enter a code for the computer to guess."
    @code = gets.chomp.to_i
  end

  def check_valid_guess # put in module
  end

  def guess # TODO: has to be int from 1111 to 6666
    gets.chomp.to_i
  end
end

# TODO: module or instance function for printing instructions, or make some functions as part of the Game class/module

# new game?

computer = Computer.new
player = Player.new

puts 'Enter 1 for code creator and 2 for guesser: '
game_type = gets.chomp.to_i # check until 1 or 2
if game_type == 1
  player.enter_code
  puts
  until computer.game_over
    computer.make_guess(player.code)
    # wait for a bit
  end
else
  puts 'Guess the code in 12 tries, type 0 or enter to give up.'
  puts
  until computer.game_over
    computer.recieve_guess(player.guess)
  end
end
