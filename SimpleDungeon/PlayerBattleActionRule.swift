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
        guard let skill = ref.battle.currentSkill  else { return false }
        guard let _ = skill.target else { return false }
        
        return system.gradeForFact(String(PlayerBattleFlowFacts.SkillSelected)) == 1.0 &&
            system.gradeForFact(String(PlayerBattleFlowFacts.TargetSelected)) == 1.0
    }
    
    override func performActionWithSystem(system: GKRuleSystem) {
        guard let currentSkill = ref.battle.currentSkill else { return }
        
        currentSkill.perform()
        ref.battleView.playerGraphic.doBattleAnimation()
    }
}
