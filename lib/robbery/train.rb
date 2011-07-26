module Robbery
  class Train
    include Identifiable

    attr_reader :name, :type, :cars, :value, :placed_cards

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

      @placed_cards[player] ||= []
      return if @placed_cards[player].count >= @cars
      
      remove_card(card) if card.placed_on_train
      card.placed_on_train = self

      @placed_cards[player] << params[:card]
      card
    end

    def players_on_train
      @placed_cards.keys
    end

    def name
      "Train ##{@number}"
    end

    def <=>(other)
      self.value <=> other.value
    end

    def remove_all_cards
      while card = placed_cards.first
        remove_card(card)
      end
    end

    def remove_card(card)
      card.placed_on_train = nil
      @placed_cards.delete(card)
    end

  end
end
