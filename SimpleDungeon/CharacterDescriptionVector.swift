//
//  CharacterDescriptionVector.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 12/29/15.
//  Copyright © 2015 Todd Greener. All rights reserved.
//

import Foundation

struct CharacterDescriptionVector {
    let intellect : Float
    let strength  : Float
    let will      : Float
    
    static let zero : CharacterDescriptionVector = CharacterDescriptionVector(intellect: 0, strength: 0, will: 0)
    static let normInt = CharacterDescriptionVector(intellect: 1, strength: 0, will: 0)
    static let normStr = CharacterDescriptionVector(intellect: 0, strength: 1, will: 0)
    static let normWil = CharacterDescriptionVector(intellect: 0, strength: 0, will: 1)
    
    var length : Float {
        get { return sqrtf(self * self) }
    }
    
    init(intellect : Float, strength : Float, will : Float) {
        self.will = will
        self.strength = strength
        self.intellect = intellect
    }
    
    func dot(rhs : CharacterDescriptionVector) -> Float {
        return (self.intellect * rhs.intellect) + (self.strength * rhs.strength) + (self.will * rhs.will)
    }
    
    func normalize() -> CharacterDescriptionVector {
        return self / length
    }
}

/**
 * Vector Addition
 */
func + (lhs : CharacterDescriptionVector, rhs : CharacterDescriptionVector) -> CharacterDescriptionVector {
    return CharacterDescriptionVector(
        intellect: lhs.intellect + rhs.intellect,
        strength: lhs.strength + rhs.strength,
        will: lhs.will + rhs.will
    )
}

/**
 * Vector Subtraction
 */
func - (lhs : CharacterDescriptionVector, rhs : CharacterDescriptionVector) -> CharacterDescriptionVector {
    return lhs + (rhs * -1)
}

/**
 * Scalar Product
 */
func * (lhs : Float, rhs : CharacterDescriptionVector) -> CharacterDescriptionVector {
    return CharacterDescriptionVector(intellect: lhs * rhs.intellect, strength: lhs * rhs.strength, will: lhs * rhs.will)
}

/**
 * Scalar Product
 */
func * (lhs : CharacterDescriptionVector, rhs : Float) -> CharacterDescriptionVector {
    return rhs * lhs
}

/**
 * Scalar Product, shorthand for lhs * (1 / rhs)
 */
func / (lhs : CharacterDescriptionVector, rhs : Float) -> CharacterDescriptionVector {
    return lhs * (1 / rhs)
}

/**
 * Dot Product
 */
func * (lhs : CharacterDescriptionVector, rhs : CharacterDescriptionVector) -> Float {
    return lhs.dot(rhs)
}
