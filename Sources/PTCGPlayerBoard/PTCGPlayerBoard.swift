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
