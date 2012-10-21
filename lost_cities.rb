require_relative 'card'
require_relative 'deck'
require_relative 'player'
require_relative 'stack'

class LostCities
    attr_reader :deck, :discard_stacks

    def initialize(players)
        @players = players
    end

    def start
        @deck = Deck.new
        @discard_stacks = $suit_characters.keys.map { |suit| Stack.new(suit) }
        @players.each{|player| player.start_game(self)}
        @current_player = pick_first_player
        while @deck.size > 0 do
            @current_player.turn
            @current_player = @players.find{|player| player != @current_player}
        end
        done
    end

    def done
        @players.each do |player|
            puts "#{player.name}'s score is #{player.score}"
        end
    end

    def high_score
        @players.map{|p| p.score}.max
    end

    def pick_first_player
        @players[rand(2)]
    end

    def to_s
        hands = @players.map { |player| player.to_s }.join("\n\n") + "\n"
        current_player = "\nThe current player is #{@current_player.name}"
        discard = "Discard #{@discard_stacks}"
        deck = "Deck(#{@deck.size})"
        "#{current_player} -- #{deck}\n#{discard}\n\n#{hands}"
    end
end

players = [
    Player.new("Jon"),
    Player.new("Julie")
]

game = LostCities.new(players)
high_score_sum = 0
games_to_play = 1000
games_to_play.times do
    game.start
    high_score_sum += game.high_score
end
puts "High score average #{high_score_sum/games_to_play}"
