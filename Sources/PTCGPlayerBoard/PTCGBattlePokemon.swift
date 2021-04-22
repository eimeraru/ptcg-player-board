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
     * 技を使うのに必要となるエネルギーカード
     */
    public var all: Array<PTCGDeckCard> {
        evolutionTree + tools + energies
    }
    
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
    public var tools: Array<PTCGDeckCard>
    
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
        self.tools = []
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
