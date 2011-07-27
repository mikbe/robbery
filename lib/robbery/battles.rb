module Robbery

  class Battles

    def resolve(params)
      trains = params[:trains]
      players = params[:players]
      
      battle_results = []
      trains.each do |train|
        next if train.placed_cards.empty?

        players = train.players_on_train
        if players.count == 1
          battle_results << single_battle(train: train, gangs: players)
          next
        end

        gangs     = players.select{|player| player.gang == :gang}
        pinkerton = players - gangs

        while gangs.count > 1
          combatants  = gangs.sample(2)
          results     = single_battle(train: train, gangs: combatants)
          gangs.delete(results[:loser])
          battle_results << results
        end

        unless pinkerton.empty?
          gangs.concat pinkerton
          battle_results << single_battle(train: train, gangs: gangs)
        end
      end
      battle_results
    end

    private

    def roll_dice(gang, train)
      powers = gang.power_on_train(train)
      attack = rand(powers[:attack] + gang.level)
      defense = rand(powers[:defense] + gang.level)
      {attack: attack, defense: defense}
    end

    def single_battle(params)
      train = params[:train]
      player1, player2 = *params[:gangs]

      unless player1 && player2
        return {train: train, winner: player1 || player2, loser: nil}
      end

      one_attack    = false
      two_attack    = false
      loop_timeout  = 10
      while one_attack == two_attack
        player1_roll  = roll_dice(player1, train)
        player2_roll  = roll_dice(player2, train)
        one_attack    = player1_roll[:attack] > player2_roll[:defense]
        two_attack    = player2_roll[:attack] > player1_roll[:defense]

        if (loop_timeout -= 1) < 1
          one_attack, two_attack = [[false, true], [true, false]].sample
        end
      end

      winner, loser = one_attack ? [player1, player2] : [player2, player1]

      {train: train, winner: winner, loser: loser}

    end
  end
end
