module Robbery

  class GameBoard

    attr_reader :players, :trains, :deck

    def initialize(params)
      reset
      build_deck(params[:card_data])
    end

    def reset
      @players = []
      @trains  = []
    end

    def start_turn
      build_trains
    end

    def resolve_battles
      battle_results = []
      @trains.each do |train|
        next unless train.placed_cards

        players = train.players_on_train

        gangs = players.select{|player| player.gang == :gang}
        pinkerton = players - gangs

        while gangs.count > 1
          battle_results << resolve_battle(train: train, gangs: gangs.sample(2))
        end
        
        unless pinkerton.empty?
          gangs.concat pinkerton
          battle_results << resolve_battle(train: train, gangs: gangs)
        end

      end
      battle_results
    end

    # refactor: algorithm should be injectable, play balance
    def resolve_battle(params)
      train = params[:train]
      gang1, gang2 = *params[:gangs]

      one_on_two = false
      two_on_one = false
      while one_on_two == two_on_one
        gang1_roll = roll_dice(gang1, train)
        gang2_roll = roll_dice(gang2, train)
        one_on_two = gang1_roll[:attack] > gang2_roll[:defense]
        two_on_one = gang2_roll[:attack] > gang1_roll[:defense]
      end
      
      winner = one_on_two ? gang1 : gang2
      loser = gang1 == winner ? gang2 : gang1

      {
         train: train,
        winner: winner,
         loser: loser,
        reward: train.value
      }

    end

    def roll_dice(gang, train)
      powers = gang.power_on_train(train)
      attack = rand(powers[:attack] + gang.level)
      defense = rand(powers[:defense] + gang.level)
      {attack: attack, defense: defense}
    end

    def add_player(params)
      return if @players.any?{|player| player.gang_name == params[:gang_name]}
      (@players << Player.new(params)).last
    end

    def build_trains
      # This logic should be injectable, not hardcoded
      level = @players.map{|player| player.level}.inject(:+)
      @trains = (@players.count * 3).times.collect {Train.new(level)}
    end

    def build_deck(card_data)
      @deck = CardDeck.new(card_data)
    end

    def draw_cards(params)
      count = params[:count] || 1
      count.times.map{params[:player].draw_card(@deck, params[:type])}
    end

    def place_card(params)
      return if params[:card].type == :intel
      params.delete(:train).place_card(params)
    end

    def player_cards(type=nil)
      cards = @players.map{|player| player.cards}.flatten
      cards.select!{|card| card.type == type} if type
      cards.compact
    end

    # refactor into a class
    # inject intel messages and logic instead of hardcoding
    def generate_intel
      @players.map do |player|
        player.cards.select do |card|
          next unless card.type == :intel
          card.name, card.description =
            rand < 0.3 ?
            best_train_intel(player) :
            player_intel(player)
        end
      end
    end

    private

    def player_intel(player)
      name = "Player Intel"
      description = "What a waste, no one has any intel."

      enemy_players = (@players - [player])
      enemy_train = nil
      while enemy_player = enemy_players.sample
        break if enemy_train = enemy_player.engaged_trains.sample
        enemy_players.delete(enemy_player)
      end
      return [name, description] unless enemy_player

      power = enemy_player.power_on_train(enemy_train)

      [name,
      "A bar keep told you that #{enemy_player.gang_name} " +
      "are on #{enemy_train.name} with a total power of " +
      "#{power[:defense] + power[:attack]}. " +
      "Move up to #{player.level * 2} cards."]
    end

    def best_train_intel(player)
      most_valuable = @trains.max
      ["Most Valuable Train",
      "A clerk let slip that #{most_valuable.name} " +
      ", a #{most_valuable.type} train, is the most   " +
      "valuable with #{most_valuable.value} points. " +
      "Move up to #{player.level * 2} cards."]
    end

  end

end
