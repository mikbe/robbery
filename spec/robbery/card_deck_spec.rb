require "spec_helper"

describe Robbery::CardDeck do

  let(:deck){Robbery::CardDeck.new(@sample_card_data)}

  it "should set card data" do
    deck = Robbery::CardDeck.new
    deck.set_data(@sample_card_data)
    deck.data.length.should == @sample_card_data.length
  end

  it "should add to card data" do
    deck = Robbery::CardDeck.new
    deck.set_data(@sample_card_data)
    deck.add_data(@sample_card_data)
    deck.data.length.should == @sample_card_data.length * 2
  end

  it "should create a deck given card data" do
    deck = Robbery::CardDeck.new(@sample_card_data)
    deck.count.should == @sample_card_data.length
  end

  it "should draw a card" do
    deck.draw(:gang).should be_a(Robbery::Card)
  end
  
end