//
//  PTCGDeckSet.swift
//  PTCGPlayerBoard
//
//  Created by Eimer on 2021/04/19.
//

import Foundation
import PTCGCard

public typealias PTCGDeckCardIdentifier = String
internal let PTCGDeckCardIdentifierSet = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    .map(PTCGDeckCardIdentifier.init)

public struct PTCGDeckSet {

    public let cards: Array<PTCGDeckCard>
    
    public init(cards: Array<AnyPTCGCard>) {
        self.cards = cards.enumerated().map {
            PTCGDeckCard(with: $0.element, PTCGDeckCardIdentifierSet[$0.offset])
        }
    }
}
