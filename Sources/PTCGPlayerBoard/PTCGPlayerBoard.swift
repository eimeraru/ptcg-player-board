import PTCGCard

/**
 * ポケモンカードのゲーム開始時に用意する初期手札枚数
 */
public let PTCGStartHandsCount = 7

/**
 * ポケモンカードの初期サイドカード枚数
 */
public let PTCGDefaultPrizeCount = 6

/**
 * ポケモンカードゲームのプレイヤー毎の盤面
 */
public struct PTCGPlayerBoard: PTCGZoneControllable {
    
    // MARK: Initialize
    
    /**
     * ゲーム開始上の手札枚数
     */
    public let startHandsCount: Int
    
    /**
     * ゲーム開始上のサイド枚数
     */
    public let gamePrizeCount: Int
    
    /**
     * ゲームで使用するデッキセット
     */
    public let deckSet: PTCGDeckSet
    
    /**
     * 盤面を生成
     * - Parameters:
     *   - hands: 手札の初期枚数
     *   - prize: サイドの枚数
     *   - deckSet: 使用するデッキセット
     */
    public init(
        hands: Int = PTCGStartHandsCount,
        prize: Int = PTCGDefaultPrizeCount,
        deckSet: PTCGDeckSet)
    {
        self.startHandsCount = hands
        self.gamePrizeCount = prize
        self.deckSet = deckSet
    }
    
    /**
     * ゲームを開始するのに必要な山札を用意し、手札を山札から規定枚数引く
     * その際に「たねポケモン」が必ず手札に1枚以上存在している必要があるため、
     *「たねポケモン」が1枚以上引けるまで再帰的に処理を実行する
     * - Parameters:
     *  - settingCount: 初期値は1から
     * - Returns: 手札を準備する際に引き直した回数、初回準備のあと回数分を相手にドローさせる
     */
    public mutating func startGame(_ settingCount: Int = 1) -> Int {
        deck.cards = deckSet.cards.shuffled()
        let unitSet: Array<PTCGZoneUnitConvertible> = transit(
            (zone: deck, request: .draw(count: startHandsCount)),
            to: (zone: hands, request: ()))
        let basicPokemons = unitSet.compactMap { (unit) -> PTCGPokemonCard? in
            mapToCard(unit) { $0.evolutionType == .basic }
        }
        guard basicPokemons.count > 0 else {
            _ = transit((zone: hands, request: .selectAll),
                        to: (zone: deck, request: ()))
            return startGame(settingCount + 1)
        }
        return settingCount
    }
    
    /** サイドを準備する際に発生するエラー */
    public enum PreparePrizeError: Error {
        /** デッキの準備が出来てない場合に発生 */
        case shouldSettingDeck
        /** 既にゲームが開始している場合に発生 */
        case alreadyStartGame
    }
    /** サイドに指定枚数のカードをデッキから裏向きに設置する */
    public mutating func preparePrize() throws {
        guard hands.cards.count == startHandsCount else {
            throw PreparePrizeError.shouldSettingDeck
        }
        guard deck.cards.count == deckSet.cards.count - startHandsCount else {
            throw PreparePrizeError.alreadyStartGame
        }
        _ = transit(
            (zone: deck, request: .draw(count: gamePrizeCount)),
            to: (zone: prize, request: ()))
    }
    
    private func mapToCard<T: PTCGCard>(
        _ unit: PTCGZoneUnitConvertible,
        filter: (T) -> Bool) -> T?
    {
        guard case .deckCard(let card) = unit.switcher else {
            return nil
        }
        guard let c = card.content as? T, filter(c) else {
            return nil
        }
        return c
    }
    
    // MARK: PTCGZoneControllable
    
    /** デッキ */
    public var deck         : PTCGDeckZone          = .init()
    /** バトル場 */
    public var battleActive : PTCGBattleActiveZone  = .init()
    /** ベンチ */
    public var battleBench  : PTCGBattleBenchZone   = .init()
    /** スタジアム */
    public var stadium      : PTCGStadiumZone       = .init()
    /** 手札 */
    public var hands        : PTCGHandsZone         = .init()
    /** トラッシュ */
    public var discardPile  : PTCGDiscardPileZone   = .init()
    /** サイド */
    public var prize        : PTCGPrizeZone         = .init()
}

public extension PTCGPlayerBoard {
    
    enum Abc {
        case hoge
    }
    
    /**
     * カードの挿入位置
     */
    enum InsertPosition {
        /**
         * カードの山の一番上に挿入
         */
        case on

        /**
         * カードの山の一番下に挿入
         */
        case under
    }
}
