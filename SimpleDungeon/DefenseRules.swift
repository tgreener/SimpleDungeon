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

class DidBlockRule : GKRule {
    unowned let ref : BattleRef
    unowned let defender : Entity
    unowned let attacker : GameCharacter
    
    init(ref : BattleRef, defender : Entity, attacker : GameCharacter) {
        self.ref = ref
        self.defender = defender
        self.attacker = attacker
    }
    
    override func evaluatePredicateWithSystem(system: GKRuleSystem) -> Bool {
        return system.gradeForFact(String(DefenseResultFact.Block)) == 1.0
    }
    
    override func performActionWithSystem(system: GKRuleSystem) {
        defender.graphicComponent?.battleGraphic?.showBlockPopup()
    }
}

class DidParryRule : GKRule {
    unowned let ref : BattleRef
    unowned let defender : Entity
    unowned let attacker : GameCharacter
    
    init(ref : BattleRef, defender : Entity, attacker : GameCharacter) {
        self.ref = ref
        self.defender = defender
        self.attacker = attacker
    }
    
    override func evaluatePredicateWithSystem(system: GKRuleSystem) -> Bool {
        return system.gradeForFact(String(DefenseResultFact.Parry)) == 1.0
    }
    
    override func performActionWithSystem(system: GKRuleSystem) {
        defender.graphicComponent?.battleGraphic?.showParryPopup()
    }
}

class DidDodgeRule : GKRule {
    unowned let ref : BattleRef
    unowned let defender : Entity
    unowned let attacker : GameCharacter
    
    init(ref : BattleRef, defender : Entity, attacker : GameCharacter) {
        self.ref = ref
        self.defender = defender
        self.attacker = attacker
    }
    
    override func evaluatePredicateWithSystem(system: GKRuleSystem) -> Bool {
        return system.gradeForFact(String(DefenseResultFact.Dodge)) == 1.0
    }
    
    override func performActionWithSystem(system: GKRuleSystem) {
        defender.graphicComponent?.battleGraphic?.showDodgePopup()
    }
}

class FailedDefenseRule : GKRule {
    unowned let ref : BattleRef
    unowned let defender : Entity
    unowned let attacker : GameCharacter
    
    init(ref : BattleRef, defender : Entity, attacker : GameCharacter) {
        self.ref = ref
        self.defender = defender
        self.attacker = attacker
    }
    
    override func evaluatePredicateWithSystem(system: GKRuleSystem) -> Bool {
        return system.gradeForFact(String(DefenseResultFact.Fail)) == 1.0
    }
    
    override func performActionWithSystem(system: GKRuleSystem) {
        defender.characterComponent?.health.decrease(attacker.power)
        defender.graphicComponent?.battleGraphic?.showDamagePopup(attacker.power)

        if defender.characterComponent?.health.currentValue == 0 {
            ref.battle.notifier.notify() { listener in listener.onEntityDestroyed(self.defender) }
            ref.battle.badGuys = ref.battle.badGuys.filter() { $0 !== self.defender }
        }
    }
}
