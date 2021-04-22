//
//  PTCGHands.swift
//  PTCGPlayerBoard
//
//  Created by Eimer on 2021/04/20.
//

import Foundation

public struct PTCGHandsZone {
    
    var cards: Array<PTCGDeckCard> = []
    
    public init() {}
}

extension PTCGHandsZone: PTCGZoneConvertible {
    
    public var switcher: PTCGZoneSwither {
        .hands(self)
    }
    
    public var all: Array<PTCGZoneUnitConvertible> {
        cards
    }
    
    public typealias ReadRequest = Void
    public func read(_ request: Void) -> Array<PTCGZoneUnitConvertible> {
        all
    }
    
    public typealias InputRequest = Void
    public mutating func input(_ request: Void, of unitSet: Array<PTCGZoneUnitConvertible>) throws {
        self.cards.append(contentsOf: unitSet.compactMap(toDeckCard()))
    }
    
    public enum OutputAction {
        case selectAll
        case select(index: Int)
    }
    public typealias OutputRequest = OutputAction
    public mutating func output(_ request: OutputRequest) throws -> Array<PTCGZoneUnitConvertible> {
        switch request {
        case .selectAll:
            let cards = self.cards
            self.cards = []
            return cards
        case .select(let index):
            self.cards.remove(at: index)
            return [cards[index]]
        }
    }
}
