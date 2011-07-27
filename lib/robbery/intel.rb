module Robbery

  class Intel

    def generate_intel(params={})
      best_train_chance = params[:best_train_chance] || 0.3
      @players = params[:players]
      @trains  = params[:trains]
      @players.map do |player|
      {
        player: player,
        card: player.cards.select do |card|
          next unless card.type == :intel
          move_count = player.level * (params[:move_multiplyer] || 2)
          card.name, card.description =
            rand < best_train_chance ?
            best_train_intel(player: player, move_count: move_count) :
            player_intel(player: player, move_count: move_count)
        end.first
      }
      end
    end

    def player_intel(params)
      player      = params[:player]
      move_count  = params[:move_count]

      enemy_players = (@players - [player])

      enemy = enemy_players.sample
      enemy_cards = enemy.cards.clone
      while card = enemy_cards.delete(enemy_cards.sample)
        break if card.type != :intel && card.placed_on_train
      end

      train = card.placed_on_train
      power = enemy.power_on_train(train)

      ["Player Intel",
      "A bar keep told you that #{enemy.gang_name} " +
      "are on #{train.name} with a total power of " +
      "#{power[:defense] + power[:attack]}. " +
      "Move up to #{move_count} cards."]
    end

    def best_train_intel(params)
      player        = params[:player]
      move_count    = params[:move_count]
      most_valuable = @trains.max
      
      ["Most Valuable Train",
      "A clerk let slip that #{most_valuable.name} " +
      ", a #{most_valuable.type} train, is the most   " +
      "valuable with #{most_valuable.value} points. " +
      "Move up to #{move_count} cards."]
    end

  end

end
