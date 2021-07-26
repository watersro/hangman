# frozen_string_literal: true

module Hangman
  # class that instatiates turns
  class HangmanTurn
    attr_accessor :word_selection, :selection, :wrong_guesses, :win

    def initialize
      @word_selection = nil
      @selection = []
      @wrong_guesses = []
      @win = 0
    end

    def rand_range_gen
      rand(0..61_405)
    end

    def length_check(line)
      if line.length >= 6 && line.length <= 12
        true
      else
        false
      end
    end

    def read_file
      lines = File.readlines('5desk.txt')
      while @word_selection.nil?
        lines.each_with_index do |line, index|
          @word_selection = line if index == rand_range_gen && length_check(line)
        end
      end
    end

    def turns
      print_spaces
      while @wrong_guesses.size <= 12 && win.zero?
        puts 'Take a guess, or save and quit:'
        guess
        win_check?
      end
      if @win == 1
        puts 'You Win!'
        true
      else
        puts 'You Lose'
        false
      end
    end

    # create hash from
    def print_spaces
      read_file
      word_selection.split('').each_with_index do |item, index|
        selection[index] = [item, '_'] unless item.nil? || item == "\n"
      end
      selection.each_index do |index|
        print selection[index][1]
      end
      print "\n"
      puts word_selection
    end

    def guess
      input = guess_helper
      correct = false
      already_guessed = false
      @selection.each_with_index do |item, index|
        if item[0].downcase == input.to_s.downcase
          if item[1] == input.to_s.downcase
            already_guessed = true
          else
            correct = true
          end
          @selection[index][1] = input
        elsif selection.flatten.none?(input) && @wrong_guesses.any?(input) == false
          @wrong_guesses << input
        end
      end
      repeat_guess?(correct, already_guessed)
      print "\n Wrong guesses:\n#{@wrong_guesses}" if @wrong_guesses.empty? == false
      print "\n"
      selection.each_index { |index| print selection[index][1] }
      print "\n"
    end

    def guess_helper
      input = gets.chomp
      if input.length == 1 && input.match(/[a-zA-Z]/)
        input.to_s
      else
        puts 'Error: please enter one letter'
        guess_helper
      end
    end

    def repeat_guess?(correct, already_guessed)
      if correct == false && already_guessed == true
        puts 'Already Guessed This Letter!'
      elsif correct == true && already_guessed == false
        puts 'Good Guess!'
      else
        puts 'Nope!'
      end
    end

    def win_check?
      @win = 1 if win_check_helper? == true
    end

    def win_check_helper?
      check = true
      selection.each_index do |index|
        check = false if selection[index].include?('_')
      end
      check
    end
  end
end
