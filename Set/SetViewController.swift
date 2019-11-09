//
//  ViewController.swift
//  Set
//
//  Created by YesVladess on 29.08.2019.
//  Copyright © 2019 YesVladess. All rights reserved.
//

import UIKit

///
/// Main view controller for a Set game.
///
class SetViewController: UIViewController {
    
    // MARK: IBOutlets
    
    /// The boardView is a view containing all the cardViews
    ///
    /// Note: This view is transparent in InterfaceBuilder
    @IBOutlet private weak var boardView: UIView!
    
    /// UILabel showing the current score
    @IBOutlet private weak var scoreLabel: UILabel!
    
    // MARK: IBActions
    
    /// What to do when user presses "New Game"
    @IBAction private func newGameButtonPressed() {
        newGame()
    }
    
    /// What to do when user presses "Deal"
    @IBAction private func pressDealButton() {
        cleanupBoard()
        game.draw(n: 3)
        updateUI()
    }
    
    // MARK: Private stored-properties
    
    /// Contains the core functionality of a Set game
    private var game: SetGame!
    
    /// Keep track of which Card represents which CardView. The cardViews are the actual
    ///
    /// CardViews are shown on screen, and the Card is what this view represents.
    private var board: [Card:CardView] = [:]
    
    /// The intitial number of cards to open
    private let initialCards = 9
    
    private var timer : Date?
    
    // MARK: Private computed-properties
    
    /// Returns the list of cards that are currently selected
    private var selectedCards: [Card] {
        var result = [Card]()
        for (card, cardView) in board {
            if cardView.isSelected {
                result.append(card)
            }
        }
        return result
    }
    
    private var currentTime : Date {
        get {
            return Date.init()
        }
    }
    
    // MARK: Method overrides
    
    /// What to do when view loads (i.e. start a game)
    override func viewDidLoad() {
        super.viewDidLoad()
        addBoardViewGestureRecognizers(boardView)
        newGame()
    }
    
