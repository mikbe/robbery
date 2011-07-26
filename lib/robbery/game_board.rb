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

    def roll_dice(gang, train)
      powers = gang.power_on_train(train)
      attack = rand(powers[:attack] + gang.level)
      defense = rand(powers[:defense] + gang.level)
      {attack: attack, defense: defense}
    end

    def add_player(params)
      return if @players.any?{|player| player.gang_name == params[:gang_name]}
      return if @players.any?{|player| player.gang == :pinkerton}
      (@players << Player.new(params)).last
    end

    def add_players(*players)
      players.collect{|player| add_player(player)}
    end
    
    def build_trains(count=@players.count * 2)
      level = @players.map{|player| player.level}.inject(:+)
      @trains = count.times.collect {Train.new(level)}
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
    # inject intel messages instead of hardcoding
    def generate_intel(params={})
      best_train_chance = params[:best_train_chance] || 0.3
      @players.map do |player|
      {
          player: player,
          cards: player.cards.select do |card|
          next unless card.type == :intel
          move_count = player.level * (params[:move_multiplyer] || 2)
          card.name, card.description =
            rand < best_train_chance ?
            best_train_intel(player: player, move_count: move_count) :
            player_intel(player: player, move_count: move_count)
        end
      }
      end
    end

    def change_player_score(params)
      player = params.delete(:player)
      player.level_up(params)
    end

    private

    def player_intel(params)

      player = params[:player]
      move_count = params[:move_count]
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
      "Move up to #{move_count} cards."]
    end

    def best_train_intel(params)
      player = params[:player]
      move_count = params[:move_count]
      most_valuable = @trains.max
      ["Most Valuable Train",
      "A clerk let slip that #{most_valuable.name} " +
      ", a #{most_valuable.type} train, is the most   " +
      "valuable with #{most_valuable.value} points. " +
      "Move up to #{move_count} cards."]
    end

    def resolve_battle(params)
      train = params[:train]
      player1, player2 = *params[:gangs]

      one_attack    = false
      two_attack    = false
      loop_timeout  = 10
      while one_attack == two_attack
        player1_roll  = roll_dice(player1, train)
        player2_roll  = roll_dice(player2, train)
        one_attack    = player1_roll[:attack] > player2_roll[:defense]
        two_attack    = player2_roll[:attack] > player1_roll[:defense]

        if (loop_timeout -= 1) < 1
          one_attack, two_attack = [[false, true], [true, false]].sample
        end
      end

      winner, loser = one_attack ? [player1, player2] : [player2, player1]

      {train: train, winner: winner, loser: loser}

    end

  end

end
