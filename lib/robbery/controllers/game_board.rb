module Robbery
  
  class GameBoard
    
    attr_reader :players
    
    def initialize
      
      @players = []
      
    end
    
    def add_player(params)
      
      @players << params
      
    end
    
  end
  
end