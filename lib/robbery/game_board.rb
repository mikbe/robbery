module Robbery

  class GameBoard

    attr_reader :players, :trains, :deck

    def initialize
      @players = []
      @trains  = []
      @deck    = nil
    end

    def add_player(params)
      (@players << Player.new(params)).last
    end

    def build_trains
      # The logic should be injectable, not hardcoded
      level = @players.map{|player| player.level}.inject(:+)
      @trains = (@players.count * 3).times.collect {Train.new(level)}
    end

    def build_deck(deck_data)
      @deck = CardDeck.new(deck_data)
    end

    def draw_cards(params)
      params[:count].times {params[:player].draw_card(@deck)}
    end

    def place_card(params)
      params.delete(:train).place_card(params)
    end

  end

end