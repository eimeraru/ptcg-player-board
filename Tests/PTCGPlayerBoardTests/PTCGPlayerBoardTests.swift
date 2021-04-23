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
        do {
            try playerBoard.startGame(shuffleId: testingId)
            try playerBoard.preparePrize()
            XCTAssertEqual(47, playerBoard.deck.cards.count)
            XCTAssertEqual(7, playerBoard.hands.cards.count)
            XCTAssertEqual(6, playerBoard.prize.cards.count)
            playerBoard = PTCGPlayerBoard(deckSet: .init(cards: ExampleDeck))
            try playerBoard.preparePrize()
        } catch {
            let shouldFailing = PTCGPlayerBoard.PreparePrizeError.shouldSettingDeck
            XCTAssertEqual(shouldFailing, error as? PTCGPlayerBoard.PreparePrizeError)
        }
        playerBoard = PTCGPlayerBoard(deckSet: .init(cards: ExampleDeck))
        do {
            try playerBoard.startGame(shuffleId: testingId)
            try playerBoard.preparePrize()
            try playerBoard.preparePrize()
        } catch {
            let shouldFailing = PTCGPlayerBoard.PreparePrizeError.alreadyStartGame
            XCTAssertEqual(shouldFailing, error as? PTCGPlayerBoard.PreparePrizeError)
        }
    }
    
    func testSelectPrize() {
        do {
            var playerBoard = PTCGPlayerBoard(deckSet: .init(cards: ExampleDeck))
            try playerBoard.startGame(shuffleId: testingId)
            try playerBoard.preparePrize()
            _ = try playerBoard.selectPrize(with: 0)
            XCTAssertEqual(5, playerBoard.prize.cards.count)
        } catch {
            XCTFail()
        }
    }
    
    func testEntryActiveZone() {
        do {
            var playerBoard = PTCGPlayerBoard(deckSet: .init(cards: ExampleDeck))
            try playerBoard.startGame(shuffleId: testingId)
            try playerBoard.preparePrize()
            try playerBoard.entryActivePokemon(from: playerBoard.hands,
                                                request: .select(index: 0))
            XCTAssertEqual(6, playerBoard.hands.cards.count)
            XCTAssertNotNil(playerBoard.battleActive)
            XCTAssertEqual(0, playerBoard.battleActive.battlePokemon?.energies.count)
            XCTAssertEqual(0, playerBoard.battleActive.battlePokemon?.tools.count)
        } catch {
            XCTFail()
        }
    }
    
    func testEntryBenchZone() {
        do {
            var playerBoard = PTCGPlayerBoard(deckSet: .init(cards: ExampleDeck))
            try playerBoard.startGame(shuffleId: testingId)
            try playerBoard.preparePrize()
            try playerBoard.entryBenchPokemon(from: playerBoard.hands,
                                               request: .select(index: 0))
            XCTAssertEqual(6, playerBoard.hands.cards.count)
            XCTAssertNil(playerBoard.battleActive.battlePokemon)
            XCTAssertNotEqual(playerBoard.battleBench.battlePokemons, [])
            XCTAssertEqual(0, playerBoard.battleBench.battlePokemons[0].energies.count)
            XCTAssertEqual(0, playerBoard.battleBench.battlePokemons[0].tools.count)
        } catch {
            XCTFail()
        }
    }
    
    func testAttachEnergy() {
        do {
            var playerBoard = PTCGPlayerBoard(deckSet: .init(cards: ExampleDeck))
            try playerBoard.startGame(shuffleId: testingId)
            try playerBoard.preparePrize()
            try playerBoard.entryActivePokemon(from: playerBoard.hands, request: .select(index: 0))
            let basicEnergy = PTCGDeckCard(
                with: .init(PTCGBasicEnergyCard(at: .colorLess)), "_")
            try playerBoard.battleActive.input(.attachEnergy, of: [basicEnergy])
            XCTAssertEqual(1, playerBoard.battleActive.battlePokemon?.energies.count)
            XCTAssertEqual(0, playerBoard.battleActive.battlePokemon?.tools.count)
            let specialEnergy = PTCGDeckCard(
                with: .init(PTCGSpecialEnergyCard(
                                id: "_",
                                name: "トリプル加速エネルギー",
                                energies: [.colorLess, .colorLess, .colorLess],
                                capacity: 3)), "_")
            try playerBoard.battleActive.input(.attachEnergy, of: [specialEnergy])
            XCTAssertEqual(2, playerBoard.battleActive.battlePokemon?.energies.count)
        } catch {
            XCTFail()
        }
    }
    
    func testAttachTool() {
        do {
            var playerBoard = PTCGPlayerBoard(deckSet: .init(cards: ExampleDeck))
            try playerBoard.startGame(shuffleId: testingId)
            try playerBoard.preparePrize()
            try playerBoard.entryActivePokemon(from: playerBoard.hands, request: .select(index: 0))
            let tool = PTCGPokemonToolCard(id: "_", name: "タフネスマント", effect: "...")
            let toolCard = PTCGDeckCard(with: .init(tool), "_")
            try! playerBoard.battleActive.input(.attachTool, of: [toolCard])
            XCTAssertEqual(0, playerBoard.battleActive.battlePokemon?.energies.count)
            XCTAssertEqual(1, playerBoard.battleActive.battlePokemon?.tools.count)
        } catch {
            XCTFail()
        }
    }
    
    func testReadCards() {
        do {
            var playerBoard = PTCGPlayerBoard(deckSet: .init(cards: ExampleDeck))
            try playerBoard.startGame(shuffleId: testingId)
            try playerBoard.preparePrize()
            try playerBoard.entryActivePokemon(from: playerBoard.hands,
                                                request: .select(index: 0))
            XCTAssertEqual(1, playerBoard.read(zone: playerBoard.battleActive,
                                               request: ()).count)
            XCTAssertEqual(0, playerBoard.read(zone: playerBoard.battleBench,
                                               request: ()).count)
            XCTAssertEqual(47, playerBoard.read(zone: playerBoard.deck,
                                                request: ()).count)
            XCTAssertEqual(0, playerBoard.read(zone: playerBoard.discardPile,
                                               request: ()).count)
            XCTAssertEqual(6, playerBoard.read(zone: playerBoard.hands,
                                               request: ()).count)
            XCTAssertEqual(6, playerBoard.read(zone: playerBoard.prize,
                                               request: ()).count)
            XCTAssertEqual(0, playerBoard.read(zone: playerBoard.stadium,
                                               request: ()).count)
        } catch {
            XCTFail()
        }
    }

    static var allTests = [
        ("testInitializedConfig", testInitializedConfig),
        ("testGameStart", testGameStart),
        ("testPreparePrize", testPreparePrize),
        ("testEntryActiveZone", testEntryActiveZone),
        ("testAttachEnergy", testAttachEnergy),
        ("testAttachTool", testAttachTool),
        ("testReadCards", testReadCards),
    ]
}
