# encoding: utf-8

class Card
    attr_reader :suit, :rank
    include Comparable

    $suit_characters = {
        spade: '♠',
        club: '♣',
        diamond: '♦',
        heart: '♥',
        hash: '#'
    }

    @@rank_characters = {
        0 => '*',
    }
    (2..10).each {|i| @@rank_characters[i] = i.to_s }

    def initialize(suit, rank)
        @suit = suit
        @rank = rank
    end

    def <=>(other)
        value <=> other.value
    end

    public
    def value
        @rank
    end

    def to_s
        @@rank_characters[@rank]+$suit_characters[@suit]
    end
end
