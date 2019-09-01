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
    }
    
    // init game
    private lazy var game = Set(maxShapeNumbers: 3, symbolsTypes: ["▲", "●", "■"], shadingsTypes: ["solid", "striped", "open"], shapeColors: ["red", "green", "purple"])
    
    
    @IBAction private func touchCard(_ sender: UIButton) {
        print("check")
    }
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    
    
    @IBAction private func dealThreeMore(_ sender: UIButton) {
    }
    
    
    @IBAction private func newGame(_ sender: UIButton) {
        game = Set(maxShapeNumbers: 3, symbolsTypes: ["▲", "●", "■"], shadingsTypes: ["solid", "striped", "open"], shapeColors: ["red", "green", "purple"])
        updateViewFromModel()
    }
    
    
    @IBOutlet private weak var scoreLabel: UILabel!
    
    
    private func updateViewFromModel() {
        for index in game.hand.indices {
            let button = cardButtons[index]
            let card = game.hand[index]
            
            var title = ""
            for _ in 1...card.number {
                title = title + card.symbol
            }
            
            // НУЖНО СДЕЛАТЬ SHADINGS!!!!
            let attributes : [NSAttributedString.Key : Any ] = [
                .strokeWidth : -1,
                .foregroundColor : UIColor.purple.withAlphaComponent(0.15)
            ]
            let attributedTitle = NSAttributedString(string: title, attributes: attributes)
            
            switch (card.color) {
            case "red" :
                button.setTitleColor(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), for: UIControl.State.normal)
            case "green" :
                button.setTitleColor(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), for: UIControl.State.normal)
            case "purple" :
                button.setTitleColor(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), for: UIControl.State.normal)
            default : break
            }
            
            button.setTitle( attributedTitle.string , for: UIControl.State.normal)
            button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
    }
    
    
}






