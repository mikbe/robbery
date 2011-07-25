module Robbery
  class Train
    include Identifiable

    attr_reader :type, :cars, :value, :placed_cards

    def initialize(level=2)
      super
      @type  = [:cargo, :passenger].sample
      @cars  = rand(level * 2) + 1
      @value = rand(level * 3) + 1
      @placed_cards = {}
    end
    
    def place_card(params)
      player = params[:player]
      card   = params[:card]
      return unless card.placed.nil?

      @placed_cards[player] ||= []
      return if @placed_cards[player].count >= @cars
      
      card.placed = self
      @placed_cards[player] << params[:card]
    end

  end
end
