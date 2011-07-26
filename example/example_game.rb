$:.unshift File.expand_path(File.join(File.dirname(__FILE__), "/../lib"))
$: << '.'

require 'robbery'
require_relative 'sample_cards'

# Create a board object. This is the only class you should interact with.
board = Robbery::GameBoard.new(card_data: @sample_card_data)

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
board.add_player(player1_data)
board.add_players(player2_data)
# or more
board.add_players(player3_data,player4_data)

# each turn consists of the following loop
victory = false
while !victory
  # Generate the list of trains
  trains = board.build_trains 
  # trains are saved for you but it returns an array of the trains as well
  
  # show the trains to your users in your UI
  trains.each do |train|
    print "#{train.name}"
    print " has #{train.cars} cars and is full of"
    puts  " #{train.type == :passenger ? "passengers" : "cargo"}"
  end
  
  # Draw cards for each player
  board.players.each do |player|
    # As the rule designer you decide how many cards to draw
    cards = board.draw_cards(player: player, count: player.level * 2)
    
    # Show each user their cards in your UI
    puts
    puts "* Cards for player: #{player.name}"
    cards.each do |card|
      puts "card: #{card.type}"
      unless card.type == :intel
        puts card.name 
        puts card.description
      end
      puts
    end
  end
  puts
  # Allow users to place cards on trains
  board.players do |player|
    # get player choices from your UI
    card1 = player.cards.first
    card2 = player.cards.last
    train = board.trains.sample
    player_choices =
    [{card: card1, train: train}, {card: card2, train: train}]
    # the above is just to make this code work
    
    # place the cards
    player_choices.each do |choice|
      # if a placement isn't valid placing a card will return false
      valid = board.place_card({player: player}.merge(choice))
    end
  end

  # Now that cards are placed you should generate the intel for intel cards
  # this allows the player to move cards based on the info they get.
  intel_data = board.generate_intel
  
  # The engine limits intel cards to one per turn
  # this is one of the few rules enforced by the engine.
  
  # show the players their intel if they have any
  intel_data.each do |intel|
    unless intel[:cards].empty?
      player_choice = nil
      begin
        # Get input from the user in your UI
        # Again as the rule designer you decide how many cards can be moved
        # for the intel but the default is 2 * the level of the player
        # I'm just going to do one for the example
        player = intel[:player]
        train = board.trains.sample
        card = player.cards.sample
        player_choice = {player: player, card: card, train: train}
      end until board.place_card(player_choice)
    end
  end

  # reveal cards to players in your UI
  board.trains.each do |train|
    cards_on_train = train.placed_cards
    # show the cards
  end

  # resolve all the battles - easy huh?
  battle_results = board.resolve_battles

  # process the results
  battle_results.each do |result|
    # show the results to the players
    
    train   = result[:train]
    winner  = result[:winner]
    loser   = result[:loser]
    
    score_type = {cargo: :riches, passenger: :fame}[train.type]
    
    # modify the player scores
    board.change_player_score(player: player, amount: amount, type: type)
    
    # show the player their new scores and levels
  end

  # As the rule designer you decide victory conditions
  victory = true
  
end




























