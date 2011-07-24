module Robbery
  
  class Card

    attr_reader :type, :effect, :name

    # data functions - use these to load card data from your database
    class << self
      attr_reader :data
    end
    @data = []

    def self.add_data(data)
      @data << data
    end

    def self.data_for_type(type)
      @data.select {|data| data[:type] == type}.first
    end

    # instance methods

    def initialize(params={})
      @type   = params[:type]
      raise Exception, "Unknown card type" unless data = data_for_type(@type)
      @effect = data[:effect_range].to_a.sample
      @name   = data[:names].sample
    end

    def data_for_type(type)
      self.class.data_for_type(@type)
    end

  end
end

