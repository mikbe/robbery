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

  let(:board){Robbery::GameBoard.new}

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
    
  end

  context "when placing cards" do

    before(:each) do
      @player1 = board.add_player(
        name: "Fred", 
        gang: :gang, 
        gang_name: "The Wilmas"
      )
      board.build_deck(@sample_card_data)
      board.build_trains
      board.draw_cards(player: @player1, count: 3)
    end

    it "should place snakes on a plane, I mean cards on a train" do
      board.place_card(
        player: @player1, 
        card: @player1.cards.first,
        train: board.trains.first
      )
      board.trains.first.placed_cards[@player1].should == [@player1.cards.first]
    end
    
    it "should not place the same card twice" do
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
      board.trains.last.placed_cards[@player1].should be_nil
    end
    
  end

end











