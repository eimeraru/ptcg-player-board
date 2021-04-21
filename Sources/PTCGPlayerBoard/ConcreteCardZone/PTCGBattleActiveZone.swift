//
//  PTCGBattleActive.swift
//  PTCGPlayerBoard
//
//  Created by Eimer on 2021/04/20.
//

import PTCGCard
import PTCGEnergy

public struct AnyPTCGEnergyCard: PTCGEnergyCard {

    public var capacity: Int {
        base.capacity
    }

    public var energies: Array<PTCGEnergy> {
        base.energies
    }

    public var id: String {
        base.id
    }

    public var name: String {
        base.name
    }

    public var category: PTCGCardCategory {
        base.category
    }

    public var switcher: PTCGCardSwitcher? {
        base.switcher
    }

    // MARK: Initialize

    var base: PTCGEnergyCard

    public init(_ energyCard: PTCGEnergyCard) {
        self.base = energyCard
    }
}

extension AnyPTCGEnergyCard: Equatable {

    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
            && lhs.name == rhs.name
            && lhs.capacity == rhs.capacity
            && lhs.category == rhs.category
            && lhs.energies == rhs.energies
    }
}

public struct PTCGBattleActiveZone {
    
    var battlePokemon: PTCGBattlePokemon?
    
    public init() {}
    
    public mutating func entryPokemon(unitSet: Array<PTCGZoneUnitConvertible>) throws {
        guard let unit = unitSet.first else {
            return
        }
        switch unit.switcher {
        case .battlePokemon(let battlePokemon):
            self.battlePokemon = battlePokemon
        case .deckCard(let card):
            self.battlePokemon = try .init(with: card)
        }
    }

    public mutating func attachEnergy(unitSet: Array<PTCGZoneUnitConvertible>) throws {
        guard battlePokemon != nil else {
            return
        }
        guard let cards = unitSet as? Array<PTCGDeckCard> else {
            return
        }
        let eneriges: Array<PTCGDeckCard> = cards.filter { (deckCard) -> Bool in
            switch deckCard.content.switcher {
            case .basicEnergy, .specialEnergy:
                return true
            default:
                return false
            }
        }
        battlePokemon?.energies.append(contentsOf: eneriges)
    }
    
    public mutating func attachItems(unitSet: Array<PTCGZoneUnitConvertible>) throws {
        guard battlePokemon != nil else {
            return
        }
        guard let cards = unitSet as? Array<PTCGDeckCard> else {
            return
        }
        let items: Array<PTCGDeckCard> = cards.filter { (deckCard) -> Bool in
            switch deckCard.content.switcher {
            case .item:
                return true
            default:
                return false
            }
        }
        battlePokemon?.items.append(contentsOf: items)
    }
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
    
    public typealias InputRequest = PTCGBattleZoneAction
    public mutating func input(_ request: PTCGBattleZoneAction, of cards: Array<PTCGZoneUnitConvertible>) throws {
        switch request {
        case .entry:
            try entryPokemon(unitSet: cards)
        case .attachEnergy:
            try attachEnergy(unitSet: cards)
        case .attachItem:
            try attachItems(unitSet: cards)
        }
    }
    
    public typealias OutputRequest = Void
    public mutating func output(_ request: Void) throws -> Array<PTCGZoneUnitConvertible> {
        []
    }
}
