//
//  PlayerCharacter.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 8/7/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import Foundation

protocol GameCharacterDelegate : class{
    func didDie() -> Void
    func didReceiveDamage(damageValue: UInt) -> Void
    func didReceiveHealing(healingValue: UInt) -> Void
}

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
    var statVec: CharacterDescriptionVector {
        get {
            return CharacterDescriptionVector(
                intellect: Float(intelligence.currentValue),
                strength: Float(strength.currentValue),
                will: Float(will.currentValue)
            )
        }
    }
    
    let inventory : Inventory = Inventory()
    let isPlayer  : Bool
    let MIN_VEC_LENGTH : Float = sqrtf(powf(Float(CharacterStatistic.MIN_VALUE), 2) * 3)
    
    weak var delegate : GameCharacterDelegate? {
        didSet {
            health.addListener { [weak delegate, unowned self] (currentValue: UInt, delta: UInt, change: CharacterResourceChange) in
                if self.isDead { delegate?.didDie() }
                if change == CharacterResourceChange.Increase { delegate?.didReceiveHealing(delta) }
                if change == CharacterResourceChange.Decrease { delegate?.didReceiveDamage(delta) }
            }
        }
    }
    
    init(strVal : UInt, intVal : UInt, wilVal : UInt, isPlayer : Bool = false) {
        strength = CharacterStatistic(name : "Strength", beginningValue: strVal)
        intelligence = CharacterStatistic(name : "Intelligence", beginningValue: intVal)
        will = CharacterStatistic(name : "Will", beginningValue: wilVal)
        
        health = BaseCharacterResource()
        magic  = BaseCharacterResource()
        
        self.isPlayer = isPlayer
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
        
        printCharacterStats()
    }
    
    func calculateChangeFromVector(vec: CharacterDescriptionVector) {
        guard vec.strength >= 0 && vec.intellect >= 0 && vec.will >= 0 else { return }
        
        let coefficient = vectorCoefficient(self.statVec.length)
        let finalVector = vec.normalize() * coefficient
        
        strength.grow([finalVector.strength])
        intelligence.grow([finalVector.intellect])
        will.grow([finalVector.will])
        
        printCharacterStats()
    }
    
    func vectorCoefficient(vectorLength : Float) -> Float {
        let exponent : Float = 3
        let slopeCoefficient : Float = 0.05
        
        let numerator = slopeCoefficient * powf((vectorLength - MIN_VEC_LENGTH), exponent)
        let denominator = numerator + 1
        
        return 1 - (numerator / denominator)
    }
    
    func printCharacterStats() {
        NSLog("*** Current Character Stats ***")
        NSLog("Str  : %d, %f", strength.currentValue, strength.currentProgression)
        NSLog("Int  : %d, %f", intelligence.currentValue, intelligence.currentProgression)
        NSLog("Will : %d, %f", will.currentValue, will.currentProgression)
        NSLog("*******************************")
    }
}
