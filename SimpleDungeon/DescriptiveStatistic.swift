//
//  DescriptiveStatistic.swift
//  TextRPG
//
//  Created by Todd Greener on 4/18/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import Foundation

protocol DescriptiveStatistic {
    var currentValue : UInt { get }
    var currentProgression : Float { get }
    var name : String { get }
    
    func grow(parameters: [Float]?)
    func decay(parameters: [Float]?)
    
    func setGrowthFunction(growthFunction: (startingValue: Float, parameters: [Float]?) -> Float) -> Void
    func setDecayFunction(decayFunction: (startingValue: Float, parameters: [Float]?) -> Float) -> Void
    
    static var MAX_VALUE : UInt { get }
    static var MIN_VALUE : UInt { get }
}

class CharacterStatistic : DescriptiveStatistic {
    var growthFunction : (startingValue: Float, parameters: [Float]?) -> Float
    var decayFunction  : (startingValue: Float, parameters: [Float]?) -> Float

    var currentProgression : Float = 0.5
    var currentValue : UInt = 0
    
    let name : String
    static let MAX_VALUE : UInt = 100
    static let MIN_VALUE : UInt = 1
    
    init(name : String) {
        growthFunction = { (startingValue: Float, parameters: [Float]?) -> Float in
            if let delta = parameters?[0] { return startingValue + delta }
            return startingValue
        }
        
        decayFunction = { (startingValue: Float, parameters: [Float]?) -> Float in
            if let delta = parameters?[0] { return startingValue - delta }
            return startingValue
        }
        
        self.name = name
    }
    
    convenience init(name : String, beginningValue : UInt) {
        self.init(name : name)
        currentValue = beginningValue
    }
    
    func setGrowthFunction(growthFunction: (startingValue: Float, parameters: [Float]?) -> Float) {
        self.growthFunction = growthFunction
    }
    
    func setDecayFunction(decayFunction: (startingValue: Float, parameters: [Float]?) -> Float) {
        self.decayFunction = decayFunction
    }
    
    func grow(parameters: [Float]?) {
        currentProgression = growthFunction(startingValue: currentProgression, parameters: parameters);
        resolveProgression()
    }
    
    func decay(parameters: [Float]?) {
        currentProgression = decayFunction(startingValue: currentProgression, parameters: parameters)
        resolveProgression()
    }
    
    func resolveProgression() {
        if currentProgression >= 1 {
            currentProgression = currentProgression - 1
            currentValue = min(currentValue + 1, CharacterStatistic.MAX_VALUE)
            
            resolveProgression()
        }
        else if currentProgression < -0.0000001 {
            currentProgression = currentProgression + 1
            currentValue = max(UInt(currentValue - 1), CharacterStatistic.MIN_VALUE)
            
            resolveProgression()
        }
    }
}

