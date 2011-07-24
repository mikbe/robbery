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

RSpec.configure do |config|
  config.before(:all) do
    @sample_card_data = [
      {
        type: :equipment, 
        effect_range: (2..4),
        effect_type: :attack,
        text: {
          gang: {
            name: "Stolen Gatling", 
            description: "You 'liberated' a gatling gun from the Army armory."
          },
          pinkerton: {
            name: "Gatling gun",
            description: 
            "That requisition you filled out last year finally came in!"
          }
        }
      },
      {
        type: :equipment, 
        effect_range: (1..2),
        effect_type: :attack,
        text: {
          gang:{
            name: "Indian Carbines", 
            description: 
            "A Native American arms dealer gave you a deal on some used guns."
          },
          pinkerton:{
            name: "Army Carbines",
            description: 
            "The base captain said you have their old."
          }
        }
      },
      {
        type: :equipment, 
        effect_range: (1..2),
        effect_type: :defense,
        text: {
          gang:{
            name: "Heavy Wool Jackets", 
            description: 
            "Your crazy inventor cousin said these wool" +
            " jackets protect you from bullets." +
            "He didn't offer to come along."
          },
          pinkerton:{
            name: "Experimental Bullet Repellent vests",
            description: 
            "Pinkerton HQ wants you to try out some new " +
            "fangled bullet 'proof' vests."
          }
        }
      }
    ]
  end
end