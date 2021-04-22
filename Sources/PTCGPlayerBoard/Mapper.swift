//
//  Mapper.swift
//  PTCGPlayerBoard
//
//  Created by Eimer on 2021/04/21.
//

import Foundation
import PTCGCard

func toCard<T: PTCGCard>(filter: @escaping (T) -> Bool = { _ in true }) -> (PTCGDeckCard) -> T? {
    { card in
        guard let c = card.content as? T, filter(c) else {
            return nil
        }
        return c
    }
}

func toDeckCards() -> (PTCGZoneUnitConvertible) -> Array<PTCGDeckCard> {
    { (unit: PTCGZoneUnitConvertible) in
        switch unit.switcher {
        case .battlePokemon(let battlePokemon):
            return battlePokemon.evolutionTree + battlePokemon.tools + battlePokemon.energies
        case .deckCard(let deckCard):
            return [deckCard]
        }
    }
}

func toDeckCard(
    filter: @escaping (PTCGDeckCard) -> Bool = { _ in true })
-> (PTCGZoneUnitConvertible) -> PTCGDeckCard? {
    { (unit: PTCGZoneUnitConvertible) in
        guard case let .deckCard(card) = unit.switcher else {
            return nil
        }
        guard filter(card) else {
            return nil
        }
        return card
    }
}

func toBattlePokemon() -> (PTCGZoneUnitConvertible) -> PTCGBattlePokemon? {
    { (unit: PTCGZoneUnitConvertible) in
        switch unit.switcher {
        case .battlePokemon(let battlePokemon):
            return battlePokemon
        case .deckCard(let card):
            return try? .init(with: card)
        }
    }
}

func toEnergyDeckCard(_ unit: PTCGZoneUnitConvertible) -> PTCGDeckCard? {
    toDeckCard { (deckCard) -> Bool in
        deckCard.content is PTCGBasicEnergyCard || deckCard.content is PTCGSpecialEnergyCard
    }(unit)
}

func toPokemonToolDeckCard(_ unit: PTCGZoneUnitConvertible) -> PTCGDeckCard? {
    toDeckCard { (deckCard) -> Bool in
        deckCard.content is PTCGPokemonToolCard
    }(unit)
}

func toItemDeckCard(_ unit: PTCGZoneUnitConvertible) -> PTCGDeckCard? {
    toDeckCard { (deckCard) -> Bool in
        deckCard.content is PTCGItemCard || deckCard.content is PTCGBattleItemCard
    }(unit)
}
