# frozen_string_literal: true

# features that could be implemented
# new game

# Creates the code for the game
module CreateCodeable
  private

  def create_code
    digits = Array.new(4)
    4.times { digits.push(rand(1..6)) }
    digits.join('')
  end
end

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
    puts "There was #{correct_position} in the right position with the correct number
    and #{wrong_position} with the right number but wrong position!"
    puts '---------------------------------'
    puts
  end

  def results(guess, guesses, code)
    puts "Guess ##{guesses}"
    correct_position = 0
    (0..3).each do |i|
      correct_position += 1 if guess.to_s[i] == code.to_s[i]
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

# would have combined this with the code creating module for a code and guess module
# Can check the validity of a player guess
module CheckGuessValidityable
  private

  def check_valid_guess(number)
    unless number.zero?
      return false unless number.to_s.length == 4

      number.to_s.each_char do |c|
        return false if c.to_i > 6 || c.to_i < 1
      end
    end
    true
  end
end

# The computer which plays with the player
class Computer
  include CreateCodeable
  include GiveResultsable

  attr_reader :game_over, :guesses

  def initialize
    @guesses = 1
    @game_over = false
    @code = create_code
  end

  # the computer's guessing skills sucks but i give up
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
end

# The human player which can input and interact with the program
class Player
  include CheckGuessValidityable

  attr_reader :code

  def enter_code
    @code = -1
    until check_valid_guess(@code)
      puts 'Enter a code for a 4 digit code using digits 1 to 6: '
      @code = gets.chomp.to_i
      puts
    end
  end

  def guess
    player_guess = -1
    until check_valid_guess(player_guess)
      puts 'Enter a guess for a 4 digit code using digits 1 to 6: '
      player_guess = gets.chomp.to_i
      puts
    end
    player_guess
  end
end

computer = Computer.new
player = Player.new

game_type = 0
until [1, 2].include?(game_type)
  puts 'Enter 1 for code creator and 2 for guesser: '
  game_type = gets.chomp.to_i
  puts
end

if game_type == 1
  player.enter_code
  puts
  until computer.game_over
    computer.make_guess(player.code)
    sleep(0.5)
  end
else
  puts 'Guess the code in 12 tries, type 0 or enter to give up.'
  puts
  computer.recieve_guess(player.guess) until computer.game_over
end
