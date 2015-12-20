//
//  ActionSelectedCommand.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 12/5/15.
//  Copyright © 2015 Todd Greener. All rights reserved.
//

import Foundation

struct ActionSelectedCommand : BattleCommand {
    unowned let ref : BattleRef
    unowned let skill : Skill
    
    init(ref : BattleRef, skill : Skill) {
        self.ref = ref
        self.skill = skill
    }
    
    func runCommand() -> Void {
        ref.battle.currentSkill = self.skill
        ref.playerInteractionRuleSystem.assertFact(String(BattleFlowFacts.SkillSelected))
    }
}
