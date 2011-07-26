module Robbery

  class Card
    include Identifiable

    attr_accessor :type, :effect_amount, :effect_type,
                  :name, :description, :placed_on_train,
                  :player

    def initialize(params={})
      @player = params[:player]
      @type   = params[:type]
      return if @type == :intel

      deck = params[:deck]
      data = deck.data_for_type(@type)

      card            = data.sample
      @effect_amount  = card[:effect_range].to_a.sample
      @effect_type    = card[:effect_type]

      text            = card[:text][params[:gang]]
      @name           = text[:name]
      @description    = text[:description]
      
      @description   += " Adds +#{@effect_amount} to #{@effect_type}"
      
    end
    
    def defense
      @effect_type == :defense ? @effect_amount : 0
    end
    
    def attack
      @effect_type == :attack ? @effect_amount : 0
    end
    
  end
end

