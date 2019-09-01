//
//  Card.swift
//  Set
//
//  Created by YesVladess on 29.08.2019.
//  Copyright © 2019 YesVladess. All rights reserved.
//

import Foundation

struct Card : Equatable {
    
    let number : Int
    let symbol : String
    let shading : String
    let color : String
    
    // Not clean enough?
    //var isSelected = false
    //var onBoard = false
    
    private var identifier: Int
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init(numberOfShapes number : Int, cardSymbol symbol : String, shapeShading shading : String, cardColor color : String) {
        self.number = number
        self.symbol = symbol
        self.shading = shading
        self.color = color
        self.identifier = Card.getUniqueIdentifier()
    }
    
}
