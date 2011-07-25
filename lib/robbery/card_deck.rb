module Robbery

  class CardDeck

    attr_reader :data
    
    def initialize(card_data=[])
      set_data(card_data)
    end

    def set_data(data)
      @data = data
    end

    def add_data(data)
      @data += data
    end

    def data_for_type(type)
      @data.select {|data| data[:type] == type}
    end

    def names(type, gang)
      @data.each_with_object([]) do |card, array|
        array << card[:text][gang][:name] if card[:type] == type
      end
    end
    
    def types
      @types ||= @data.map{|card| card[:type]}.uniq
    end
    
    def range_for_card(name)
      @data.each do |data|
        return data[:effect_range] if
        [data[:text][:gang][:name],
        data[:text][:pinkerton][:name]].include?(name)
      end
      nil
    end

    def draw(gang)
      Card.new(gang: gang, type: self.types.sample, deck: self)
    end

    def count
      @data.count
    end
    alias_method :length, :count
    
  end

end
