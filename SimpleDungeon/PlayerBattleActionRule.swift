//
//  PerformBattleActionRule.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 12/14/15.
//  Copyright © 2015 Todd Greener. All rights reserved.
//

import GameplayKit

class PlayerBattleActionRule : GKRule {
    
    unowned let ref : BattleRef
    
    init(ref : BattleRef) {
        self.ref = ref
    }
    
    override func evaluatePredicateWithSystem(system: GKRuleSystem) -> Bool {
        guard let _ = ref.battle.currentSkill  else { return false }
        guard let _ = ref.battle.primaryTarget else { return false }
        
        return system.gradeForFact(String(BattleFlowFacts.SkillSelected)) == 1.0 &&
            system.gradeForFact(String(BattleFlowFacts.TargetSelected)) == 1.0 &&
            ref.battle.currentTurn == Turn.Player
    }
    
    func performAction(skill: Skill) {
        guard let primaryTarget = skill.primaryTarget else {return}
        performActionOnTarget(primaryTarget, attacker: skill.character)
        
        for guy in skill.targets {
            guard let target = guy else { continue }
            performActionOnTarget(target, attacker: skill.character)
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
    
    override func performActionWithSystem(system: GKRuleSystem) {
        guard let currentSkill = ref.battle.currentSkill else { return }
        
        performAction(currentSkill)
        ref.battle.notifier.notify() { listener in listener.onActionPerformed() }
        
        system.assertFact(String(TurnFacts.PlayerTurnComplete))
    }
}
