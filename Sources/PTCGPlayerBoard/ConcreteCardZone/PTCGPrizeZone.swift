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
        cards
    }
    
    public typealias ReadRequest = Void
    public func read(_ request: ReadRequest) -> Array<PTCGZoneUnitConvertible> {
        all
    }
    
    public typealias InputRequest = Void
    public mutating func input(_ request: InputRequest, of unitSet: Array<PTCGZoneUnitConvertible>) {
        let deckCards = unitSet.compactMap(toDeckCards()).flatMap({ $0 })
        self.cards.append(contentsOf: deckCards)
    }
    
    public enum OutputAction {
        case select(index: Int)
    }
    public typealias OutputRequest = OutputAction
    public mutating func output(_ request: OutputRequest) -> Array<PTCGZoneUnitConvertible> {
        switch request {
        case .select(let index):
            cards.remove(at: index)
            return [cards[index]]
        }
    }
}
