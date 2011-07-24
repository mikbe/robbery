require "spec_helper"

describe Robbery::Card do

  before(:all) do
    Robbery::Card.add_data(
      type: :weapon, 
      names: ["Gatling gun", "Shotgun", "Colt Revolver"],
      effect_range: (1..3),
      effect_type: :attack
    )
  end

  it "should create a card for which there is data" do
    card = Robbery::Card.new(type: :weapon)
    card.type.should == :weapon
  end

  it "should raise an exception for unknown card types" do
    expect{Robbery::Card.new(type: :foo)}.should raise_exception
  end

  it "should add card data for the whole class" do
    Robbery::Card.data.should == [
      {
        type: :weapon, 
        names: ["Gatling gun", "Shotgun", "Colt Revolver"],
        effect_range: (1..3),
        effect_type: :attack
      }
    ]

  end

  it "should set a name based on card type" do
    card = Robbery::Card.new(type: :weapon)
    card.name.should be_in(Robbery::Card.data_for_type(:weapon)[:names])
  end

  context "when creating weapon cards" do

    it "should set an effect amount within the range" do
      card = Robbery::Card.new(type: :weapon)
      card.effect.should be_within(
        Robbery::Card.data_for_type(:weapon)[:effect_range]
      )
    end

  end

end