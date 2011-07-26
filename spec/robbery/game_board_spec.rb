require 'spec_helper'

=begin

  Battle will return results and alter game state 

  UI: Read player scores (display them using your views)

  UI: call Victory? and exit if true

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

    it "should return the results of battles" do
      battles = board.resolve_battles
      battles.should be_an(Array)
    end

    it "should return the train for a battles" do
      battles = board.resolve_battles
      battles.first[:train].should == board.trains.first
    end

    it "should return the winner of a battle" do
      battles = board.resolve_battles
      battles.first[:winner].should be_a(Robbery::Player)
    end

    it "should return the loser of a battle" do
      battles = board.resolve_battles
      battles.first[:loser].should be_a(Robbery::Player)
    end

  end

  context "when changing player score" do
    
    before(:each) do
      @player1 = board.add_player(
        name: "Fred",
        gang: :gang,
        gang_name: "Wilma's Boys"
      )
    end
    
    it "should change a player's score" do
      amount = 5
      type = :fame
      expect{
        board.change_player_score(player: @player1, amount: amount, type: type)
      }.should change(@player1, type).by(amount)
    end

    it "should level up the player when their score is high enough" do
      amount = 11
      type = :fame
      board.change_player_score(player: @player1, amount: amount, type: type)
      @player1.level.should == 2
    end

    it "should not level up the player if their score is not high enough" do
      amount = 10
      type = :riches
      board.change_player_score(player: @player1, amount: amount, type: type)
      @player1.level.should == 1
    end

    it "should level up the player multiple levels if the score warrants it" do
      amount = (1**2 + 10) + (2**2 + 10)
      type = :riches
      board.change_player_score(player: @player1, amount: amount, type: type)
      @player1.level.should == 3
    end

  end

end











