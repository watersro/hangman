# frozen_string_literal: true

require 'json'
require_relative 'save'

module Hangman
  # class that instatiates turns
  class Turns
    attr_accessor :word_selection, :selection, :wrong_guesses, :win, :current_save

    include SaveLoad

    def initialize
      @word_selection = nil
      @selection = []
      @wrong_guesses = []
      @win = 0
      @current_save = nil
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

    def load_game
      if load_progress == true
        print_spaces
        print "\n Wrong guesses:\n#{@wrong_guesses}" if @wrong_guesses.empty? == false
        turn
      else
        puts 'Error, no save data in that slot.'
      end
    end

    def new_game
      read_file
      print_spaces
      turn
    end

    def turn
      while @wrong_guesses.size <= 12 && win.zero?
        puts "\nTake a guess, or type 'save' to save and quit:"
        guess
        win_check?
      end
      if @win == 1
        puts "\nYou Win!"
      else
        puts "\nYou Lose! The word you were looking for was '#{@word_selection.chomp}'."
      end
      File.delete(@current_save) if !@current_save.nil? && File.exist?(@current_save)
    end

    # create hash from
    def print_spaces
      word_selection.split('').each_with_index do |item, index|
        selection[index] = [item, '_'] unless item.nil? || item == "\n"
      end
      selection.each_index do |index|
        print selection[index][1]
        print ' '
      end
      print "\n"
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
      selection.each_index do |index|
        print selection[index][1]
        print ' '
      end
      print "\n"
    end

    def guess_helper
      input = gets.chomp
      if input.length == 1 && input.match(/[a-zA-Z]/)
        input.to_s
      elsif input == 'save'
        save_progress
        puts 'Saved! See ya later'
        abort
      else
        puts "\nError: please enter one letter"
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
