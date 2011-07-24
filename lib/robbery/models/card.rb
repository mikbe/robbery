module Robbery
  
  class Card
    include Identifiable
    
    attr_reader :type, :effect_amount, :effect_type, :name, :description

    def initialize(params={})
      deck            = params[:deck]
      @type           = params[:type]
      raise Exception, "Unknown type" unless data = deck.data_for_type(@type)
      
      card            = data.sample
      @effect_amount  = card[:effect_range].to_a.sample
      @effect_type    = card[:effect_type]
      
      text            = card[:text][params[:gang]]
      @name           = text[:name]
      @description    = text[:description]
    end
  end
end

