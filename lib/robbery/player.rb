module Robbery
  class Player
    include Identifiable
    attr_reader :name, :gang, :gang_name, :cards, :level, :fame, :riches
    
    def initialize(params)
      super
      @name       = params[:name]
      @gang       = params[:gang]
      @gang_name  = params[:gang_name]
      @cards       = []
      @level      = 1
      @fame       = 1
      @riches     = 0
    end
    
    def draw_card(deck)
      if rand(0) < 0.2 && cards.none?{|card| card.type == :intel}
        @cards << Card.new(type: :intel)
      else
        @cards << deck.draw(@gang)
      end
    end
    
  end
end
