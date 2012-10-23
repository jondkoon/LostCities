require_relative 'card'
require_relative 'deck'
require_relative 'computer'
require_relative 'human'
require_relative 'stack'

class LostCities
    attr_reader :deck, :discard_stacks, :turns

    def initialize(players)
        @players = players
    end

    def start
        @turns = 0
        @deck = Deck.new
        @discard_stacks = $suit_characters.keys.map { |suit| Stack.new(suit) }
        @current_player = pick_first_player
        @players.each{|player| player.start_game(self)}
        while @deck.size > 0 do
            puts self
            @current_player.turn
            @current_player = @players.find{|player| player != @current_player}
            @turns += 1
        end
        done
    end

    def done
        puts self
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
        current_player = "\n#{@current_player.name}'s turn"
        discard = "Discard #{@discard_stacks}"
        deck = "Deck(#{@deck.size})"
        "#{current_player} -- #{deck}\n#{discard}\n\n#{hands}"
    end
end

players = [
    Human.new("Jon"),
    Computer.new("Julie")
]

game = LostCities.new(players)
game.start

#high_score_sum = 0
#turns_sum = 0
#games_to_play = 1000
#all_time_high = 0
#high_score_game = ""
#games_to_play.times do
#    game.start
#    high_score_sum += game.high_score
#    turns_sum += game.turns
#    if game.high_score > all_time_high
#        all_time_high = game.high_score
#        high_score_game = game.to_s
#    end
#end
#high_score_average = high_score_sum/games_to_play
#turns_average = turns_sum/games_to_play
#points_per_turn_average = high_score_average.to_f / turns_average
#
#
#puts "High score average is #{high_score_average}"
#puts "Turns average is #{turns_average}"
#puts "Point per turn average is #{points_per_turn_average}"
#puts "All time high score is #{all_time_high}"
#puts high_score_game
