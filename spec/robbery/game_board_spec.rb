require 'spec_helper'

=begin

  How the engine is used:

  Add players.

  Start game - initializes state?
  Should there be a turn phase state? Will it actually do anything?
  How much state should the engine have? For instance should it gererate and save
  train state? I think so. "Read" method should be "Generate" and the state should
  be saved so it can be used by other methods that require that information.

  Turn phase would just be a convinience for telling where the game engine is at.


  # Turn start

  Generate trains

  Players draw cards
  Shouldn't get more than one intel card per turn, chance of draw should be 25%?

  Players place cards on trains

  Decide intel cards - intel cards are blank until after all players place cards

  Players play intel cards (intel cards are only good for one turn)

  Players move cards based on intel card

  Show cards - Engine does nothing, this is all UI

  Get train battle enumerator and call battle for each one.
  (? Battle could do it but having an enumerator could be useful)

  Battle will return results and alter game state (increase/decrease)

  Read player scores (display them using your views)

  call Victory? and exit if true

=end


describe Robbery::GameBoard do

  let(:board){Robbery::GameBoard.new(card_data: @sample_card_data)}
  before(:each) do
    board.reset
  end

  it "should set card data when initialized" do
    board = Robbery::GameBoard.new(card_data: @sample_card_data)
    board.deck.should_not be_nil
  end

  context "when starting a turn" do
    
    it "should generate train sets" do
      board.add_player(
        name: "Fred",
        gang: :gang,
        gang_name: "The Wilmas"
      )
      expect{board.start_turn}.should change(board, :trains).from be_empty
    end
    
  end

  context "when resetting the board" do

    it "should remove players" do
      board.add_player(
        name: "Fred",
        gang: :gang,
        gang_name: "The Wilmas"
      )
      expect{board.reset}.should change(board, :players).to be_empty
    end

    it "should remove players" do
      board.add_player(
        name: "Fred",
        gang: :gang,
        gang_name: "The Wilmas"
      )
      board.build_trains
      expect{board.reset}.should change(board, :trains).to be_empty
    end

  end

  context "when adding players" do

    it "should add players" do
      expect{
        board.add_player(
          name: "Fred",
          gang: :gang,
          gang_name: "The Wilmas"
        )
      }.should change(board, :players)
    end

    it "should return player data if created" do
      player = board.add_player(
        name: "Fred",
        gang: :gang,
        gang_name: "The Wilmas"
      )
      player.should be_a(Robbery::Player)
    end

    it "should not add a player with the same gang name" do
      player1 = board.add_player(
        name: "Fred",
        gang: :gang,
        gang_name: "The Wilmas"
      )
      player2 = board.add_player(
        name: "Gorgon",
        gang: :gang,
        gang_name: "The Wilmas"
      )
      
      player2.should be_nil
      
    end

  end

  context "when building the deck" do

    it "should build a deck using provided deck data" do
      board.build_deck(@sample_card_data)
      board.deck.should be_a(Robbery::CardDeck)
    end

  end

  context "when making trains" do

    it "should make trains" do
      board.add_player(
        name: "Fred",
        gang: :gang,
        gang_name: "The Wilmas"
      )
      board.build_trains
      board.trains.all?{|train| train.is_a? Robbery::Train}.should be_true
    end

    it "should make trains based on the number of players" do
      board.add_player(
        name: "Fred",
        type: :gang,
        gang_name: "The Wilmas"
      )
      board.build_trains
      train_count = board.trains.count
      board.add_player(
        name: "Bubba Gump",
        type: :gang,
        gang_name: "Shrimps"
      )
      board.build_trains
      board.trains.count.should > train_count
    end

  end

  context "when drawing cards" do

    before(:each) do
      @player1 = board.add_player(
        name: "Fred",
        gang: :gang,
        gang_name: "The Wilmas"
      )
      board.build_deck(@sample_card_data)
    end

    it "should add cards to the player's cards" do
      board.draw_cards(player: @player1, count: 3)
      @player1.cards.count.should == 3
    end

    it "should draw a specific kind of card" do
      board.draw_cards(player: @player1, type: :intel)
      @player1.cards.first.type.should == :intel
    end

    it "should only draw one intel card per player" do
      board.draw_cards(player: @player1, type: :intel)
      board.draw_cards(player: @player1, type: :intel)
      @player1.cards.select{|card| card.type == :intel}.count.should == 1
    end

  end

  context "when placing cards" do

    before(:each) do
      @player1 = board.add_player(
        name: "Fred",
        gang: :gang,
        gang_name: "The Wilmas"
      )
      board.build_trains
      board.draw_cards(player: @player1, count: 2, type: :equipment)
    end

    it "should place snakes on a plane, I mean cards on a train" do
      board.place_card(
        player: @player1,
        card: @player1.cards.first,
        train: board.trains.first
      )
      board.trains.first.placed_cards[@player1].should == [@player1.cards.first]
    end

    it "should not place intel cards" do
      draw = board.draw_cards(player: @player1, type: :intel)
      card = board.place_card(
        player: @player1,
        card: draw.first,
        train: board.trains.first
      )
      card.should == nil
    end
    
  end

  context "when moving a card" do

    before(:each) do
      @player1 = board.add_player(
        name: "Fred",
        gang: :gang,
        gang_name: "The Wilmas"
      )
      board.build_trains
      board.draw_cards(player: @player1, count: 2, type: :equipment)
    end

    it "should place a card again (allows moving during intel)" do
      board.place_card(
        player: @player1,
        card: @player1.cards.first,
        train: board.trains.first
      )
      board.place_card(
        player: @player1,
        card: @player1.cards.first,
        train: board.trains.last
      )
      board.trains.last.placed_cards[@player1].should == [@player1.cards.first]
    end

  end

  context "when generating intel" do

    before(:each) do
      @player1 = board.add_player(
        name: "Fred",
        gang: :gang,
        gang_name: "Wilma's Boys"
      )
      @player2 = board.add_player(
        name: "Copper",
        gang: :pinkerton,
        gang_name: "Da Cops"
      )
      board.build_trains
      board.draw_cards(player: @player1, count: 2, type: :equipment)
      board.draw_cards(player: @player2, count: 2, type: :equipment)
      board.place_card(
        player: @player1,
        card: @player1.cards.first,
        train: board.trains.first
      )
      board.place_card(
        player: @player1,
        card: @player1.cards.last,
        train: board.trains.first
      )
      board.place_card(
        player: @player2,
        card: @player2.cards.first,
        train: board.trains.last
      )
      board.place_card(
        player: @player2,
        card: @player2.cards.last,
        train: board.trains.last
      )
    end

    it "should not set intel card names when first drawn" do
      board.draw_cards(player: @player1, type: :intel)
      board.player_cards(:intel).all?{|card|card.name.nil?}.should be_true
    end

    it "should not set intel card descriptions when first drawn" do
      board.draw_cards(player: @player1, type: :intel)
      
      board.player_cards(:intel).all? do |card|
        card.description.nil?
      end.should be_true
    end

    it "should add a name to intel cards" do
      board.draw_cards(player: @player1, type: :intel)
      board.draw_cards(player: @player2, type: :intel)
      
      board.generate_intel
      
      board.player_cards(:intel).none? do |card|
        card.name.nil?
      end.should be_true
    end

    it "should add a description to intel cards" do
      board.draw_cards(player: @player1, type: :intel)
      board.draw_cards(player: @player2, type: :intel)
      
      board.generate_intel
      
      board.player_cards(:intel).none? do |card|
        card.description.nil?
      end.should be_true
    end

  end

  context "when battling" do


    before(:each) do
      @player1 = board.add_player(
        name: "Fred",
        gang: :gang,
        gang_name: "Wilma's Boys"
      )
      @player2 = board.add_player(
        name: "Copper",
        gang: :pinkerton,
        gang_name: "Da Cops"
      )
      board.build_trains
      board.draw_cards(player: @player1, count: 2, type: :equipment)
      board.draw_cards(player: @player2, count: 2, type: :equipment)
      board.place_card(
        player: @player1,
        card: @player1.cards.first,
        train: board.trains.first
      )
      board.place_card(
        player: @player1,
        card: @player1.cards.last,
        train: board.trains.first
      )
      board.place_card(
        player: @player2,
        card: @player2.cards.first,
        train: board.trains.first
      )
      board.place_card(
        player: @player2,
        card: @player2.cards.last,
        train: board.trains.first
      )
    end

=begin

   battle data
   train: <train>
  winner: <player>
   loser: <player>
  reward: points

=end
    
    it "should return which trains were in battles" do
      battles = board.resolve_battles
      battles.first[:train].should == board.trains.first
      
    end
    
    
  end

end











