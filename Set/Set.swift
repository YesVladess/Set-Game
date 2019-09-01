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
    
    let handSize = 12
    
    
    // MARK: methods
    func isCardSelected(at index : Int) -> Bool {
        if (selectedCards.contains(hand[index])) {
            return true
        }
        else {
            return false
        }
    }
    
    func selectCard(at index : Int) {
        selectedCards.append(hand[index])
    }
        
    func deselectCard(at index: Int) {
        // Force unwrap here ?!?!?!?
        selectedCards.remove(at: selectedCards.firstIndex(of: hand[index])!)
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
        
        // Пока в тестовом режиме всегда возвращаем true
        //return true
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
                        deck.append(Card(number: number, symbol: symbol, shading: shading, color: color))
                    }
                }
            }
        }
        
        deck.shuffle()
        for _ in 1...handSize {
            hand.append(deck.remove(at: deck.endIndex-1))
        }
    }
    
    
}
