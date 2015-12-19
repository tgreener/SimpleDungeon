//
//  BadGuyActionRule.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 12/15/15.
//  Copyright © 2015 Todd Greener. All rights reserved.
//

import GameplayKit

class BadGuyBattleActionRule : GKRule {
    var badGuyInfo : [((guy : Entity, inout hasActed : Bool) -> Void) -> Void]
    var currentIndex : Int = 0
    
    unowned let player : Entity
    unowned let ref : BattleRef
    
    init(guys : [Entity], player : Entity, ref : BattleRef) {
        badGuyInfo = Array<(((guy : Entity, inout hasActed : Bool) -> Void) -> Void)>()
        
        for guy in guys {
            badGuyInfo.append { (method : (guy : Entity, inout hasActed : Bool) -> Void) in
                var hasActed = false
                method(guy: guy, hasActed: &hasActed)
            }
        }
        
        self.player = player
        self.ref = ref
    }
    
    override func evaluatePredicateWithSystem(system: GKRuleSystem) -> Bool {
        var result = false
        
        for info in badGuyInfo {
            info { (guy : Entity, inout hasActed : Bool) in
                guard !hasActed else { return }
                result = true
            }
        }
        
        return result
    }
    
    override func performActionWithSystem(system: GKRuleSystem) {
        guard currentIndex < badGuyInfo.count else { return }
        badGuyInfo[currentIndex] { (guy : Entity, inout hasActed : Bool) in
            self.currentIndex++
            guard !hasActed else { return }
            
            let badSkill = Skill(character: guy.characterComponent!, targetFilterCreator: skillTargetNone)
            badSkill.setTarget([], primary: self.player)
            
            self.performAction(badSkill)
            
            hasActed = true
        }
    }
    
    func performActionOnTarget(target: Entity, attacker: GameCharacter) {
        guard let targetCharacter = target.characterComponent else { return }
        
        let skillApplicationRuleSystem = GKRuleSystem()
        skillApplicationRuleSystem.addRule(SkillApplicationRule(target: targetCharacter))
        skillApplicationRuleSystem.addRule(DidBlockRule(ref: ref, defender: target, attacker: attacker))
        skillApplicationRuleSystem.addRule(DidParryRule(ref: ref, defender: target, attacker: attacker))
        skillApplicationRuleSystem.addRule(DidDodgeRule(ref: ref, defender: target, attacker: attacker))
        skillApplicationRuleSystem.addRule(FailedDefenseRule(ref: ref, defender: target, attacker: attacker))
        
        skillApplicationRuleSystem.evaluate()
    }
    
    func performAction(skill: Skill) {
        guard let primaryTarget = skill.primaryTarget else {return}
        performActionOnTarget(primaryTarget, attacker: skill.character)
        
        for guy in skill.targets {
            guard let target = guy else { continue }
            performActionOnTarget(target, attacker: skill.character)
        }
    }
}
