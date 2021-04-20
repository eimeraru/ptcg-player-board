//
//  PTCGDeckCard.swift
//  PTCGPlayerBoard
//
//  Created by Eimer on 2021/04/19.
//

import PTCGCard

public struct PTCGDeckCard {

    private let anyContent: AnyPTCGCard
    
    public var content: PTCGCard {
        anyContent.card
    }
    
    public let identifier: PTCGDeckCardIdentifier

    public init(with card: AnyPTCGCard, _ identifier: PTCGDeckCardIdentifier) {
        self.anyContent = card
        self.identifier = identifier
    }
}

extension PTCGDeckCard: Equatable {

    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.anyContent.card.id == rhs.anyContent.card.id
            && lhs.anyContent.card.name == rhs.anyContent.card.name
            && lhs.anyContent.card.category == rhs.anyContent.card.category
            && lhs.identifier == rhs.identifier
    }
}
