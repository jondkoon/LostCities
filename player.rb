require_relative 'stack'

class Player
    include Comparable
    attr_reader :hand, :name

    def initialize(name)
        @name = name
        @expedition_stacks = $suit_characters.keys.map { |suit| ExpeditionStack.new(suit) }
    end

    def <=>(other)
        @hand <=> other.hand
    end

    def place_card_phase
        card = @hand.pop
        discard = @game.discard_stacks.find{|d| d.suit == card.suit }
        discard.place_card card
    end

    def draw_card_phase
        @hand.add_card @game.deck.draw_card
    end

    def draw_cards(deck)
        @hand = Hand.new(deck.draw_cards(8))
    end

    public
    def start_game(game)
        @game = game
        draw_cards(@game.deck)
    end

    def turn
        place_card_phase
        draw_card_phase
    end

    def to_s
        "#{@name} holds:\n#{@hand}" +
        "\n\nexpedition stacks: #{@expedition_stacks}"
    end
end
