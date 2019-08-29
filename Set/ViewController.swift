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
        // Do any additional setup after loading the view.
    }


    @IBAction private func touchCard(_ sender: UIButton) {
        print("check")
    }
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    
    
    @IBAction private func dealThreeMore(_ sender: UIButton) {
    }
    
    
    @IBAction private func newGame(_ sender: UIButton) {
    }
    
    
    @IBOutlet private weak var scoreLabel: UILabel!
}