    /// What to do when view does subview layout (i.e. update UI when device rotates)
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateUI()
    }
    
    // MARK: Private funcs
    
    /// Create a new game. Updates the boardView, board, scoreLabel, etc.
    private func newGame() {
        boardView.subviews.forEach { $0.removeFromSuperview() }
        board = [:]
        game = SetGame()
        game.draw(n: initialCards)
        timer = currentTime
        updateUI()
    }
    
    /// Update the UI to stay in sync with the model.
    private func updateUI() {
        // Update UILabel showing the current score
        updateScoreLabel()
        
        // Update the `board` dictionary with the open cards from `game.openCards`
        // (i.e. if new cards were open/dealt, we need to add them to the `board` dictionary)
        updateBoard()
        
        // If `board` contains cards not shown on the boardView, add them.
        // (i.e. if new cards were open/dealt, we need to add them to the boardView)
        updateBoardView()
    }
    
    /// Update the scoreLabel to show the current score
    private func updateScoreLabel() {
        scoreLabel.text = "Score: \(game.score)"
    }
    
    /// Add missing cards from game.openCards into the `board` dictionary. For instance, if new
    /// cards were dealt recently (game.draw()), we need to add them into `board`.
    private func updateBoard() {
        for card in game.hand {
            if board[card] == nil {
                board[card] = getCardView(for: card)
            }
        }
    }
    
    /// Update the cardViews from the boardView
    private func updateBoardView() {
        // We need a grid to display cards on screen
        guard let grid = gridForCurrentBoard() else { return }
        // Update each cardView
        for (i, card) in board.enumerated() {
            // Get a frame to place the cardView
            if let cardFrame = grid[i] {
                let cardView = card.value
                // Add a little margin to have spacing between cards
                let margin = min(cardFrame.width, cardFrame.height) * 0.05
                cardView.frame = cardFrame.insetBy(dx: margin, dy: margin)
                // If the cardView hasn't been added to the boardView, add it
                // (i.e. when new cards have been recently dealt/opened)
                if !boardView.subviews.contains(cardView) {
                    boardView.addSubview(cardView)
                }
            }
        }
    }
    
    /// Returns a `Grid` object based on the current number of cards present
    /// in the board
    private func gridForCurrentBoard() -> Grid? {
        // The number of rows and columns we want
        let (rows, columns) = getRowsAndColumns(numberOfCards: board.count)
        // We need at list 1x1 grid to have a valid grid
        guard rows>0, columns>0 else { return nil }
        return Grid(layout: .dimensions(rowCount: rows, columnCount: columns), frame: boardView.bounds)
    }
    
    /// Get a `CardView` object for the given `Card` with all the appropriate gesture recognizers from
    /// `addGestureRecognizers(_:)`
    private func getCardView(for card: Card) -> CardView {
        // The view to populate/return
        let cardView = CardView(frame: CGRect())
        // Color
        switch card.property1 {
            case .s1: cardView.color = .red
            case .s2: cardView.color = .purple
            case .s3: cardView.color = .green
        }
        // Shade
        switch card.property2 {
            case .s1: cardView.shade = .solid
            case .s2: cardView.shade = .striped
            case .s3: cardView.shade = .unfilled
        }
        
        // Shape
        switch card.property3 {
            case .s1: cardView.shape = .oval
            case .s2: cardView.shape = .diamond
            case .s3: cardView.shape = .squiggle
        }
        
        // Number of elements in the card
        switch card.property4 {
            case .s1: cardView.elementsNumber = .one
            case .s2: cardView.elementsNumber = .two
            case .s3: cardView.elementsNumber = .three
        }
        addCardGestureRecognizers(cardView)
        return cardView
    }

    /// Process the current board's state:
    ///    - Cleanup board (remove matched cards from board, de-highlight unmatched cards)
    ///    - If there are three cards selected, process them (i.e. check for match/mismatch)
    private func processBoard() {
        // Cleanup the board (i.e. remove any matched cards or de-highlight unmatched ones)
        cleanupBoard()
        // If there are three selected cards on the board, see if they match or not
        if selectedCards.count == 3 {
            // Check if selected cards are a set
            let isSet = game.evaluateSet(selectedCards[0], selectedCards[1], selectedCards[2])
            if isSet { match(selectedCards) }
            else { mismatch(selectedCards) }
            // Update score and timer accordingly
            let interval = currentTime.timeIntervalSince(timer!)
            game.computeScore(itIsSet: isSet, foundTime: interval)
            updateScoreLabel()
            timer = currentTime
            // Keep UI in sync with the model
            updateUI()
        }
    }
    
    /// Cleanup the board
    private func cleanupBoard() {
        
        // Process each card/cardView in the board
        for (card, cardView) in board {
            // If the game doesn't contain the card, we need to remove it from the boardView.
            // This happends when the card is part of a currently highlighed set that was matched
            // on the previous turn.
            if !game.hand.contains(card) {
                // Remove value from board
                board.removeValue(forKey: card)
                // Remove cardView from superView
                cardView.removeFromSuperview()
                // We just removed a cardView from the superView, update UI!
                updateUI()
            }
            // Set card to be in "regular" state (i.e. not mathced/mismatched)
            // (matched ones shoud no longer be on screen, but mismatched ones should,
            // and we want to "reset" them to a regular state)
            cardView.cardState = .regular
        }
    }
    
    /// Process the given cards as "matched". This means:
    ///    - Deselect card
    ///    - Set it into a "matched" state (i.e. green/success highlight color).
    private func match(_ cards: [Card]) {
        for card in cards {
            if let cardView = board[card] {
                cardView.isSelected = false
                cardView.cardState = .matched
            }
        }
    }
    
    /// Process the given cards as "mismatched". This means:
    ///    - Deselect card
    ///    - Set it into a "mismatched" state (i.e. red/failure highlight color).
    private func mismatch(_ cards: [Card]) {
        for card in cards {
            if let cardView = board[card] {
                cardView.isSelected = false
                cardView.cardState = .mismatched
            }
        }
    }
    
    /// Get the number of rows and columns that will correctly fit the given numberOfCards.
    private func getRowsAndColumns(numberOfCards: Int) -> (rows: Int, columns: Int) {
        // For 0 cards, we don't need any rows/columns
        if numberOfCards <= 0 { return (0, 0) }
        var rows = Int(Double(numberOfCards).squareRoot().rounded())
        let columns = rows
        if (rows*rows) < numberOfCards { rows += 1 }
        return (rows, columns)
    }
    
    // MARK: Gestures
    
    private func swipeDownGesture(_ sender: AnyObject) {
        let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeToDealCards(recognizer:)))
        swipeDownRecognizer.direction = .down
        swipeDownRecognizer.numberOfTouchesRequired = 1
        sender.addGestureRecognizer(swipeDownRecognizer)
    }
    
    private func tapGesture(_ sender: AnyObject) {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapCard(recognizer:)))
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        sender.addGestureRecognizer(tapRecognizer)
    }
    
    private func rotationGesture(_ sender: AnyObject) {
        let rotationRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(handleRotationWithReshuffle(recognizer:)))
        rotationRecognizer.rotation = CGFloat(1.15)
        sender.addGestureRecognizer(rotationRecognizer)
    }
    
    // MARK: Gesture Recognizers
    
    /// Add all gesture recognizers that a card must handle:
    ///    - Tap: Select/deselect card
    private func addCardGestureRecognizers(_ cardView: CardView) {
        tapGesture(cardView)
    }
    
    private func addBoardViewGestureRecognizers(_ boardView: UIView) {
        swipeDownGesture(boardView)
        rotationGesture(boardView)
    }
    
    // MARK: Gesture handlers
    
    /// Deal new cards
    @objc private func swipeToDealCards( recognizer: UISwipeGestureRecognizer) {
        print("swipe gesture is detected")
        guard recognizer.state == .ended else {
            print("Swipe gesture cancelled/failed")
            return
        }
        cleanupBoard()
        game.draw(n: 3)
        updateUI()
    }
    
    /// What to do when the user taps on a card
    @objc private func tapCard( recognizer: UITapGestureRecognizer) {
        print("tap gesture is detected")
        // Make sure the gesture was successful
        guard recognizer.state == .ended else {
            print("Tap gesture cancelled/failed")
            return
        }
        // We want to select/deselect the cardView where the gesture is coming from
        guard let cardView = recognizer.view as? CardView else {
            print("tapCard called from something not a CardView")
            return
        }
        cardView.isSelected = !cardView.isSelected
        processBoard()
    }
    
    @objc private func handleRotationWithReshuffle( recognizer: UIRotationGestureRecognizer) {
        //print("rotation gesture is detected")
        if recognizer.state == .began {
            print("begin")
            return
        } else if recognizer.state == .changed {
            return
        } else if recognizer.state == .ended {
            print("end")
        }
        boardView.subviews.forEach { $0.removeFromSuperview() }
        board = [:]
        cleanupBoard()
        game.reDraw(n: game.hand.count)
        updateUI()
    }
}

