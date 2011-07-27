$:.unshift File.expand_path(File.join(File.dirname(__FILE__), "/../lib"))
$: << '.'

require 'robbery'
require_relative 'sample_cards'

# Create a game object. This is the only class you need to interact with.
puts "Starting game"
game = Robbery::Game.new(card_data: @sample_card_data)

# Get player information using your own UI
player1_data = {
  name: "Thom",
  gang: :gang,
  gang_name: "Thom's Tom-Toms"
}

player2_data = {
  name: "Dick",
  gang: :gang,
  gang_name: "The Unimaginatily Named Possie"
}

player3_data = {
  name: "Harry",
  gang: :gang,
  gang_name: "Bald Eagles for Freedom"
}

# only one player can be the pinkertons
player4_data = {
  name: "Sally",
  gang: :pinkerton,
  gang_name: "Da Fuzz"
}

# Now add the player data one player at a time...
puts "Adding users"
game.add_player(player1_data)
game.add_players(player2_data)
# or more
game.add_players(player3_data,player4_data)


# now you can start running turns
# the following is one turn

# Generate the list of trains
game.build_trains

# show the trains to the users in your UI
puts "*" * 40
puts "trains:"
game.trains.each do |train|
  puts  "#{train.name} is a #{train.type} train with " +
        "#{train.cars} cars worth #{train.value}."
end
puts

# Draw cards for each player
puts "*" * 40
puts "drawing cards:"
game.players.each do |player|
  puts
  # As the rule designer you decide how many cards to draw
  game.draw_cards(player: player, count: player.level * 2)

  # you can also force card draws
  # There's a random chance to get an intel card
  # but let's make sure everyone has one.
  # if they already have one the engine will draw something else.
  game.draw_cards(player: player, type: :intel)

  # Show each user their cards in your UI
  puts "player: #{player.name}"
  player.cards.each do |card|
    puts "type: #{card.type}"
    # intel cards don't get names and descriptions till the intel phase
    unless card.type == :intel
      puts "  #{card.name}"
      puts "  #{card.description}"
    end
  end
  puts
end

puts
puts "*" * 40
puts "place cards"
# Allow users to place cards on trains
# you would get player input but for the example I'll fake it
game.players.each do |player|
  puts
  puts "player: #{player.name}"
  player.cards.each do |card|
    next if card.type == :intel
    puts "  #{card.name}"
    puts "  #{card.description}"

    while true
      train = game.trains.sample
      # This is how you would place a card once you get the choice from the user
      break if game.place_card(player: player, card: card, train: train)
    end
  end
end

puts
puts "*" * 40
puts "intel cards"
# Now that cards are placed you should generate the intel for intel cards
# this allows the player to move cards based on the info they get.
intel_data = game.generate_intel

# The engine limits intel cards to one per turn
# this is one of the few rules enforced by the engine.

# show the players their intel if they have any
intel_data.each do |intel|

  # Get input from the user in your UI
  # As the rule designer you decide how many cards can be moved
  # this is just to pretend to get user input
  player = intel[:player]
  card = player.cards.first
  train = game.trains.last

  puts
  puts "player: #{player.name}"
  puts "  #{intel[:card].name}"
  puts "  #{intel[:card].description}"

  # Just call place card again and existing cards will be moved
  game.place_card(player: player, card: card, train: train)
end

puts
puts "*" * 40
puts "reveal cards"
# reveal cards to players in your UI
game.trains.each do |train|
  puts
  puts "cards placed on #{train.name}"
  game.players.each do |player|
    next if player.cards_on_train(train).empty?
    puts "player: #{player.name}"
    player.cards_on_train(train).each do |card|
      puts "type: #{card.type}"
      # intel cards don't get names and descriptions till the intel phase
      unless card.type == :intel
        puts "  #{card.name}"
        puts "  #{card.description}"
      end
    end
  end
end

puts
puts "*" * 40
puts "battle phase"
# resolve all the battles - easy huh?
battle_results = game.resolve_battles


puts
puts "*" * 40
puts "battle results"
# process the results
unique_rewards_test = {}
battle_results.each do |result|

  train   = result[:train]
  winner  = result[:winner]
  loser   = result[:loser]
  score   = train.value
  score_type = {cargo: :riches, passenger: :fame}[train.type]

  puts "Battle for #{train.name}"
  print winner.name
  if loser
    print " beat #{loser.name}"
  else
    print " went unapposed"
  end

  # you can decide to give rewards for winning each battle but it
  # makes more sense to only give it once for the train
  unless unique_rewards_test[train]
    unique_rewards_test[train] = true
    puts " and won #{score} #{score_type} points"
    # modify the player scores
    game.change_player_score(
      player: winner,
      amount: score,
      type: score_type
    )
  else
    puts
  end
end

puts
puts "*" * 40
puts "Player scores"
# show the players their scores at the end of the round
game.players.each do |player|
  puts
  puts "player: #{player.name}"
  puts " level: #{player.level}"
  puts "  fame: #{player.fame}"
  puts "riches: #{player.riches}"
end

# As the rule designer you decide victory conditions
# you could make it first player to level 10 or who has
# the most points at the end of turn 10 or whatever you want.
puts
puts "*" * 40
puts "Victory!"

























