module Robbery

  class Game

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
      battles = Battles.new
      battles.resolve(players: players, trains: trains)
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

    def generate_intel(params={})
      intel = Intel.new
      intel.generate_intel(params.merge(players: players, trains: trains))
    end

    def change_player_score(params)
      player = params.delete(:player)
      player.level_up(params)
    end

  end

end
