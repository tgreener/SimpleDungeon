//
//  PlayerCharacter.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 8/7/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import Foundation

class GameCharacter {
    var strength     : DescriptiveStatistic
    var intelligence : DescriptiveStatistic
    var will         : DescriptiveStatistic
    
    init(strVal : UInt, intVal : UInt, wilVal : UInt) {
        strength = CharacterStatistic(beginningValue: strVal)
        intelligence = CharacterStatistic(beginningValue: intVal)
        will = CharacterStatistic(beginningValue: wilVal)
    }
    
    func onSuccessfulStrengthChallenge(#difficulty : UInt) {
        onSuccessfulChallenge(difficulty, stat: strength)
    }
    
    func onSuccessfulIntelligenceChallenge(#difficulty : UInt) {
        onSuccessfulChallenge(difficulty, stat: intelligence)
    }
    
    func onSuccessfulWillChallenge(#difficulty : UInt) {
        onSuccessfulChallenge(difficulty, stat: will)
    }
    
    func onSuccessfulChallenge(difficulty : UInt, stat : DescriptiveStatistic) {
        let boundedDifficulty = min(max(difficulty, 1), 10)
        stat.grow([Float(boundedDifficulty) / 50])
    }
    
    func gameClockAdvanced(dt : Float) {
        
        func makeRandomizedDecay(numerator : Float) -> Float {
            let randomModiferAmount : Float = Float(random(0, 10))
            let randomSignDecider : Float = Float(random(1, 100))
            let sign : Float = randomSignDecider < 50 ? 1 : -1
            
            return dt / (50 + (randomModiferAmount * sign))
        }
        
        strength.decay([makeRandomizedDecay(dt)])
        intelligence.decay([makeRandomizedDecay(dt)])
        will.decay([makeRandomizedDecay(dt)])
        
        NSLog("*** Current Character Stats ***")
        NSLog("Str  : %d", strength.currentValue)
        NSLog("Int  : %d", intelligence.currentValue)
        NSLog("Will : %d", will.currentValue)
        NSLog("*******************************")
    }
    
}
