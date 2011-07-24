require "spec_helper"

describe Robbery::Identifiable do

  it "should create an id" do
    module ::Robbery
      class Foo
        include Identifiable
      end
    end
    foo = Robbery::Foo.new
    foo.should respond_to(:id)
  end

end