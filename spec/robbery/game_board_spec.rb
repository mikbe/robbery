require 'spec_helper'

=begin

  Battle will return results and alter game state 

  UI: Read player scores (display them using your views)

  UI: call Victory? and exit if true

=end


describe Robbery::Game do

  let(:game){Robbery::Game.new(card_data: @sample_card_data)}
  before(:each) do
    game.reset
  end

  it "should set card data when initialized" do
    game = Robbery::Game.new(card_data: @sample_card_data)
    game.deck.should_not be_nil
  end

  context "when resetting the game" do

    it "should remove players" do
      game.add_player(
        name: "Fred",
        gang: :gang,
        gang_name: "The Wilmas"
      )
      expect{game.reset}.should change(game, :players).to be_empty
    end

    it "should remove players" do
      game.add_player(
        name: "Fred",
        gang: :gang,
        gang_name: "The Wilmas"
      )
      game.build_trains
      expect{game.reset}.should change(game, :trains).to be_empty
    end

  end

  context "when adding players" do

    it "should add players" do
      expect{
        game.add_player(
          name: "Fred",
          gang: :gang,
          gang_name: "The Wilmas"
        )
      }.should change(game, :players)
    end

    it "should return player data if created" do
      player = game.add_player(
        name: "Fred",
        gang: :gang,
        gang_name: "The Wilmas"
      )
      player.should be_a(Robbery::Player)
    end

    it "should not add a player with the same gang name" do
      player1 = game.add_player(
        name: "Fred",
        gang: :gang,
        gang_name: "The Wilmas"
      )
      player2 = game.add_player(
        name: "Gorgon",
        gang: :gang,
        gang_name: "The Wilmas"
      )

      player2.should be_nil

    end

  end

  context "when building the deck" do

    it "should build a deck using provided deck data" do
      game.build_deck(@sample_card_data)
      game.deck.should be_a(Robbery::CardDeck)
    end

  end

  context "when making trains" do

    it "should make trains" do
      game.add_player(
        name: "Fred",
        gang: :gang,
        gang_name: "The Wilmas"
      )
      game.build_trains
      game.trains.all?{|train| train.is_a? Robbery::Train}.should be_true
    end

    it "should make trains based on the number of players" do
      game.add_player(
        name: "Fred",
        type: :gang,
        gang_name: "The Wilmas"
      )
      game.build_trains
      train_count = game.trains.count
      game.add_player(
        name: "Bubba Gump",
        type: :gang,
        gang_name: "Shrimps"
      )
      game.build_trains
      game.trains.count.should > train_count
    end

  end

  context "when drawing cards" do

    before(:each) do
      @player1 = game.add_player(
        name: "Fred",
        gang: :gang,
        gang_name: "The Wilmas"
      )
      game.build_deck(@sample_card_data)
    end

    it "should add cards to the player's cards" do
      game.draw_cards(player: @player1, count: 3)
      @player1.cards.count.should == 3
    end

    it "should draw a specific kind of card" do
      game.draw_cards(player: @player1, type: :intel)
      @player1.cards.first.type.should == :intel
    end

    it "should only draw one intel card per player" do
      game.draw_cards(player: @player1, type: :intel)
      game.draw_cards(player: @player1, type: :intel)
      @player1.cards.select{|card| card.type == :intel}.count.should == 1
    end

  end

  context "when placing cards" do

    before(:each) do
      @player1 = game.add_player(
        name: "Fred",
        gang: :gang,
        gang_name: "The Wilmas"
      )
      game.build_trains
      game.draw_cards(player: @player1, count: 2, type: :equipment)
    end

    it "should place snakes on a plane, I mean cards on a train" do
      game.place_card(
        player: @player1,
        card: @player1.cards.first,
        train: game.trains.first
      )
      game.trains.first.placed_cards[@player1].should == [@player1.cards.first]
    end

    it "should not place intel cards" do
      draw = game.draw_cards(player: @player1, type: :intel)
      card = game.place_card(
        player: @player1,
        card: draw.first,
        train: game.trains.first
      )
      card.should == nil
    end

    it "should set the train of the placed card" do
      draw = game.draw_cards(player: @player1, type: :equipment)
      card = game.place_card(
        player: @player1,
        card: draw.first,
        train: game.trains.first
      )
      card.placed_on_train.should == game.trains.first
    end


  end

  context "when moving a card" do

    before(:each) do
      @player1 = game.add_player(
        name: "Fred",
        gang: :gang,
        gang_name: "The Wilmas"
      )
      game.build_trains
      game.draw_cards(player: @player1, count: 2, type: :equipment)
    end

    it "should place a card again (allows moving during intel)" do
      game.place_card(
        player: @player1,
        card: @player1.cards.first,
        train: game.trains.first
      )
      game.place_card(
        player: @player1,
        card: @player1.cards.first,
        train: game.trains.last
      )
      game.trains.last.placed_cards[@player1].should == [@player1.cards.first]
    end

  end

  context "when generating intel" do

    before(:each) do
      @player1 = game.add_player(
        name: "Fred",
        gang: :gang,
        gang_name: "Wilma's Boys"
      )
      @player2 = game.add_player(
        name: "Copper",
        gang: :pinkerton,
        gang_name: "Da Cops"
      )
      game.build_trains
      game.draw_cards(player: @player1, count: 2, type: :equipment)
      game.draw_cards(player: @player2, count: 2, type: :equipment)
      game.place_card(
        player: @player1,
        card: @player1.cards.first,
        train: game.trains.first
      )
      game.place_card(
        player: @player1,
        card: @player1.cards.last,
        train: game.trains.first
      )
      game.place_card(
        player: @player2,
        card: @player2.cards.first,
        train: game.trains.last
      )
      game.place_card(
        player: @player2,
        card: @player2.cards.last,
        train: game.trains.last
      )
    end

    it "should not set intel card names when first drawn" do
      game.draw_cards(player: @player1, type: :intel)
      game.player_cards(:intel).all?{|card|card.name.nil?}.should be_true
    end

    it "should not set intel card descriptions when first drawn" do
      game.draw_cards(player: @player1, type: :intel)

      game.player_cards(:intel).all? do |card|
        card.description.nil?
      end.should be_true
    end

    it "should add a name to intel cards" do
      game.draw_cards(player: @player1, type: :intel)
      game.draw_cards(player: @player2, type: :intel)

      game.generate_intel

      game.player_cards(:intel).none? do |card|
        card.name.nil?
      end.should be_true
    end

    it "should add a description to intel cards" do
      game.draw_cards(player: @player1, type: :intel)
      game.draw_cards(player: @player2, type: :intel)

      game.generate_intel

      game.player_cards(:intel).none? do |card|
        card.description.nil?
      end.should be_true
    end

  end

  context "when battling" do

    before(:each) do
      @player1 = game.add_player(
        name: "Fred",
        gang: :gang,
        gang_name: "Wilma's Boys"
      )
      @player2 = game.add_player(
        name: "Copper",
        gang: :pinkerton,
        gang_name: "Da Cops"
      )
      game.build_trains
      game.draw_cards(player: @player1, count: 2, type: :equipment)
      game.draw_cards(player: @player2, count: 2, type: :equipment)
      game.place_card(
        player: @player1,
        card: @player1.cards.first,
        train: game.trains.first
      )
      game.place_card(
        player: @player1,
        card: @player1.cards.last,
        train: game.trains.first
      )
      game.place_card(
        player: @player2,
        card: @player2.cards.first,
        train: game.trains.first
      )
      game.place_card(
        player: @player2,
        card: @player2.cards.last,
        train: game.trains.first
      )
    end

    it "should return the results of battles" do
      battles = game.resolve_battles
      battles.should be_an(Array)
    end

    it "should return the train for a battles" do
      battles = game.resolve_battles
      battles.first[:train].should == game.trains.first
    end

    it "should return the winner of a battle" do
      battles = game.resolve_battles
      battles.first[:winner].should be_a(Robbery::Player)
    end

    it "should return the loser of a battle" do
      battles = game.resolve_battles
      battles.first[:loser].should be_a(Robbery::Player)
    end

  end

  context "when changing player score" do
    
    before(:each) do
      @player1 = game.add_player(
        name: "Fred",
        gang: :gang,
        gang_name: "Wilma's Boys"
      )
    end
    
    it "should change a player's score" do
      amount = 5
      type = :fame
      expect{
        game.change_player_score(player: @player1, amount: amount, type: type)
      }.should change(@player1, type).by(amount)
    end

    it "should level up the player when their score is high enough" do
      amount = 11
      type = :fame
      game.change_player_score(player: @player1, amount: amount, type: type)
      @player1.level.should == 2
    end

    it "should not level up the player if their score is not high enough" do
      amount = 10
      type = :riches
      game.change_player_score(player: @player1, amount: amount, type: type)
      @player1.level.should == 1
    end

    it "should level up the player multiple levels if the score warrants it" do
      amount = (1**2 + 10) + (2**2 + 10)
      type = :riches
      game.change_player_score(player: @player1, amount: amount, type: type)
      @player1.level.should == 3
    end

  end

end











