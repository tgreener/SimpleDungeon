//
//  CharacterResource.swift
//  TextRPG
//
//  Created by Todd Greener on 4/18/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import Foundation

protocol CharacterResource {
    var currentValue : Int { get }
    
    mutating func increase(delta : Int)
    mutating func decrease(delta : Int)
}

struct BaseCharacterResource : CharacterResource {
    var currentValue : Int
    
    let MAX_VALUE : Int = 100
    
    init() {
        currentValue = MAX_VALUE
    }
    
    init(startingValue: Int) {
        currentValue = startingValue
    }
    
    mutating func increase(delta: Int) {
        currentValue = min(currentValue + delta, MAX_VALUE)
    }
    
    mutating func decrease(delta: Int) {
        currentValue = currentValue > delta ? currentValue - delta : 0
    }
}
