//
//  PTCGBattleActive.swift
//  PTCGPlayerBoard
//
//  Created by Eimer on 2021/04/20.
//

import Foundation

public struct PTCGBattleActiveZone {
    
    var battlePokemon: PTCGBattlePokemon?
    
    public init() {}
}

extension PTCGBattleActiveZone: PTCGZoneConvertible {
    
    public var switcher: PTCGZoneSwither {
        .battleActive(self)
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
        guard let card = cards.first else {
            return
        }
        switch card.switcher {
        case .battlePokemon(let battlePokemon):
            self.battlePokemon = battlePokemon
        case .deckCard(let card):
            self.battlePokemon = try? .init(with: card)
        }
    }
    
    public typealias OutputRequest = Void
    public mutating func output(_ request: Void) -> Array<PTCGZoneUnitConvertible> {
        []
    }
}
