//
//  PTCGBattleBench.swift
//  PTCGPlayerBoard
//
//  Created by Eimer on 2021/04/20.
//

import Foundation

public struct PTCGBattleBenchZone {

    var battlePokemons = Array<PTCGBattlePokemon>()
    
    public init() {}
}

extension PTCGBattleBenchZone: PTCGZoneConvertible {
    
    public var switcher: PTCGZoneSwither {
        .battleBench(self)
    }
    
    public var all: Array<PTCGZoneUnitConvertible> {
        battlePokemons
    }
    
    public typealias ReadRequest = Void
    public func read(_ request: Void) -> Array<PTCGZoneUnitConvertible> {
        all
    }
    
    public enum InputRequestOption {
        case select(Int)
    }
    public typealias InputRequest = (action: PTCGBattleZoneAction, option: InputRequestOption?)
    public mutating func input(_ request: InputRequest, of unitSet: Array<PTCGZoneUnitConvertible>) throws {
        switch (request.action, request.option) {
        case (.entry, nil):
            battlePokemons.append(contentsOf: unitSet.compactMap(toBattlePokemon()))
        case (.attachTool, .select(let index)?):
            battlePokemons[index].energies
                .append(contentsOf: unitSet.compactMap(toPokemonToolDeckCard))
        case (.attachEnergy, .select(let index)?):
            battlePokemons[index].energies
                .append(contentsOf: unitSet.compactMap(toEnergyDeckCard))
        default:
            break
        }
    }
    
    public typealias OutputRequest = Void
    public mutating func output(_ request: Void) throws -> Array<PTCGZoneUnitConvertible> {
        []
    }
}
