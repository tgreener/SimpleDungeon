//
//  TargetSelectedCommand.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 12/5/15.
//  Copyright © 2015 Todd Greener. All rights reserved.
//

import Foundation
import GameplayKit

struct TargetSelectedCommand : BattleCommand {
    
    unowned let ref : BattleRef
    unowned let target: Entity
    
    init(ref : BattleRef, target : Entity) {
        self.ref  = ref
        self.target = target
    }
    
    func runCommand() {
        
        guard let currentSkill = ref.battle.currentSkill else { return }
        ref.battle.primaryTarget = target
        currentSkill.setTarget(ref.battle.badGuys, primary: target)
        
        ref.playerInteractionRuleSystem.assertFact(String(PlayerBattleFlowFacts.TargetSelected))
    }
}
