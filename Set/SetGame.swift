//
//  SetGame.swift
//  Set
//
//  Created by YesVladess on 29.08.2019.
//  Copyright © 2019 YesVladess. All rights reserved.
//

import Foundation

///
/// Provides the core functionality of a set game (Model)
///
/// Rules
///
/// The object of the game is to identify a 'set' of three cards from 12 cards laid out on the
/// table. Each card has a variation of the following four features:
///
/// (A) Color:
/// Each card is red, green, or purple.
///
/// (B) Symbol:
/// Each card contains ovals, squiggles, or diamonds.
///
/// (C) Number:
/// Each card has one, two, or three symbols.
///
/// (D) Shading: Each card is solid, open, or striped.
///
/// A 'Set' consists of three cards in which each feature is EITHER the same on each card OR is
/// different on each card. That is to say, any feature in the 'Set' of three cards is either
/// common to all three cards or is different on each card.
///
struct SetGame {
    
    /// Keeps track of the current score
    private(set) var score : Int = 0
    
    /// Create a new set game with no initial cards.
    init() {
        for property1 in 1...3 {
            for property2 in 1...3 {
                for property3 in 1...3 {
                    for property4 in 1...3 {
                        deck.insert(
                            Card(
                                Card.State(rawValue: property1)!,
                                Card.State(rawValue: property2)!,
                                Card.State(rawValue: property3)!,
                                Card.State(rawValue: property4)!
                            )
                        )
                    }
                }
            }
        }
    }
    
    /// The deck of available cards. Starts with all cards in it.
    private(set) var deck = Set<Card>()
    
    ///
    /// The list of open/available/facing-up cards. From these cards, the caller might
    /// evaluate whether or not three cards are a set (`evaluate(_)`).
    ///
    private(set) var hand = Set<Card>()
    
    /// Draw `n` number of random cards from the `deck`, and place them into the `hand` list.
    ///
    /// Returns the cards that were opened.
    @discardableResult
    mutating func draw(n: Int) -> Set<Card> {
        
        // List of opened cards
        var newCards = Set<Card>()
        
        for _ in 1...n {
            if let newCard = deck.removeRandomElement() {
                newCards.insert(newCard)
            }
            else {
                break // no more cards in the deck
            }
        }
        // The new cards will be added to the hand list (and also returned to the caller)
        for card in newCards {
            hand.insert(card)
        }
        return newCards
    }
    
    mutating func reDraw(n: Int) {
        var reDrawnCards = Set<Card>()
        for _ in 1...n {
            if let reDrawnCard = hand.removeRandomElement() {
                reDrawnCards.insert(reDrawnCard)
            }
            else {
                break // no more cards in the deck
            }
        }
        for card in reDrawnCards {
            hand.insert(card)
        }
    }
    
    /// Compute score
    mutating func computeScore(isItSet: Bool, foundTime interval: TimeInterval) {
        if isItSet {
            print("You find a set after \(interval) seconds")
            var scoreModifier = Double(interval/2)
            scoreModifier.round()
            if (scoreModifier == 1) {scoreModifier += 1}
            scoreModifier=1/scoreModifier
            print("You score modifier is \(scoreModifier)")
            let adding = Int(Score.validSet * scoreModifier)
            print("You got \(adding) points")
            score += adding
            print("Current score is \(score)")
        } else { score += Int(Score.invalidSet) }
    }
    
    /// Evaluate the given cards. Return whether or not they are a valid set.
    ///
    /// - Given cards must exist in the `hand` list.
    /// - If cards are a valid match/set, they will be removed from the `openCards` list.
    mutating func evaluateSet(_ card1: Card, _ card2: Card, _ card3: Card) -> Bool {
        // Make sure given cards are actually open
        if !hand.contains(card1) || !hand.contains(card2) || !hand.contains(card3) {
            assertionFailure(("evaluateSet() -> Given cards are not in play"))
        }
        // Evaluate whether or not all variants are ALL-EQUAL or ALL-DIFFERENT.
        func evaluate(_ s1: Card.State, _ s2: Card.State, _ s3: Card.State) -> Bool {
            return (s1==s2 && s1==s3) || ((s1 != s2) && (s1 != s3) && (s2 != s3))
        }
        // Evaluate each property.
        let property1 = evaluate(card1.property1, card2.property1, card3.property1)
        let property2 = evaluate(card1.property2, card2.property2, card3.property2)
        let property3 = evaluate(card1.property3, card2.property3, card3.property3)
        let property4 = evaluate(card1.property4, card2.property4, card3.property4)
        // Whether or not the given cards are a valid set
        let isSet = (property1 && property2 && property3 && property4)
        // If cards were a valid set, remove them from the openCards list
        if isSet {
            if let index = hand.firstIndex(of: card1) {
                hand.remove(at: index)
            }
            if let index = hand.firstIndex(of: card2) {
                hand.remove(at: index)
            }
            if let index = hand.firstIndex(of: card3) {
                hand.remove(at: index)
            }
        }
        return isSet
    }
    
    /// Determines how many points different actions take.
    private struct Score {
        private init() {}
        static let validSet = +20.0
        static let invalidSet = -10.0
    }
}

extension Set {

    /// Remove (and return) a random element from self.
    /// - Returns nil if self has no elementsNumber
    mutating public func removeRandomElement() -> Element? {
        if self.count > 0 {
            let n = Int.random(in: 0..<self.count)
            let index = self.index(self.startIndex, offsetBy: n)
            let element = self.remove(at: index)
            return element
        } else {
            return nil
        }
    }
}
