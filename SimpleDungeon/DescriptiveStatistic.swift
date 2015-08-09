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
    
    func grow(parameters: [Float]?)
    func decay(parameters: [Float]?)
    
    func setGrowthFunction(growthFunction: (startingValue: Float, parameters: [Float]?) -> Float) -> Void
    func setDecayFunction(decayFunction: (startingValue: Float, parameters: [Float]?) -> Float) -> Void
}

class CharacterStatistic : DescriptiveStatistic {
    var growthFunction : (startingValue: Float, parameters: [Float]?) -> Float
    var decayFunction  : (startingValue: Float, parameters: [Float]?) -> Float
    
    var currentValue : UInt = 0
    let MAX_VALUE : UInt = 100
    
    var currentProgression : Float = 0.5
    
    init() {
        growthFunction = { (startingValue: Float, parameters: [Float]?) -> Float in
            if let delta = parameters?[0] { return startingValue + delta }
            return startingValue
        }
        
        decayFunction = { (startingValue: Float, parameters: [Float]?) -> Float in
            if let delta = parameters?[0] { return startingValue - delta }
            return startingValue
        }
    }
    
    convenience init(beginningValue : UInt) {
        self.init()
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
            currentValue = min(currentValue + 1, MAX_VALUE)
            
            resolveProgression()
        }
        else if currentProgression < -0.0000001 {
            currentProgression = currentProgression + 1
            currentValue = max(UInt(currentValue - 1), UInt(1))
            
            resolveProgression()
        }
    }
}

