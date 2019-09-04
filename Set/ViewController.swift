//
//  ViewController.swift
//  Set
//
//  Created by YesVladess on 29.08.2019.
//  Copyright © 2019 YesVladess. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
        // FOR TEST
        game.deck = []
    }
    
    // Init game
    private lazy var game = Set(maxShapeNumbers: 3, symbolsTypes: ["▲", "●", "■"], shadingsTypes: ["solid", "striped", "open"], shapeColors: ["red", "green", "purple"])
    
    private var selectedCardsCount = 0 {
        didSet {
            // Got tree cards selected?
            if (selectedCardsCount == 3) {
                if (game.match(set : game.selectedCards)) {
                    paintSet(paintIt: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1))
                }
                else {
                    paintSet(paintIt: #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1))
                }
            }
        }
    }
    
    func paintSet(paintIt color : UIColor?) {
        for index in game.hand.indices {
            if (game.isCardSelected(at: index)) {
                let button = cardButtons[index]
                button.layer.borderColor = color?.cgColor
            }
        }
    }
    
    
    @IBAction private func touchCard(_ sender: UIButton) {
        
        let cardNumber = cardButtons.firstIndex(of: sender)!
        
            // If there is a match/missmatch already
            if selectedCardsCount == 3 {
                // Need to deselect all 3
                for index in game.hand.indices {
                    if (game.isCardSelected(at: index)) {
                        deselectButton(at: index)
                        selectedCardsCount-=1
                    }
                }
                // Changing deck if set is found
                if (game.match(set : game.selectedCards)) {
                    game.setMatched()
                }
                game.selectedCards.removeAll()
            }
            // If card is already chosen or If card is no longer in the UI
            if game.hand.indices.contains(cardNumber) && game.isCardSelected(at: cardNumber) {
                deselectButton(at: cardNumber)
                game.deselectCard(at: cardNumber)
                selectedCardsCount-=1
            }
            else {
                selectButton(at: cardNumber)
                game.selectCard(at: cardNumber)
                selectedCardsCount+=1
            }
        updateViewFromModel()
        
    }
    
    func deselectButton(at cardNumber : Int) {
        let button = cardButtons[cardNumber]
        button.layer.borderWidth = 1.0
        button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        button.layer.cornerRadius = 1.0
    }
    
    func selectButton(at cardNumber : Int) {
        let button = cardButtons[cardNumber]
        button.layer.borderWidth = 3.0
        button.layer.borderColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        button.layer.cornerRadius = 8.0
    }
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    
    @IBAction private func dealThreeMore(_ sender: UIButton) {
        // Add UI is Full check
        game.dealThreeMore()
        updateViewFromModel()
    }
    
    
    @IBAction private func newGame(_ sender: UIButton) {
        game = Set(maxShapeNumbers: 3, symbolsTypes: ["▲", "●", "■"], shadingsTypes: ["solid", "striped", "open"], shapeColors: ["red", "green", "purple"])
        for index in cardButtons.indices {
            let button = cardButtons[index]
            button.setAttributedTitle(nil, for: UIControl.State.normal)
            deselectButton(at: index)
            button.backgroundColor = #colorLiteral(red: 0.003857404925, green: 0.5896782279, blue: 0.998706758, alpha: 1)
            selectedCardsCount = 0
        }
        updateViewFromModel()
    }
    
    
    @IBOutlet private weak var scoreLabel: UILabel!
    
    
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            if game.hand.indices.contains(index) {
                let card = game.hand[index]
                var title = ""
                for _ in 1...card.number {
                    title = title + card.symbol
                }
                
                var color : UIColor?
                switch (card.color) {
                case "red" : color = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
                case "green" : color = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                case "purple" : color = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
                default :
                    assertionFailure("No such color - \(card.color) can be used!")
                }
                
                var shading = (alphaComponent : 1.0, strokeWidgh : "1")
                switch (card.shading) {
                case "solid" :
                    shading.alphaComponent = 1
                    shading.strokeWidgh = "5"
                case "striped" :
                    shading.alphaComponent = 0.25
                    shading.strokeWidgh = "-5"
                case "open" :
                    shading.alphaComponent = 1
                    shading.strokeWidgh = "-5"
                default :
                    assertionFailure("No such shading type - \(card.shading) can be used!")
                }
                
                let attributes : [NSAttributedString.Key : Any ] = [
                    .strokeColor : color!,
                    .foregroundColor : color!.withAlphaComponent(CGFloat(shading.alphaComponent)),
                    .strokeWidth : shading.strokeWidgh
                ]
                let attributedTitle = NSAttributedString(string: title, attributes: attributes)
                
                button.setAttributedTitle(attributedTitle, for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            } else {
                button.setAttributedTitle(nil, for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                button.layer.borderWidth = 1.0
                button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                button.layer.cornerRadius = 1.0
            }
        }
    }
}






