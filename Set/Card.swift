//
//  Card.swift
//  Set
//
//  Created by YesVladess on 29.08.2019.
//  Copyright © 2019 YesVladess. All rights reserved.
//

import Foundation

/// Represents a Card used in the `SetGame`
struct Card : Hashable {
    
    let property1: State
    let property2: State
    let property3: State
    let property4: State
    
    /// There are 4 different propeties a card might have. Each propertie's value might vary based
    /// on the `State` option.
    ///
    /// These properties and states are completely generic and not tied to any specific ones. For
    /// instance, a "classic" game would contain:
    ///    - Property1: color
    ///    - Property2: shape
    ///    - Property3: shade
    ///    - Property4: number
    init(_ property1: State, _ property2: State, _ property3: State, _ property4: State) {
        self.property1 = property1
        self.property2 = property2
        self.property3 = property3
        self.property4 = property4
    }

    /// Each feature might contain one of three different states.
    ///
    /// These states are completely generic and not tied to any specific ones.
    enum State: Int {
        case s1 = 1
        case s2 = 2
        case s3 = 3
    }
}

// Conform to `CustomStringConvertible`
extension Card: CustomStringConvertible {
    var description: String {
        return "[\(property1.rawValue), \(property2.rawValue), \(property3.rawValue), \(property4.rawValue)]"
    }
}

// Conform to `Equatable`
extension Card: Equatable {
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return (
            (lhs.property1 == rhs.property1) &&
            (lhs.property2 == rhs.property2) &&
            (lhs.property3 == rhs.property3) &&
            (lhs.property4 == rhs.property4)
        )
    }
}