// Small utility extension(s) in CardView relevant only to the class in
// this file (the SetViewController)
fileprivate extension CardView {
    
    /// Represents the state of a card in the current game:
    ///    - A "matched" card will show in a "green/success" accent/highlight color.
    ///    - A "mismatched" card will show in a "red/failed" accent/highlight color.
    ///    - A "regular" card will show with no accent/highlight color.
    enum CardState {
        // Regular state (i.e. when starting a game)
        case regular
        // Matched state (the card was correclty selected as part of a valid set)
        case matched
        // Mismatched state (the card was incorreclty selected as part of a set)
        case mismatched
    }
    
    /// The current state of the card
    var cardState: CardState {
        
        get {
            // Mismatch
            if layer.borderColor == #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1).cgColor {
                return .mismatched
            }
                // Match
            else if layer.borderColor == #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1).cgColor {
                return .matched
            }
                // Regular
            else {
                return .regular
            }
        }
        
        set {
            switch newValue {
                
            // Regular state (no accent color)
            case .regular:
                layer.borderWidth = 0.0
                layer.borderColor = UIColor.clear.cgColor
                
            // Matched state (green/success color)
            case .matched:
                layer.borderWidth = bounds.width * 0.1
                layer.borderColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1).cgColor
                
            // Mismatched state (red/fail color)
            case .mismatched:
                layer.borderWidth = bounds.width * 0.1
                layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1).cgColor
            }
        }
    }
}
