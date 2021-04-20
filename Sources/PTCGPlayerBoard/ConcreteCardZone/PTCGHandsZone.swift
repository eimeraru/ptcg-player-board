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
        []
    }
    
    public typealias ReadRequest = Void
    public func read(_ request: Void) -> Array<PTCGZoneUnitConvertible> {
        []
    }
    
    public typealias InputRequest = Void
    public mutating func input(_ request: Void, of cards: Array<PTCGZoneUnitConvertible>) {
        
    }
    
    public typealias OutputRequest = Void
    public mutating func output(_ request: Void) -> Array<PTCGZoneUnitConvertible> {
        []
    }
}
