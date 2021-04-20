import XCTest
@testable import PTCGPlayerBoard
import PTCGCard

final class PTCGPlayerBoardTests: XCTestCase {
    func testExample() {
        let playerBoard = PTCGPlayerBoard(deckSet: .init(cards: ExampleDeck))
        XCTAssertEqual(7, playerBoard.startHandsCount)
        XCTAssertEqual(6, playerBoard.gamePrizeCount)
    }
    
    func testGameStart() {
        var playerBoard = PTCGPlayerBoard(deckSet: .init(cards: ExampleDeck))
        print("Game start setting count: \(playerBoard.gameStart())")
        XCTAssertEqual(53, playerBoard.deck.cards.count)
        XCTAssertEqual(7, playerBoard.hands.cards.count)
//        var oneShotCount = 0
//        let settingResults = (0 ..< 10000).reduce(into: Array<Int>()) { results, _ in
//            results.append(playerBoard.gameStart())
//        }
//        let average = settingResults.reduce(0.0) {
//            if $1 == 1 {
//                oneShotCount += 1
//            }
//            return $0 + Double($1) / Double(settingResults.count)
//        }
//        print("setting results: \(average), \(oneShotCount)/10000")
    }

    static var allTests = [
        ("testExample", testExample),
        ("testGameStart", testGameStart),
    ]
}
