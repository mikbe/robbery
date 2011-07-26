module Robbery
  class Player
    include Identifiable
    attr_reader :name, :gang, :gang_name, :cards, :level, :fame, :riches

    def initialize(params)
      super
      @name       = params[:name]
      @gang       = params[:gang]
      @gang_name  = params[:gang_name]
      @cards      = []
      @level      = 1
      @fame       = 1
      @riches     = 0
    end

    def draw_card(deck, type=nil)
      if cards.none?{|card| card.type == :intel}
        type = :intel unless type || rand(0) > 0.2
      elsif type == :intel
        type = nil
      end
      card = deck.draw(@gang, type)
      card.player = self
      @cards << card
      card
    end

    def engaged_trains
      cards.each_with_object([]) do |card, trains|
        next if card.type == :intel || !card.placed_on_train
        trains << card.placed_on_train
      end.uniq
    end

    def cards_on_train(train)
      @cards.select{|card| card.placed_on_train == train}.compact
    end

    def power_on_train(train)
      cards_on_train(train).each_with_object({defense: 0, attack: 0}) do 
      |card, power|
        power[:defense] += card.defense
        power[:attack]  += card.attack
      end
    end

  end
end
