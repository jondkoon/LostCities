require_relative 'card'
require_relative 'hand'
require_relative 'deck'
require_relative 'player'

class LostCities
    def initialize(players)
        @players = players
    end

    def start
        @deck = Deck.new
        @players.each{|player| player.draw_cards(@deck) }
        @current_player = pick_first_player
    end

    def to_s
        hands = @players.map { |player| player.to_s }.join("\n\n") + "\n\n"
        "The current player is #{@current_player.name}\n\n" + hands
    end

    def pick_first_player
        @players[rand(2)]
    end
end

players = [
    Player.new("Jon"),
    Player.new("Julie")
]

game = LostCities.new(players)
game.start
puts game
