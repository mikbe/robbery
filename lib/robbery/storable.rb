require 'uuidtools'
module Robbery
  module Storable

    attr_reader :index
    
    def initialize
      @storage  = []
      @index    = []
    end

    def index=(values)
      @index = *values
    end

    def add(hash)
      unless @index.empty?
        return unless find_all(hash.select{|k,_| @index.include? k}).empty?
      end
      @storage << hash
    end

    def remove(hash)
      @storage.delete(hash)
    end

    def remove_with(search_params)
      find_all(search_params).each {|item| @storage.delete(item)}
    end

    def find_all(search_params)
      search_array = search_params.to_a
      @storage.select{|item| item.to_a & search_array == search_array}
    end

    def find(search_params)
      find_all(search_params).first
    end

    def count
      @storage.count
    end
    alias_method :length, :count

  end
end
