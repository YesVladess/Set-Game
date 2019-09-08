//
//  CardButton.swift
//  Set
//
//  Created by YesVladess on 08.09.2019.
//  Copyright © 2019 YesVladess. All rights reserved.
//

import UIKit

///
/// Represents a UI card button/view to play a Set game
///
/// *** Note **************
/// Implementation for this class is not good and lacks comments since the next
/// assignment we'll be replacing it for a good design with custom views.
/// ***********************
///
class CardButton: UIButton {
    
    var card: Card? {
        didSet {
            if card == nil {
                isHidden = true
                setAttributedTitle(NSAttributedString(), for: .normal)
            }
            else {
                setAttributedTitle(titleForCard(card!), for: .normal)
                isHidden = false
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
    }
    
    private func initialSetup() {
        layer.cornerRadius = frame.width * 0.2
        layer.borderColor = UIColor.lightGray.cgColor
        isHidden = true // shown until card is set
    }
    
    func toggleCardSelection() {
        cardIsSelected = !cardIsSelected
    }
    
    var cardIsSelected: Bool {
        get {
            return layer.borderColor == #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        }
        set {
            if newValue == true {
                layer.borderWidth = 3.0
                layer.borderColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            }
            else {
                layer.borderWidth = 0.0
                layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            }
        }
    }
    
    private func titleForCard(_ card: Card) -> NSAttributedString {
        
        // Assignment 2 (Task #11):
        // "Instead of drawing the Set cards in the classic form (we’ll do that next week), we’ll
        // use these three characters ▲ ● ■ and use attributes in NSAttributedString to draw them
        // appropriately. That way your cards can just be UIButtons."
        
        var symbol: String
        
        // SHAPE
        switch card.property1 {
        case .s1: symbol = "▲"
        case .s2: symbol = "●"
        case .s3: symbol = "■"
        }
        
        var color: UIColor
        
        // COLOR
        switch card.property2 {
        case .s1: color = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        case .s2: color = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        case .s3: color = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        }
        
        var filled: Bool
        
        // SHADE
        switch card.property3 {
        // Not filled
        case .s1:
            filled = false; color = color.withAlphaComponent(1.0)
        // Shaded
        case .s2:
            filled = true; color = color.withAlphaComponent(0.40)
        // Filled
        case .s3:
            filled = true; color = color.withAlphaComponent(1.0)
        }
        
        // NUMBER
        switch card.property4 {
        // One
        case .s1: break
        // Two
        case .s2: symbol += "" + symbol
        // Trhee
        case .s3: symbol += "" + symbol + "" + symbol
        }
        
        let attributes: [NSAttributedString.Key:Any] = [
            NSAttributedString.Key.strokeWidth :
                1.0 * (filled ? -5.0 : 5.0),
            NSAttributedString.Key.foregroundColor :
                color,
            NSAttributedString.Key.strokeColor:
                color
        ]
        
        let attributedString = NSAttributedString(string: symbol, attributes: attributes)
        
        return attributedString
    }
}
