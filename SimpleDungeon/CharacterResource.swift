//
//  CharacterResource.swift
//  TextRPG
//
//  Created by Todd Greener on 4/18/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import Foundation

enum CharacterResourceChange {
    case Increase, Decrease
}

protocol CharacterResource {
    var currentValue : UInt { get }
    
    mutating func increase(delta : UInt)
    mutating func decrease(delta : UInt)
    mutating func addListener(listener : (currentValue: UInt, delta: UInt, change: CharacterResourceChange) -> Void)
}

struct BaseCharacterResource : CharacterResource {
    var currentValue : UInt
    var changeListeners = Array<((currentValue: UInt, delta: UInt, change: CharacterResourceChange) -> Void)>()
    
    let MAX_VALUE : UInt = 100
    
    init() {
        currentValue = MAX_VALUE
    }
    
    init(startingValue: UInt) {
        currentValue = startingValue
    }
    
    mutating func increase(delta: UInt) {
        let previousValue = currentValue
        currentValue = min(currentValue + delta, MAX_VALUE)
        notifyListeners(currentValue - previousValue, change: CharacterResourceChange.Decrease)
    }
    
    mutating func decrease(delta: UInt) {
        let previousValue = currentValue
        currentValue = currentValue > delta ? currentValue - delta : 0
        notifyListeners(previousValue - currentValue, change: CharacterResourceChange.Decrease)
    }
    
    mutating func addListener(listener : (currentValue: UInt, delta: UInt, change: CharacterResourceChange) -> Void) {
        changeListeners.append(listener)
    }
    
    func notifyListeners(delta: UInt, change: CharacterResourceChange) {
        for listener in changeListeners {
            listener(currentValue: currentValue, delta: delta, change: change)
        }
    }
}
