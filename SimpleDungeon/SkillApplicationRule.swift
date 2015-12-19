//
//  SkillApplicationRule.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 12/10/15.
//  Copyright © 2015 Todd Greener. All rights reserved.
//

import GameplayKit

class SkillApplicationRule : GKRule {
    
    unowned let targetCharacter : GameCharacter
    
    init(target : GameCharacter) {
        targetCharacter = target
    }
    
    override func evaluatePredicateWithSystem(system: GKRuleSystem) -> Bool {
        return true // What is this rule ACTUALLY predicated on?
    }
    
    override func performActionWithSystem(system: GKRuleSystem) {
        let defenseRoll : Int = Int(random(0, maxVal: 99))
        
        if defenseRoll < targetCharacter.block {
            system.assertFact(String(DefenseResultFact.Block))
        }
        else if defenseRoll < (targetCharacter.block + targetCharacter.dodge) {
            system.assertFact(String(DefenseResultFact.Parry))
        }
        else if defenseRoll < (targetCharacter.block + targetCharacter.dodge + targetCharacter.parry) {
            system.assertFact(String(DefenseResultFact.Dodge))
        }
        else {
            system.assertFact(String(DefenseResultFact.Fail))
        }
    }
}
