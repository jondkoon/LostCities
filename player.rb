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

    def turn_prep
        @eligible_cards = @cards.select{|card| card_eligible? card}
        @ineligible_cards = @cards.select{|card| not card_eligible? card}
        @expedition_cards = @expedition_stacks.map{|s| s.cards}.flatten
        @cards_in_play = @eligible_cards + @expedition_cards

        @suit_values = Hash.new(0)
        @cards_in_play.each {|card| @suit_values[card.suit] += card.value }
    end

    def place_card_phase
        card = place_card_calculation

        if card
            place_card card
        else
            discard discard_calculation
        end
    end

    def draw_card_phase
        @cards.push @game.deck.draw_card
    end

    #Calculations
    def place_card_calculation
        high_suit = find_high_suit_with_eligible_card
        high_suit_value = high_suit ? @suit_values[high_suit] : 0
        if high_suit_value >= 21
            return find_low_card_of_suit(high_suit, @eligible_cards)
        end
    end

    def discard_calculation
        if @ineligible_cards.size > 0
            @ineligible_cards.first
        else
            low_suit = find_low_suit
            find_low_card_of_suit low_suit
        end
    end

    #Helpers
    def suit_eligible?(suit)
        @eligible_cards.any?{|card| card.suit == suit }
    end

    def card_eligible?(card)
        top_value = @expedition_stacks_hash[card.suit].top_value
        card.value > top_value or (top_value == 0 and card.value == 0)
    end

    def find_low_card_of_suit(suit, cards=@cards)
        cards.select{|card| card.suit == suit}.min
    end

    def find_low_suit
        @suit_values.sort.first[0]
    end

    def find_high_suit_with_eligible_card
        @suit_values.sort.reverse_each do |suit,v|
            return suit if suit_eligible? suit
        end
    end

    #Actions
    def draw_cards(deck)
        @cards = deck.draw_cards(8)
    end

    def discard(card)
        discard_stack = @game.discard_stacks.find{|d| d.suit == card.suit }
        discard_stack.place_card card
        delete_card card
    end

    def place_card(card)
        expedition_stack = @expedition_stacks_hash[card.suit]
        expedition_stack.place_card card
        delete_card card
    end

    def delete_card(card)
        @cards.delete_at(@cards.index(card))
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

    def score
        @expedition_stacks.reduce(0) {|sum, s| sum + s.score}
    end

    def to_s
        "#{@name} holds(#{@cards.size}):  #{@cards.join("  ")}" +
        "\nexpedition stacks: #{@expedition_stacks}"
    end
end
