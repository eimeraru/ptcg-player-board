//
//  PTCGDeck.swift
//  PTCGPlayerBoard
//
//  Created by Eimer on 2021/04/20.
//

import Foundation

public struct PTCGDeckZone {
    
    var cards: Array<PTCGDeckCard> = []
    
    public init() {}
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
    public mutating func input(_ request: Void, of cards: Array<PTCGZoneUnitConvertible>) {
        
    }
    
    public enum OutputAction {
        case draw(count: Int)
    }
    public typealias OutputRequest = OutputAction
    public mutating func output(_ request: OutputAction) -> Array<PTCGZoneUnitConvertible> {
        switch request {
        case .draw(count: let count):
            let cards = Array(self.cards[0 ..< count])
            self.cards.removeSubrange(0 ..< count)
            return cards
        }
    }
}
