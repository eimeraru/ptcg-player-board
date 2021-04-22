//
//  PTCGCardZone.swift
//  PTCGPlayerBoard
//
//  Created by Eimer on 2021/04/20.
//

import PTCGCard

// MARK: PTCGZone
/**
 * ポケモンカードゲーム上の置き場の種類ごとのサブタイプを網羅検査する
 */
public enum PTCGZoneSwither {
    case battleActive   (PTCGBattleActiveZone)
    case battleBench    (PTCGBattleBenchZone)
    case stadium        (PTCGStadiumZone)
    case deck           (PTCGDeckZone)
    case hands          (PTCGHandsZone)
    case discardPile    (PTCGDiscardPileZone)
    case prize          (PTCGPrizeZone)
}

/**
 * ポケモンカードゲーム上の置き場を種類ごとそれぞれ制御可能にする
 */
public protocol PTCGZoneControllable {
    var deck                : PTCGDeckZone          { get set }
    var battleActive        : PTCGBattleActiveZone  { get set }
    var battleBench         : PTCGBattleBenchZone   { get set }
    var stadium             : PTCGStadiumZone       { get set }
    var hands               : PTCGHandsZone         { get set }
    var discardPile         : PTCGDiscardPileZone   { get set }
    var prize               : PTCGPrizeZone         { get set }
}

/**
 * ポケモンカードゲーム上の置き場として変換可能となる定義
 */
public protocol PTCGZoneConvertible {

    var switcher: PTCGZoneSwither { get }

    var all: Array<PTCGZoneUnitConvertible> { get }
    
    associatedtype ReadRequest
    func read(_ request: ReadRequest) -> Array<PTCGZoneUnitConvertible>
    
    associatedtype InputRequest
    mutating func input(_ request: InputRequest, of unitSet: Array<PTCGZoneUnitConvertible>) throws
    
    associatedtype OutputRequest
    mutating func output(_ request: OutputRequest) throws -> Array<PTCGZoneUnitConvertible>
}

extension PTCGZoneControllable {

    func read<T: PTCGZoneConvertible>(
        zone: T, request: T.ReadRequest) -> Array<PTCGZoneUnitConvertible>
    {
        zone.all
    }
    
    mutating func transit<T: PTCGZoneConvertible, S: PTCGZoneConvertible>
    (
        _ lhs: (zone: T, request: T.OutputRequest),
        to rhs: (zone: S, request: S.InputRequest)) throws -> Array<PTCGZoneUnitConvertible>
    {
        var lhs = lhs
        let outputted = try lhs.zone.output(lhs.request)
        update(with: lhs.zone)
        var rhs = rhs
        try rhs.zone.input(rhs.request, of: outputted)
        update(with: rhs.zone)
        return outputted
    }
    
    mutating func update<T: PTCGZoneConvertible>(with zone: T) {
        switch zone.switcher {
        case .battleActive(let zone):
            self.battleActive = zone
        case .battleBench(let zone):
            self.battleBench = zone
        case .deck(let zone):
            self.deck = zone
        case .discardPile(let zone):
            self.discardPile = zone
        case .prize(let zone):
            self.prize = zone
        case .stadium(let zone):
            self.stadium = zone
        case .hands(let zone):
            self.hands = zone
        }
    }
}

// MARK: PTCGBattleZone

public enum PTCGBattleZoneInputAction {
    case entry
    case attachEnergy
    case attachTool
}

public enum PTCGBattleZoneOutputAction {
    case knockOut
    case degenerate
    case detachEnergy(index: Int)
    case detachTool(index: Int)
}

// MARK: PTCGZoneUnit

/**
 * ポケモンカードゲーム上の置き場の中で扱える単位として変換可能となる定義
 */
public protocol PTCGZoneUnitConvertible {
    var switcher: PTCGZoneUnitSwitcher { get }
}

/**
 * ポケモンカードゲーム上の置き場の中で扱える種類ごとのサブタイプを網羅検査する
 */
public enum PTCGZoneUnitSwitcher {
    /** デッキ内のカード */
    case deckCard(PTCGDeckCard)
    /** バトルポケモン */
    case battlePokemon(PTCGBattlePokemon)
}

extension PTCGDeckCard: PTCGZoneUnitConvertible {
    public var switcher: PTCGZoneUnitSwitcher {
        .deckCard(self)
    }
}

extension PTCGBattlePokemon: PTCGZoneUnitConvertible {
    public var switcher: PTCGZoneUnitSwitcher {
        .battlePokemon(self)
    }
}
