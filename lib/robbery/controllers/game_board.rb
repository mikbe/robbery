module Robbery

  class GameBoard

    attr_reader :players, :trains

    def initialize
      @players = Players.new
      @trains  = Trains.new
    end

    def add_player(params)
      # return if @players.find(
      #   name: params[:name], 
      #   gang_name: params[:gang_name]
      # )
      # @players.add(params)
    end

    def make_trains
      @train = Array.new(@players.length * 3)
    end

  end
  
end