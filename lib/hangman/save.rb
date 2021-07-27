# frozen_string_literal: true2

module SaveLoad
  def dir_check
    Dir.mkdir('saves') unless Dir.exist?('saves')
  end

  def load_progress
    display_saves
    choice = gets.chomp.to_i
    load_progress unless choice.between?(1, 3)
    if save_exists(choice)
      savefile = JSON.load(File.read(".saves/#{choice}.json"))
      @word_selection = savefile['word_selection']
      @selection = savefile['selection']
      @wrong_guesses = savefile['wrong_guesses']
      @current_save = ".saves/#{choice}.json"
      true
    else
      false
    end
  end

  def save_progress
    dir_check
    File.open(".saves/#{save_name}.json", 'w') { |file| file.write save_json }
  end

  def save_name
    display_saves
    filename = gets.chomp.to_i
    if overwrite_check(filename) && filename.between?(1, 3)
      filename
    else
      save_name
    end
  end

  def save_json
    JSON.dump(
      'word_selection' => @word_selection,
      'selection' => @selection,
      'wrong_guesses' => @wrong_guesses
    )
  end

  def overwrite_check(filename)
    if save_exists(filename)
      puts "\nAre you sure you want to overwrite slot #{filename}?"
      choice = nil
      while choice != 'y' && choice != 'n'
        puts "\n Type 'Y' to overwrite, 'N' to choose another file."
        choice = gets.chomp.downcase
      end
      if choice == 'y'
        puts 'Overwriting'
        true
      elsif choice == 'n'
        false
      end
    else
      true
    end
  end

  def save_exists(file_number)
    File.exist?(".saves/#{file_number}.json") ? true : false
  end

  def display_saves
    puts "\nPlease choose a save slot:\n1) #{progress_or_empty(1)}\n2) #{progress_or_empty(2)}\n3) #{progress_or_empty(3)}"
  end

  def progress_or_empty(file_number)
    save_exists(file_number) ? 'In Progress' : 'Empty'
  end
  # if save directory doesnt exist, make it(Dir.exists)(Dir.mkdir)
  # if save exists, refuse name(.exists?)
  #   else new file (File.new)

  # load
end
