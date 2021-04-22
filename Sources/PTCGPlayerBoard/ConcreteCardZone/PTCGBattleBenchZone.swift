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
    public typealias InputRequest = (action: PTCGBattleZoneInputAction,
                                     option: InputRequestOption?)
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
    
    public enum OutputRequestOption {
        case select(Int)
    }
    public typealias OutputRequest = (action: PTCGBattleZoneOutputAction,
                                      option: OutputRequestOption?)
    public mutating func output(_ request: OutputRequest) throws -> Array<PTCGZoneUnitConvertible> {
        switch (request.action, request.option) {
        case (.knockOut, .select(let index)?):
            let all = battlePokemons[index].all
            battlePokemons.remove(at: index)
            return all
        case (.degenerate, .select(let index)):
            var battlePokemon = battlePokemons[index]
            guard battlePokemon.evolutionTree.count > 1 else {
                return []
            }
            return [battlePokemon.evolutionTree.removeLast()]
        case (.detachEnergy(let energyIndex), .select(let pokemonIndex)):
            var battlePokemon = battlePokemons[pokemonIndex]
            let energy = battlePokemon.energies[energyIndex]
            battlePokemon.energies.remove(at: energyIndex)
            return [energy]
        case (.detachTool(let toolIndex), .select(let pokemonIndex)):
            var battlePokemon = battlePokemons[pokemonIndex]
            let tool = battlePokemon.tools[toolIndex]
            battlePokemon.tools.remove(at: toolIndex)
            return [tool]
        default:
            return []
        }
    }
}
