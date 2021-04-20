//
//  PTCGDeckSetTests.swift
//  PTCGPlayerBoardTests
//
//  Created by Eimer on 2021/04/20.
//

import XCTest
@testable import PTCGPlayerBoard
import PTCGCard

class PTCGDeckSetTests: XCTestCase {

    func testExample() {
        let deck = PTCGDeckSet(cards: ExampleDeck)
        let deckCodes = deck.cards.map { $0.identifier }
        XCTAssertEqual(60, deckCodes.count)
        XCTAssertEqual("PTCGPokemonCard", "\(type(of: deck.cards[0].content))")
    }
}
