module Robbery

  class GameBoard

    attr_reader :players, :trains, :deck

    def initialize
      clear
    end

    def clear
      @players = []
      @trains  = []
      @deck    = nil
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

    def build_deck(deck_data)
      @deck = CardDeck.new(deck_data)
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
        break if enemy_train = enemy_player.engaging_trains.sample
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
