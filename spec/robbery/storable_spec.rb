require "spec_helper"

describe Robbery::Storable do
  
  let(:foos){Robbery::FooStorage.new}

  before(:each) do
    foos.add({name: "twing",  id: 0})
    foos.add({name: "splorp", id: 1})
    foos.add({name: "flamp",  id: 2})
    foos.add({name: "flamp",  id: 3})
  end

  it "should set a count of 0 when initialized" do
    foos = Robbery::FooStorage.new
    foos.count.should == 0
  end

  it "should set an index array from a single value" do
    foos.index = :id
    foos.index.should == [:id]
  end

  it "should set an index array from an array" do
    foos.index = [:name, :id]
    foos.index.should == [:name, :id]
  end

  context "when adding" do

    it "should increase the count" do
      expect{foos.add(name: "blah", id: 24)}.should change(foos, :count).by(1)
      puts
      puts
    end
    
    it "should not add items with a duplicate index" do
      foos.index = :id
      expect{foos.add(name: "wuppi",  id: 3)}.should_not change(foos, :count)
    end
    
  end
  
  context "when finding" do
  
    it "should find the first item using a field/value" do
      foos.find(name: "splorp").should == {name: "splorp", id: 1}
    end
  
    it "should find multiple items using a field/value" do
      foos.find_all(name: "flamp").should == 
      [{:name=>"flamp", :id=>2}, {:name=>"flamp", :id=>3}]
    end
  
    it "should not find things that aren't there" do
      foos.find(name: "bloop").should be_nil
    end
  
  end
  
  context "when removing items" do
  
    it "should remove things using the hash itself" do
      expect{foos.remove({name: "twing", id: 0})}.should 
      change(foos, :count).by(-1)
    end
  
    it "should not remove things that aren't there" do
      expect{foos.remove({name: "twing", id: 1})}.should_not 
      change(foos, :count)
    end
  
    it "should remove a thing using a field/value" do
      expect{foos.remove_with(id: 1)}.should change(foos, :count).by(-1)
    end
  
    it "should remove multiple thing using a field/value" do
      expect{foos.remove_with(name: "flamp")}.should change(foos, :count).by(-2)
    end
  
  end

end

module Robbery
  class FooStorage
    include Storable
  end
end