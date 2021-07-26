require 'json'

# Start new game, or load save game
# each turn allow for save, which quits game
# on win/lose, delete save

# save
a = [@word_selection = nil,
@selection = [],
@wrong_guesses = [],
@win = 0]

tempHash = {
  'key_a' => 'val_a',
  'key_b' => 'val_b'
}

File.open('test.json', 'w') do |f|
  f.write(JSON.pretty_generate(a))
end
# if save directory doesnt exist, make it(Dir.exists)(Dir.mkdir)
# if save exists, refuse name(.exists?)
#   else new file (File.new)

# load
