require 'uuidtools'
module Robbery
  module Identifiable
    attr_reader :id
    def initialize(*params)
      @id = UUIDTools::UUID.random_create
    end
  end
end
