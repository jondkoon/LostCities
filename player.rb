require_relative 'stack'
require_relative 'player'

class Player
    attr_reader :cards, :name

    def initialize(name)
        @name = name
    end

    def game_prep(game)
        @game = game
        @cards = []
        @expedition_stacks = $suit_characters.keys.map { |suit| ExpeditionStack.new(suit) }
        @expedition_stacks_hash = Hash[@expedition_stacks.map {|s| [s.suit,s]}]
        @discard_stack_hash = Hash[@game.discard_stacks.map{|s| [s.suit,s]}]
    end

    def turn_prep
        @just_discarded = nil
    end

    def place_card_phase
        raise "Not Implemented"
    end

    def draw_card_phase
        raise "Not Implemented"
    end

    #Helpers
    def card_eligible?(card)
        return false unless card
        top_value = @expedition_stacks_hash[card.suit].top_value
        card.value > top_value or (top_value == 0 and card.value == 0)
    end

    #Actions
    def draw_cards(deck)
        @cards = deck.draw_cards(8)
    end

    def draw_from_discard(suit)
        @discard_stack_hash[suit].draw_card
    end

    def discard(card)
        @just_discarded = card
        @discard_stack_hash[card.suit].place_card card
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
        game_prep(game)
        draw_cards(game.deck)
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
