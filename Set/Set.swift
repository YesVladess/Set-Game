//
//  SetGame.swift
//  Set
//
//  Created by YesVladess on 29.08.2019.
//  Copyright © 2019 YesVladess. All rights reserved.
//

import Foundation

class Set {
    
    // All of the cards
    var deck = [Card]()
    
    // Cards, that are currently in game
    var hand = [Card]()
    
    // Cards, that are currently selected
    var selectedCards = [Card]()
    
    
    // MARK: methods
    func selectCard(card : Card) {
        selectedCards.append(card)
        
        if (selectedCards.count == 3) {
            if ( match(set : selectedCards) ) {
                for index in selectedCards.indices {
                    hand.remove(at: index)
                    selectedCards.remove(at: index)
                }
            } else {
                selectedCards.removeAll()
            }
        }
    }
    
    func deselectCard(at index: Int) {
        selectedCards.remove(at: index)
    }
    
    func match(set : [Card]) -> Bool {
            if ((selectedCards[1].color == selectedCards[2].color && selectedCards[2].color == selectedCards[0].color)
                || (selectedCards[1].color != selectedCards[2].color && selectedCards[2].color != selectedCards[0].color && selectedCards[1].color != selectedCards[0].color)) {
                if ((selectedCards[1].number == selectedCards[2].number && selectedCards[2].number == selectedCards[0].number)
                    || (selectedCards[1].number != selectedCards[2].number && selectedCards[2].number != selectedCards[0].number && selectedCards[1].number != selectedCards[0].number)) {
                    if ((selectedCards[1].shading == selectedCards[2].shading && selectedCards[2].shading == selectedCards[0].shading)
                        || (selectedCards[1].shading != selectedCards[2].shading && selectedCards[2].shading != selectedCards[0].shading && selectedCards[1].shading != selectedCards[0].shading)) {
                        if ((selectedCards[1].symbol == selectedCards[2].symbol && selectedCards[2].symbol == selectedCards[0].symbol)
                            || (selectedCards[1].symbol != selectedCards[2].symbol && selectedCards[2].symbol != selectedCards[0].symbol && selectedCards[1].symbol != selectedCards[0].symbol)) {
                            return true
                        }
                    }
                }
        }
        return false
    }
    
    func dealThreeMore() {
        hand.append(deck.remove(at: deck.endIndex-1))
        hand.append(deck.remove(at: deck.endIndex-1))
        hand.append(deck.remove(at: deck.endIndex-1))
    }
    
    
    // MARK: - Init
    init(maxShapeNumbers shapes : Int, symbolsTypes symbols : [String], shadingsTypes shadings: [String], shapeColors colors : [String]) {
        
        for number in 1...shapes {
            for symbol in symbols {
                for shading in shadings {
                    for color in colors {
                        deck.append(Card(numberOfShapes: number, cardSymbol: symbol, shapeShading: shading, cardColor: color))
                    }
                }
            }
        }
        
        deck.shuffle()
        for _ in 1...12 {
            hand.append(deck.remove(at: deck.endIndex-1))
        }
    }
    
    
}
