require_relative 'stack'

class Player
    attr_reader :cards, :name

    def initialize(name)
        @name = name
        @cards = []
        @expedition_stacks = $suit_characters.keys.map { |suit| ExpeditionStack.new(suit) }
        @expedition_stacks_hash = Hash[@expedition_stacks.map {|s| [s.suit,s]}]
        @suit_values = Hash.new(0)
    end

    def place_card_phase
        high_suit = find_high_suit
        high_suit_value = @suit_values[high_suit]
        if high_suit_value >= 21
            low_card = find_low_card_of_suit high_suit
        end
        discard discard_calculation
    end

    def draw_card_phase
        @cards.push @game.deck.draw_card
    end

    def card_eligible?(card)
        top_card = @expedition_stacks_hash[card.suit].top_card
        top_value = top_card ? top_card.value : -1
        card.value > top_value
    end

    def discard_calculation
        low_suit = find_low_suit
        find_low_card_of_suit low_suit
    end

    def find_low_card_of_suit(suit)
        @cards.select{|card| card.suit == suit}.min
    end

    def find_low_suit
        @suit_values.sort.first[0]
    end

    def find_high_suit
        @suit_values.sort.last[0]
    end

    def turn_prep
        @eligible_cards = @cards.select{|card| card_eligible? card}
        @expedition_cards = @expedition_stacks.map{|s| s.cards}.flatten
        @cards_in_play = @eligible_cards + @expedition_cards

        @suit_values = Hash.new(0)
        @cards_in_play.each {|card| @suit_values[card.suit] += card.value }
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
        turn_prep

        place_card_phase
        draw_card_phase
    end

    def to_s
        "#{@name} holds(#{@cards.size}):  #{@cards.join("  ")}" +
        "\nexpedition stacks: #{@expedition_stacks}"
    end
end
