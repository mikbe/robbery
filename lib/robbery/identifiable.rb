require 'uuidtools'
module Robbery
  module Identifiable
    
    # don't use this threaded
    @global_count = 0
    def self.increment_global_count
      @global_count += 1
    end
    
    attr_reader :id, :number
    def initialize(*params)
      @class_count ||= 0
      @id = UUIDTools::UUID.random_create
      @number = Identifiable.increment_global_count
    end
  end
end
