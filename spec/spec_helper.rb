$:.unshift File.expand_path(File.join(File.dirname(__FILE__), "/../lib"))
$: << '.'

require 'rspec'
require 'robbery'

RSpec::Matchers.define :be_in do |collection|
  match do |value|
    collection.include? value
  end

  failure_message_for_should do |value|
    "expected #{collection} to include #{value.inspect}"
  end

end

RSpec::Matchers.define :be_within do |range|
  match do |value|
    range.include? value
  end

  failure_message_for_should do |value|
    "expected #{value} to be within the range #{range.inspect}"
  end

end