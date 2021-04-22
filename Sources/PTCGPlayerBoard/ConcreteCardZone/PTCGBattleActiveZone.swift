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
        guard let battlePokemon = unitSet.first.flatMap(toBattlePokemon()) else {
            return
        }
        self.battlePokemon = battlePokemon
    }
}

extension PTCGBattleActiveZone: PTCGZoneConvertible {
    
    public var switcher: PTCGZoneSwither {
        .battleActive(self)
    }
    
    public var all: Array<PTCGZoneUnitConvertible> {
        battlePokemon.map { [$0] } ?? []
    }
    
    public typealias ReadRequest = Void
    public func read(_ request: Void) -> Array<PTCGZoneUnitConvertible> {
        all
    }
    
    public typealias InputRequest = (PTCGBattleZoneInputAction)
    public mutating func input(_ request: PTCGBattleZoneInputAction, of unitSet: Array<PTCGZoneUnitConvertible>) throws {
        switch request {
        case .entry:
            try entryPokemon(unitSet: unitSet)
        case .attachEnergy:
            battlePokemon?.energies.append(contentsOf: unitSet.compactMap(toEnergyDeckCard))
        case .attachTool:
            battlePokemon?.tools.append(contentsOf: unitSet.compactMap(toPokemonToolDeckCard))
        }
    }
    
    public typealias OutputRequest = PTCGBattleZoneOutputAction
    public mutating func output(_ request: OutputRequest) throws -> Array<PTCGZoneUnitConvertible> {
        switch request {
        case .knockOut:
            guard let pokemon = battlePokemon else {
                return []
            }
            battlePokemon?.evolutionTree = []
            battlePokemon?.energies = []
            battlePokemon?.tools = []
            return pokemon.all
        case .degenerate:
            guard let pokemon = battlePokemon else {
                return []
            }
            guard pokemon.evolutionTree.count > 1 else {
                return []
            }
            guard let last = pokemon.evolutionTree.last else {
                return []
            }
            self.battlePokemon?.evolutionTree.removeLast()
            return [last]
        case .detachEnergy(let index):
            guard let pokemon = battlePokemon else {
                return []
            }
            guard pokemon.energies.count > 0 else {
                return []
            }
            self.battlePokemon?.energies.remove(at: index)
            return [pokemon.energies[index]]
        case .detachTool(let index):
            guard let pokemon = battlePokemon else {
                return []
            }
            guard pokemon.energies.count > 0 else {
                return []
            }
            self.battlePokemon?.energies.remove(at: index)
            return [pokemon.tools[index]]
        }
    }
}
