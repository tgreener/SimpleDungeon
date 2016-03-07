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
    let target: BattleGridPosition
    
    init(ref : BattleRef, target : BattleGridPosition) {
        self.ref  = ref
        self.target = target
    }
    
    func runCommand() {
        guard let currentSkill = ref.battle.currentSkill else { return }
        currentSkill.setTarget(target)
        
        ref.battleView.primaryTargetChosen(target.entity!.graphicComponent!.battleGraphic!, target: target.entity!)
        ref.playerInteractionRuleSystem.assertFact(String(PlayerBattleFlowFacts.TargetSelected))
    }
}
