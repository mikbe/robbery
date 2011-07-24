require "spec_helper"

describe Robbery::CardDeck do

  let(:deck){Robbery::CardDeck.new}

  it "should draw the number of cards specified" do
    deck.draw(3, :gang).count.should == 3
  end

  it "should create different card types" do
    
  end


end