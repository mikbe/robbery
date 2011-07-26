# You need to create data for your cards. Cards are the meat of your game
# so make sure you create lots of them; make them fun and interesting.
#
# Card types
# You can use whatever card types you wish. This is just a convenience
# for the game rules designer. The designer could require at least one
# type for a train attack or not allow two types together.
# Some examples might be :equipment and :person.

# Card effect
# A range that will be used when the card value is randomly decided.

# Effect type
# :attack or :defense
# Attack cards are used against the other player's defense cards
# So a player should try to use both defense and attack.

# text
# Cards have different text for gangs and the pinkertons
# The fields should be self explanitory.

@sample_card_data = 
[
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
        "The base captain said you borrow some of their old guns."
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
        " jackets will protect you from bullets." +
        " He didn't offer to come along."
      },
      pinkerton:{
        name: "Experimental Bullet Repelling vests",
        description:
        "Pinkerton HQ wants you to try out some new" +
        " fangled bullet 'proof' vests."
      }
    }
  },
  {
    type: :person,
    effect_range: (2..4),
    effect_type: :defense,
    text: {
      gang:{
        name: "Eagle Eye'd Pete",
        description: "Pete will help protect your rear flank."
      },
      pinkerton:{
        name: "Doc Holliday",
        description: "Not just a good shot he can also fix your teeth."
      }
    }
  },
  {
    type: :person,
    effect_range: (2..4),
    effect_type: :attack,
    text: {
      gang:{
        name: "Billy the Kid",
        description: "The infamous gun slinger offers to join you for a heist."
      },
      pinkerton:{
        name: "Wyatt Earp",
        description:
        "The famous lawman offers to ride a long on one of your jobs."
      }
    }
  }
]