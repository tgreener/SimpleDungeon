//
//  CharacterResource.swift
//  TextRPG
//
//  Created by Todd Greener on 4/18/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import Foundation

protocol CharacterResource {
    var currentValue : UInt { get }
    
    mutating func increase(delta : UInt)
    mutating func decrease(delta : UInt)
}

struct BaseCharacterResource : CharacterResource {
    var currentValue : UInt
    
    let MAX_VALUE : UInt = 100
    
    init(startingValue: UInt) {
        currentValue = startingValue
    }
    
    mutating func increase(delta: UInt) {
        currentValue = min(currentValue + delta, MAX_VALUE)
    }
    
    mutating func decrease(delta: UInt) {
        currentValue = currentValue > delta ? currentValue - delta : 0
    }
}
