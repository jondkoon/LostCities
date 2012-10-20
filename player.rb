require_relative 'stack'

class Player
    attr_reader :cards, :name

    def initialize(name)
        @name = name
        @cards = []
        @expedition_stacks = $suit_characters.keys.map { |suit| ExpeditionStack.new(suit) }
    end

    def place_card_phase
        discard discard_calculation
    end

    def draw_card_phase
        @cards.push @game.deck.draw_card
    end

    def discard_calculation
        low_suit = find_low_suit
        low_card = find_low_card_of_suit low_suit
        low_card
    end

    def find_low_card_of_suit(suit)
        @cards.select{|card| card.suit == suit}.min
    end

    def find_low_suit
        @suit_values.sort.first[0]
    end

    def calc_suit_values
        @suit_values = Hash.new(0)
        @cards.each {|card| @suit_values[card.suit] += card.value }
    end

    def discard(card)
        puts "-- Discarding #{card}"
        discard_stack = @game.discard_stacks.find{|d| d.suit == card.suit }
        discard_stack.place_card card
        @cards.delete_if {|c| c.value == card.value and c.suit == card.suit }
    end

    def draw_cards(deck)
        @cards = deck.draw_cards(8)
    end

    public
    def start_game(game)
        @game = game
        draw_cards(@game.deck)
    end

    def turn
        calc_suit_values

        place_card_phase
        draw_card_phase
    end

    def to_s
        "#{@name} holds(#{@cards.size}):  #{@cards.join("  ")}" +
        "\nexpedition stacks: #{@expedition_stacks}"
    end
end
