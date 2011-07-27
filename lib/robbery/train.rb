module Robbery
  class Train
    
    # don't use this threaded
    @train_count = 0
    def self.train_count
      @train_count += 1
    end

    attr_reader :name, :type, :cars, :value, :placed_cards

    def initialize(level=2)
      super
      @type  = [:cargo, :passenger].sample
      @cars  = rand(level * 2) + 1
      @value = rand(level * 3) + 1
      @placed_cards = {}
      @number = Train.train_count
    end

    def place_card(params)
      player = params[:player]
      card   = params[:card]

      @placed_cards[player] ||= []
      return if @placed_cards[player].count >= @cars
      
      if existing_train = card.placed_on_train
        existing_train.remove_card(card)
      end
      card.placed_on_train = self

      @placed_cards[player] << card
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
