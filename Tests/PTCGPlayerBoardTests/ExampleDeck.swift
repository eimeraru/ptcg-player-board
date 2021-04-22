//
//  ExampleDeck.swift
//  PTCGPlayerBoardTests
//
//  Created by Eimer on 2021/04/20.
//

import PTCGCard

let basicPokemonCount = 4

let basicMonsters: Array<AnyPTCGCard> = (0 ..< basicPokemonCount).map { _ in
    .init(PTCGPokemonCard(
        id: "",
        name: "イーブイ",
        type: .colorLess,
        maxHitPoint: 70,
        evolutionType: .basic,
        ability: nil))
}
let fireEnergies: Array<AnyPTCGCard> = (0 ..< 10).map { _ in .init(PTCGBasicEnergyCard(at: .fire)) }
let waterEnergies: Array<AnyPTCGCard> = (0 ..< 10).map { _ in .init(PTCGBasicEnergyCard(at: .water)) }
let darkEnergies: Array<AnyPTCGCard> = (0 ..< 10).map { _ in .init(PTCGBasicEnergyCard(at: .dark)) }
let electricEnergies: Array<AnyPTCGCard> = (0 ..< 10).map { _ in .init(PTCGBasicEnergyCard(at: .electric)) }
let grassEnergies: Array<AnyPTCGCard> = (0 ..< 10).map { _ in .init(PTCGBasicEnergyCard(at: .grass)) }
let psychicEnergies: Array<AnyPTCGCard> = (0 ..< 10).map { _ in .init(PTCGBasicEnergyCard(at: .psychic)) }

var ExampleDeck = Array((basicMonsters
    + fireEnergies
    + waterEnergies
    + darkEnergies
    + electricEnergies
    + grassEnergies
    + psychicEnergies)[0 ..< 60])
