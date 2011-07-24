require 'uuidtools'
module Robbery
  module Identifiable
    attr_reader :id
    def initialize
      @id = UUIDTools::UUID.timestamp_create
    end
  end
end
