# frozen_string_literal: true

class Game
  def play
    puts "\nHangman! \n1) Start a new game.\n2) Load a save.\n3) Quit."
    start = gets.chomp.to_i
    case start
    when 1
      Hangman::Turns.new.new_game
    when 2
      Hangman::Turns.new.load_game
    when 3
      puts 'Bye!'
      abort
    else
      puts 'Hmm, I dont know what you mean...'
      play
    end
    play_again
  end

  def play_again
    puts "\nKeep Playing?\n1) Yes, let's play.\n2) No, I wanna quit."
    choice = gets.chomp.to_i
    case choice
    when 1
      play
    when 2
      abort
    else
      puts 'Hmm, I dont know what you mean...'
      play_again
    end
  end
end
