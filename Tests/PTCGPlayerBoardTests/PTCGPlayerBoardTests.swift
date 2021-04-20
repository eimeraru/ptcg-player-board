import XCTest
@testable import PTCGPlayerBoard
import PTCGCard

final class PTCGPlayerBoardTests: XCTestCase {
    
    func testInitializedConfig() {
        let playerBoard = PTCGPlayerBoard(deckSet: .init(cards: ExampleDeck))
        XCTAssertEqual(7, playerBoard.startHandsCount)
        XCTAssertEqual(6, playerBoard.gamePrizeCount)
    }
    
    func testGameStart() {
        var playerBoard = PTCGPlayerBoard(deckSet: .init(cards: ExampleDeck))
        print("Game start setting count: \(playerBoard.gameStart())")
        XCTAssertEqual(53, playerBoard.deck.cards.count)
        XCTAssertEqual(7, playerBoard.hands.cards.count)
    }
    
    func testPreparePrize() {
        var playerBoard = PTCGPlayerBoard(deckSet: .init(cards: ExampleDeck))
        print("Game start setting count: \(playerBoard.gameStart())")
        try! playerBoard.preparePrize()
        XCTAssertEqual(47, playerBoard.deck.cards.count)
        XCTAssertEqual(7, playerBoard.hands.cards.count)
        XCTAssertEqual(6, playerBoard.prize.cards.count)
    }

    static var allTests = [
        ("testInitializedConfig", testInitializedConfig),
        ("testGameStart", testGameStart),
        ("testPreparePrize", testPreparePrize),
    ]
}
