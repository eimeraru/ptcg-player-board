//
//  PTCGPrize.swift
//  PTCGPlayerBoard
//
//  Created by Eimer on 2021/04/20.
//

import Foundation

public struct PTCGPrizeZone {
    
    var cards: Array<PTCGDeckCard> = []
    
    public init() {}
}

extension PTCGPrizeZone: PTCGZoneConvertible {
    
    public var switcher: PTCGZoneSwither {
        .prize(self)
    }
    
    public var all: Array<PTCGZoneUnitConvertible> {
        []
    }
    
    public typealias ReadRequest = Void
    public func read(_ request: Void) -> Array<PTCGZoneUnitConvertible> {
        []
    }
    
    public typealias InputRequest = Void
    public mutating func input(_ request: Void, of cards: Array<PTCGZoneUnitConvertible>) {
        let deckCards = cards.map { (card) -> Array<PTCGDeckCard> in
            switch card.switcher {
            case .deckCard(let unit):
                return [unit]
            case .battlePokemon(let unit):
                return unit.evolutionTree + unit.items + unit.energies
            }
        }.flatMap { $0 }
        self.cards.append(contentsOf: deckCards)
    }
    
    public typealias OutputRequest = Void
    public mutating func output(_ request: Void) -> Array<PTCGZoneUnitConvertible> {
        []
    }
}
