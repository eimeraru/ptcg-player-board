//
//  PTCGDeck.swift
//  PTCGPlayerBoard
//
//  Created by Eimer on 2021/04/20.
//

import Foundation

public struct PTCGDeckZone {
    
    var cards: Array<PTCGDeckCard> = [] {
        willSet {
            self.cardStorage = newValue.reduce(into: Dictionary<String, PTCGDeckCard>()) { (result, card) in
                result[card.identifier] = card
            }
        }
    }
    private var cardStorage: Dictionary<String, PTCGDeckCard> = [:]
    
    public init() {}

    /**
     * 山札をシャッフルする
     */
    public mutating func shuffle(_ id: String? = nil) {
        guard let id = id else {
            cards = cards.shuffled()
            return
        }
        let sortedIdSet = id.map(String.init).sorted()
        let sortedCardIdSet = cards.map({ $0.identifier }).sorted()
        guard sortedIdSet == sortedCardIdSet else {
            cards = cards.shuffled()
            return
        }
        cards = id.compactMap { (c) in
            cardStorage[String(c)]
        }
    }
}

extension PTCGDeckZone: PTCGZoneConvertible {
    
    public var switcher: PTCGZoneSwither {
        .deck(self)
    }
    
    public var all: Array<PTCGZoneUnitConvertible> {
        []
    }
    
    public typealias ReadRequest = Void
    public func read(_ request: Void) -> Array<PTCGZoneUnitConvertible> {
        []
    }
    
    public typealias InputRequest = Void
    public mutating func input(_ request: Void, of unitSet: Array<PTCGZoneUnitConvertible>) throws {
        
    }
    
    public enum OutputAction {
        case draw(count: Int)
    }
    public typealias OutputRequest = OutputAction
    public mutating func output(_ request: OutputAction) throws -> Array<PTCGZoneUnitConvertible> {
        switch request {
        case .draw(count: let count):
            let cards = Array(self.cards[0 ..< count])
            cards.forEach { (card) in
                cardStorage[card.identifier] = nil
            }
            self.cards.removeSubrange(0 ..< count)
            return cards
        }
    }
}
