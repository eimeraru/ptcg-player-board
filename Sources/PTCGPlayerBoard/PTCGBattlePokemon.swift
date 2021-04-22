//
//  PTCGBattlePokemon.swift
//  PTCGPlayerBoard
//
//  Created by Eimer on 2021/04/19.
//

import PTCGCard
import PTCGEnergy
import PTCGSpecialConditions

/**
 * バトルポケモンとして扱えるカードの定義
 */
public typealias PTCGBattleCard = PTCGBattleAvailable & PTCGCard

/**
 * ポケモンカードにおけるバトル場・ベンチに出せるバトルポケモン
 */
public struct PTCGBattlePokemon {

    enum PTCGError: Error {
        case invalidBattleCard
    }
    
    /**
     * バトルポケモンとして場に出したカード
     * 進化する度にカードを重ねていく
     */
    public var evolutionTree: Array<PTCGDeckCard>
    
    /**
     * バトルポケモンとして重ねて出している一番上のカードを
     * 現在のバトルカードとして扱う
     * (e.g. [ヒトカゲ, リザード, リザードン].last) => リザードン)
     */
    public var current: PTCGDeckCard {
        guard let current = evolutionTree.last else {
            fatalError("Must come into play board as a pokemon card")
        }
        return current
    }
    
    /**
     * 蓄積しているダメージ点数
     */
    public var damagePoint: Int
    
    /**
     * 現在のHP
     */
    public var currentHitPoint: Int {
        guard let battleCard = current.content as? PTCGBattleAvailable else {
            return 0
        }
        return battleCard.maxHitPoint - damagePoint
    }
    
    /**
     * 所有している「ポケモンのどうぐ」
     */
    public var items: Array<PTCGDeckCard>
    
    /**
     * 技を使うのに必要となるエネルギーカード
     */
    public var energies: Array<PTCGDeckCard>

    /**
     * ポケモンの特殊状態
     */
    public var specialConditions: PTCGSpecialConditions
    
    /**
     * バトルポケモンとしてバトルに出せるカードを元に生成する
     * - Parameter battleCard: バトルに出すためのポケモンカード
     */
    public init(with battleCard: PTCGDeckCard) throws {
        guard battleCard.content is PTCGBattleCard else {
            throw PTCGError.invalidBattleCard
        }
        self.evolutionTree = [battleCard]
        self.damagePoint = 0
        self.items = []
        self.energies = []
        self.specialConditions = .init()
    }
    
    /**
     * 指定したバトルカードに進化する
     * - Parameter battleCard: 進化先となるバトルカード
     */
    public mutating func evolve(with battleCard: PTCGDeckCard) {
        if battleCard.content is PTCGBattleAvailable {
            self.evolutionTree.append(battleCard)
        }
    }
    
    /**
     * バトルポケモンに状態異常となるデバフを反映する
     * - Parameter specialCondition: 状態異常
     */
    public mutating func debuff(with specialCondition: PTCGSpecialCondition) {
        specialConditions.add(with: specialCondition)
    }
}

//extension PTCGBattlePokemon: ZoneConvertible {
//
//    public var all: Array<ZoneUnitConvertible> {
//        let items = self.items
//        let energies = self.energies
//        return evolutionTree + items + energies
//    }
//
//    public typealias ReadRequest = ReadAction
//    public enum ReadAction {
//        case energy
//        case item
//        case battle
//    }
//    public func read(_ request: ReadAction) -> Array<ZoneUnitConvertible> {
//        switch request {
//        case .energy:
//            return energies
//        case .item:
//            return items
//        case .battle:
//            return evolutionTree
//        }
//    }
//
//    public typealias InputRequest = InputAction
//    public enum InputAction {
//        case attachItem(PTCGDeckCard)
//        case attachEnergy(PTCGDeckCard)
//        case evolve(PTCGDeckCard)
//    }
//    public mutating func input(_ request: InputAction, of cards: Array<ZoneUnitConvertible>) {
//        switch request {
//        case .attachEnergy:
//            energies.append(contentsOf: cards as? Array<PTCGDeckCard> ?? [])
//        case .attachItem:
//            items.append(contentsOf: cards as? Array<PTCGDeckCard> ?? [])
//        case .evolve:
//            evolutionTree.append(contentsOf: cards as? Array<PTCGDeckCard> ?? [])
//        }
//    }
//
//    public typealias OutputRequest = OutputAction
//    public enum OutputAction {
//        case detachItem(Int)
//        case detachEnergy(Int)
//        case degeneration
//    }
//    public mutating func output(_ request: OutputAction) -> Array<ZoneUnitConvertible> {
//        switch request {
//        case .detachItem(let index):
//            return [self.items[index]]
//        case .detachEnergy(let index):
//            return [self.energies[index]]
//        case .degeneration:
//            guard let last = self.evolutionTree.last, evolutionTree.count > 1 else {
//                return []
//            }
//            return [last]
//        }
//    }
//}
extension PTCGBattlePokemon: Equatable {

    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.current == rhs.current
            && lhs.tools == rhs.tools
            && lhs.energies == rhs.energies
            && lhs.evolutionTree == rhs.evolutionTree
            && lhs.damagePoint == rhs.damagePoint
        // TODO: && lhs.specialConditions == rhs.specialConditions
    }
}
