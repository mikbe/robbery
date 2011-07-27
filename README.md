# The Great Train Robbery Engine

TGTRE is a card game engine that lets you write exciting Old West train robbery games!  

One player plays the Pinkerton security company and acts as the police for the railroads. Other players play gang leaders and try to rob the trains for loot and infamy.  

One of the interesting dynamics of the game is the Pinkerton player gets more resources but they also have to protect all of the trains.  

## Usage
You'll need to know some Ruby but the engine is fairly simple.  

The basic game turns would follow this outline:  

* Create a Robbery::Game object.
* Add some players.
* Generate trains. (game turn loop starts here)
* Draw cards for players.
* Let players place their cards in secret.
* Process intel cards and let players move if they have one.
* Reveal the cards and do battle.
* Show the battle results and update the winners' scores.
* Check for victory conditions and if not start over at generate trains.

The best way to understand how to use the engine is to take a look at the `examples/example_game.rb` file. It will walk you through configuring a game and what's involved in a turn.
