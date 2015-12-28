//
//  DefenseRule.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 12/10/15.
//  Copyright © 2015 Todd Greener. All rights reserved.
//

import GameplayKit

enum DefenseResultFact : String {
    case Block, Parry, Dodge, Fail
}

class DefenseRule : GKRule {
    unowned let defender : Entity
    unowned let attacker : GameCharacter
    
    init(defender : Entity, attacker : GameCharacter) {
        self.defender = defender
        self.attacker = attacker
    }
}

class DidBlockRule : DefenseRule {
    override func evaluatePredicateWithSystem(system: GKRuleSystem) -> Bool {
        return system.gradeForFact(String(DefenseResultFact.Block)) == 1.0
    }
    
    override func performActionWithSystem(system: GKRuleSystem) {
        defender.graphicComponent?.battleGraphic?.showBlockPopup()
    }
}

class DidParryRule : DefenseRule {
    override func evaluatePredicateWithSystem(system: GKRuleSystem) -> Bool {
        return system.gradeForFact(String(DefenseResultFact.Parry)) == 1.0
    }
    
    override func performActionWithSystem(system: GKRuleSystem) {
        defender.graphicComponent?.battleGraphic?.showParryPopup()
    }
}

class DidDodgeRule : DefenseRule {
    override func evaluatePredicateWithSystem(system: GKRuleSystem) -> Bool {
        return system.gradeForFact(String(DefenseResultFact.Dodge)) == 1.0
    }
    
    override func performActionWithSystem(system: GKRuleSystem) {
        defender.graphicComponent?.battleGraphic?.showDodgePopup()
    }
}

class FailedDefenseRule : DefenseRule {
    override func evaluatePredicateWithSystem(system: GKRuleSystem) -> Bool {
        return system.gradeForFact(String(DefenseResultFact.Fail)) == 1.0
    }
    
    override func performActionWithSystem(system: GKRuleSystem) {
        defender.characterComponent?.health.decrease(attacker.power > 0 ? UInt(attacker.power) : UInt(0))
    }
}
