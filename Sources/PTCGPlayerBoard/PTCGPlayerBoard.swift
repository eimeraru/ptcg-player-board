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
    @discardableResult
    public mutating func startGame(_ settingCount: Int = 1, shuffleId: String? = nil) throws -> Int {
        deck.cards = deckSet.cards
        shuffle(shuffleId)
        let drawed = try draw(startHandsCount)
        let basicPokemons: Array<PTCGPokemonCard> = drawed.compactMap(
            toCard(filter: { $0.evolutionType == .basic }))
        guard basicPokemons.count > 0 else {
            try returnHands()
            return try startGame(settingCount + 1)
        }
        return settingCount
    }
    
    /** サイドを準備する際に発生するエラー */
    public enum PreparePrizeError: Error {
        /** 山札の準備が出来てない場合に発生 */
        case shouldSettingDeck
        /** 既にゲームが開始している場合に発生 */
        case alreadyStartGame
    }
    
    /** サイドに指定枚数のカードを山札から裏向きに設置する */
    public mutating func preparePrize() throws {
        guard hands.cards.count == startHandsCount else {
            throw PreparePrizeError.shouldSettingDeck
        }
        guard deck.cards.count == deckSet.cards.count - startHandsCount else {
            throw PreparePrizeError.alreadyStartGame
        }
        _ = try transit(
            (zone: deck, request: .draw(count: gamePrizeCount)),
            to: (zone: prize, request: ()))
    }
    
    /**
     * 手札に山札から指定枚数分を引く
     * - Parameters:
     *   - count: 引く枚数
     */
    public mutating func draw(_ count: Int = 1) throws -> Array<PTCGDeckCard> {
        try transit((zone: deck, request: .draw(count: count)),
                    to: (zone: hands, request: ())) as? Array<PTCGDeckCard> ?? []
    }
    
    /**
     * 手札を山札に全て戻す
     */
    @discardableResult
    public mutating func returnHands() throws -> Array<PTCGDeckCard> {
        try transit((zone: hands, request: .selectAll),
                    to: (zone: deck, request: ())) as? Array<PTCGDeckCard> ?? []
    }
    
    /**
     * 山札をシャッフルする
     */
    public mutating func shuffle(_ id: String? = nil) {
        deck.shuffle(id)
    }
    
    /**
     * 手札からバトル場に出す
     * - Parameters:
     *   - index: 手札にいるポケモンカード
     */
    public mutating func entryPokemon(_ index: Int) throws {
        _ = try transit((zone: hands, request: .select(index: index)),
                        to: (zone: battleActive, request: .entry))
    }
    
    // MARK: PTCGZoneControllable
    
    /** 山札 */
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
