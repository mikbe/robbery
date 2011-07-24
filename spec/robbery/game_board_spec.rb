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

  it "should add players" do
    board.add_player(name: "Fred", type: :gang, gang_name: "The Wilmas").should
      change(board, :players)
  end

  it "should "


end