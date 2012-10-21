require_relative 'stack'

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
        @suit_values = Hash.new(0)
        @discard_stack_hash = Hash[@game.discard_stacks.map{|s| [s.suit,s]}]
    end

    def turn_prep
        @eligible_cards = @cards.select{|card| card_eligible? card}
        @ineligible_cards = @cards.select{|card| not card_eligible? card}
        @expedition_cards = @expedition_stacks.map{|s| s.cards}.flatten
        @cards_in_play = @eligible_cards + @expedition_cards

        @suit_values = Hash.new(0)
        @cards_in_play.each {|card| @suit_values[card.suit] += card.value }

        @expedition_values = Hash.new(0)
        @expedition_cards.each {|card| @expedition_values[card.suit] += card.value }

        @cards_in_hand_by_suit = Hash.new([])
        @cards.each {|card| @cards_in_hand_by_suit[card.suit].push card }

        @just_discarded = nil
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
        card = draw_card_calculation
        if card
            @cards.push draw_from_discard(card.suit)
        else
            drew = @game.deck.draw_card
            @cards.push drew
        end
    end

    #Calculations
    def place_card_calculation
        turns_left = turns_left_calculation
        puts "turns_left: #{turns_left}"
        high_suit = find_high_suit_with_eligible_card
        high_suit_value = high_suit ? @suit_values[high_suit] : 0
        if (high_suit_value >= 31 and #wait for a certain number before starting an expedition
            (@expedition_stacks_hash[high_suit].size != 0 or #if you already started keep going
            turns_left >= @cards_in_hand_by_suit[high_suit].size)) #otherwise don't start if there is not enough turns left
                return find_low_card_of_suit(high_suit, @eligible_cards)
        end
    end

    def discard_calculation
        if @ineligible_cards.size > 0
            @ineligible_cards.first
        else
            find_low_card_of_suit find_low_suit_in_hand
        end
    end

    def draw_card_calculation
        eligible_to_pickup = @game.discard_stacks.map{|s| s.top_card}.select{|card| card_eligible? card and card != @just_discarded}
        eligible_to_pickup.select do |card| 
            @expedition_stacks_hash[card.suit].size > 0 or @suit_values[card.suit] + card.value >= 16
        end.sort_by do |card|
            card.value
        end.last
    end

    def turns_left_calculation
        cards_drawn = 44 - @game.deck.size
        return 60 if cards_drawn < 20
        average_turns_per_card = @game.turns / cards_drawn.to_f
        turns_left = (@game.deck.size * average_turns_per_card) / 2 
        p turns_left
        turns_left.floor
    end

    #Helpers
    def suit_eligible?(suit)
        return false unless suit
        @eligible_cards.any?{|card| card.suit == suit }
    end

    def card_eligible?(card)
        return false unless card
        top_value = @expedition_stacks_hash[card.suit].top_value
        card.value > top_value or (top_value == 0 and card.value == 0)
    end

    def find_low_card_of_suit(suit, cards=@cards)
        cards.select{|card| card.suit == suit}.min_by{|card| card.value}
    end

    def find_low_suit_in_hand
        @suit_values.sort_by{|k,v| v}.each do |suit,v|
            return suit if @cards.any?{|card| card.suit == suit }
        end
    end

    def find_high_suit_with_eligible_card
        @suit_values.sort_by{|k,v| v}.reverse_each do |suit,v|
            return suit if suit_eligible? suit
        end
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
