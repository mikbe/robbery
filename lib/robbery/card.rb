module Robbery
  
  class Card
    include Identifiable
    
    attr_accessor :type, :effect_amount, :effect_type, 
                  :name, :description, :placed

    def initialize(params={})
      @type = params[:type]
      return if @type == :intel

      deck = params[:deck]
      data = deck.data_for_type(@type)
      
      card            = data.sample
      @effect_amount  = card[:effect_range].to_a.sample
      @effect_type    = card[:effect_type]
    
      text            = card[:text][params[:gang]]
      @name           = text[:name]
      @description    = text[:description]
    end
  end
end

