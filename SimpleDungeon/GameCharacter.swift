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
    
    var health : CharacterResource
    var magic  : CharacterResource
    
    var power : Int { get { return inventory.equipment.calculateBonus(EquipmentAffix.Bonus.Power) } }
    var spell : Int { get { return inventory.equipment.calculateBonus(EquipmentAffix.Bonus.Spell) } }
    var hit   : Int { get { return inventory.equipment.calculateBonus(EquipmentAffix.Bonus.Hit) } }
    var dodge : Int { get { return inventory.equipment.calculateBonus(EquipmentAffix.Bonus.Dodge) } }
    var block : Int { get { return inventory.equipment.calculateBonus(EquipmentAffix.Bonus.Block) } }
    var parry : Int { get { return inventory.equipment.calculateBonus(EquipmentAffix.Bonus.Parry) } }
    
    var isDead : Bool { get { return health.currentValue == 0 } }
    
    let inventory : Inventory = Inventory()
    let isPlayer  : Bool
    
    init(strVal : UInt, intVal : UInt, wilVal : UInt, isPlayer : Bool = false) {
        strength = CharacterStatistic(name : "Strength", beginningValue: strVal)
        intelligence = CharacterStatistic(name : "Intelligence", beginningValue: intVal)
        will = CharacterStatistic(name : "Will", beginningValue: wilVal)
        
        health = BaseCharacterResource()
        magic  = BaseCharacterResource()
        
        self.isPlayer = isPlayer
    }
    
    func onSuccessfulStrengthChallenge(difficulty difficulty : UInt) {
        onSuccessfulChallenge(difficulty: difficulty, stat: strength)
    }
    
    func onSuccessfulIntelligenceChallenge(difficulty difficulty : UInt) {
        onSuccessfulChallenge(difficulty: difficulty, stat: intelligence)
    }
    
    func onSuccessfulWillChallenge(difficulty difficulty : UInt) {
        onSuccessfulChallenge(difficulty: difficulty, stat: will)
    }
    
    func onSuccessfulChallenge(difficulty difficulty : UInt, stat : DescriptiveStatistic) {
        let boundedDifficulty = min(max(difficulty, 1), 10)
        stat.grow([Float(boundedDifficulty) / 50])
    }
    
    func gameClockAdvanced(dt : Float) {
        
        func makeRandomizedDecay(numerator : Float) -> Float {
            let randomModiferAmount : Float = Float(random(0, maxVal: 10))
            let randomSignDecider : Float = Float(random(1, maxVal: 100))
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
