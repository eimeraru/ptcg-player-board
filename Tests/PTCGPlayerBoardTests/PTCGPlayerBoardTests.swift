import XCTest
@testable import PTCGPlayerBoard
import PTCGCard

final class PTCGPlayerBoardTests: XCTestCase {
    
    func testInitializedConfig() {
        let playerBoard = PTCGPlayerBoard(deckSet: .init(cards: ExampleDeck))
        XCTAssertEqual(7, playerBoard.startHandsCount)
        XCTAssertEqual(6, playerBoard.gamePrizeCount)
        XCTAssertEqual(0, playerBoard.deck.cards.count)
    }
    
    func testGameStart() {
        do {
            var playerBoard = PTCGPlayerBoard(deckSet: .init(cards: ExampleDeck))
            try playerBoard.startGame()
            XCTAssertEqual(53, playerBoard.deck.cards.count)
            XCTAssertEqual(7, playerBoard.hands.cards.count)
        } catch {
            XCTFail()
        }
    }
    
    func testPreparePrize() {
        
        var playerBoard = PTCGPlayerBoard(deckSet: .init(cards: ExampleDeck))
        try! playerBoard.startGame()
        try! playerBoard.preparePrize()
        XCTAssertEqual(47, playerBoard.deck.cards.count)
        XCTAssertEqual(7, playerBoard.hands.cards.count)
        XCTAssertEqual(6, playerBoard.prize.cards.count)
        playerBoard = PTCGPlayerBoard(deckSet: .init(cards: ExampleDeck))
        do {
            try playerBoard.preparePrize()
        } catch {
            let shouldFailing = PTCGPlayerBoard.PreparePrizeError.shouldSettingDeck
            XCTAssertEqual(shouldFailing, error as? PTCGPlayerBoard.PreparePrizeError)
        }
        playerBoard = PTCGPlayerBoard(deckSet: .init(cards: ExampleDeck))
        try! playerBoard.startGame()
        do {
            try playerBoard.preparePrize()
            try playerBoard.preparePrize()
        } catch {
            let shouldFailing = PTCGPlayerBoard.PreparePrizeError.alreadyStartGame
            XCTAssertEqual(shouldFailing, error as? PTCGPlayerBoard.PreparePrizeError)
        }
    }
    
    func testEntryPokemon() {
        var playerBoard = PTCGPlayerBoard(deckSet: .init(cards: ExampleDeck))
        try! playerBoard.startGame()
        try! playerBoard.preparePrize()
        try! playerBoard.entryPokemon(0)
        XCTAssertEqual(6, playerBoard.hands.cards.count)
        XCTAssertNotNil(playerBoard.battleActive)
    }
    
    static var allTests = [
        ("testInitializedConfig", testInitializedConfig),
        ("testGameStart", testGameStart),
        ("testPreparePrize", testPreparePrize),
        ("testEntryPokemon", testEntryPokemon),
    ]
}
