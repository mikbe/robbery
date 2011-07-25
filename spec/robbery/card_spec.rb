require "spec_helper"

describe Robbery::Card do

  let(:deck){Robbery::CardDeck.new(@sample_card_data)}

  it "should create a card with card data" do
    card = Robbery::Card.new(
      deck: deck, 
      type: :equipment, 
      gang: :pinkerton
    )
    card.type.should == :equipment
  end

  it "should set a name based on card type" do
    card = Robbery::Card.new(deck: deck, type: :equipment, gang: :gang)
    card.name.should be_in(deck.names(:equipment, :gang))
  end

  it "should set a name based on gang or pinkerton" do
    card = Robbery::Card.new(deck: deck, type: :equipment, gang: :pinkerton)
    card.name.should be_in(deck.names(:equipment, :pinkerton))
  end

  it "should set an effect amount within the range" do
    card = Robbery::Card.new(deck: deck, type: :equipment, gang: :pinkerton)
    card.effect_amount.should be_within(deck.range_for_card(card.name))
  end

end

