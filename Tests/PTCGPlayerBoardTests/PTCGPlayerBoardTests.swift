import XCTest
@testable import PTCGPlayerBoard
import PTCGCard

final class PTCGPlayerBoardTests: XCTestCase {
    
    let testingId: String = PTCGDeckCardIdentifierSet[0 ..< 60].joined()
    
    func testInitializedConfig() {
        let playerBoard = PTCGPlayerBoard(deckSet: .init(cards: ExampleDeck))
        XCTAssertEqual(7, playerBoard.startHandsCount)
        XCTAssertEqual(6, playerBoard.gamePrizeCount)
        XCTAssertEqual(0, playerBoard.deck.cards.count)
    }
    
    func testGameStart() {
        do {
            var playerBoard = PTCGPlayerBoard(deckSet: .init(cards: ExampleDeck))
            try playerBoard.startGame(shuffleId: testingId)
            XCTAssertEqual(53, playerBoard.deck.cards.count)
            XCTAssertEqual(7, playerBoard.hands.cards.count)
        } catch {
            XCTFail()
        }
    }
    
    func testPreparePrize() {
        var playerBoard = PTCGPlayerBoard(deckSet: .init(cards: ExampleDeck))
        try! playerBoard.startGame(shuffleId: testingId)
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
        try! playerBoard.startGame(shuffleId: testingId)
        do {
            try playerBoard.preparePrize()
            try playerBoard.preparePrize()
        } catch {
            let shouldFailing = PTCGPlayerBoard.PreparePrizeError.alreadyStartGame
            XCTAssertEqual(shouldFailing, error as? PTCGPlayerBoard.PreparePrizeError)
        }
    }
    
    func testEntryActiveZone() {
        var playerBoard = PTCGPlayerBoard(deckSet: .init(cards: ExampleDeck))
        try! playerBoard.startGame(shuffleId: testingId)
        try! playerBoard.preparePrize()
        try! playerBoard.entryActivePokemon(from: playerBoard.hands,
                                            request: .select(index: 0))
        XCTAssertEqual(6, playerBoard.hands.cards.count)
        XCTAssertNotNil(playerBoard.battleActive)
        XCTAssertEqual(0, playerBoard.battleActive.battlePokemon?.energies.count)
        XCTAssertEqual(0, playerBoard.battleActive.battlePokemon?.tools.count)
    }
    
    func testEntryBenchZone() {
        var playerBoard = PTCGPlayerBoard(deckSet: .init(cards: ExampleDeck))
        try! playerBoard.startGame(shuffleId: testingId)
        try! playerBoard.preparePrize()
        try! playerBoard.entryBenchPokemon(from: playerBoard.hands,
                                           request: .select(index: 0))
        XCTAssertEqual(6, playerBoard.hands.cards.count)
        XCTAssertNil(playerBoard.battleActive.battlePokemon)
        XCTAssertNotEqual(playerBoard.battleBench.battlePokemons, [])
        XCTAssertEqual(0, playerBoard.battleBench.battlePokemons[0].energies.count)
        XCTAssertEqual(0, playerBoard.battleBench.battlePokemons[0].tools.count)
    }
    
    func testAttachEnergy() {
        var playerBoard = PTCGPlayerBoard(deckSet: .init(cards: ExampleDeck))
        try! playerBoard.startGame(shuffleId: testingId)
        try! playerBoard.preparePrize()
        try! playerBoard.entryActivePokemon(from: playerBoard.hands, request: .select(index: 0))
        let basicEnergy = PTCGDeckCard(
            with: .init(PTCGBasicEnergyCard(at: .colorLess)), "_")
        try! playerBoard.battleActive.input(.attachEnergy, of: [basicEnergy])
        XCTAssertEqual(1, playerBoard.battleActive.battlePokemon?.energies.count)
        XCTAssertEqual(0, playerBoard.battleActive.battlePokemon?.tools.count)
        let specialEnergy = PTCGDeckCard(
            with: .init(PTCGSpecialEnergyCard(
                            id: "_",
                            name: "トリプル加速エネルギー",
                            energies: [.colorLess, .colorLess, .colorLess],
                            capacity: 3)), "_")
        try! playerBoard.battleActive.input(.attachEnergy, of: [specialEnergy])
        XCTAssertEqual(2, playerBoard.battleActive.battlePokemon?.energies.count)
    }
    
    func testAttachTool() {
        var playerBoard = PTCGPlayerBoard(deckSet: .init(cards: ExampleDeck))
        try! playerBoard.startGame(shuffleId: testingId)
        try! playerBoard.preparePrize()
        try! playerBoard.entryActivePokemon(from: playerBoard.hands, request: .select(index: 0))
        let toolCard = PTCGDeckCard(
            with: .init(PTCGPokemonToolCard(id: "_", name: "タフネスマント", effect: "...")), "_")
        try! playerBoard.battleActive.input(.attachTool, of: [toolCard])
        XCTAssertEqual(0, playerBoard.battleActive.battlePokemon?.energies.count)
        XCTAssertEqual(1, playerBoard.battleActive.battlePokemon?.tools.count)
    }

    static var allTests = [
        ("testInitializedConfig", testInitializedConfig),
        ("testGameStart", testGameStart),
        ("testPreparePrize", testPreparePrize),
        ("testEntryActiveZone", testEntryActiveZone),
        ("testAttachEnergy", testAttachEnergy),
        ("testAttachTool", testAttachTool),
    ]
}
