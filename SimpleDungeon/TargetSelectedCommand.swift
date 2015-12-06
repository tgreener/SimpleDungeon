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
    
    unowned let model : BattleModel
    unowned let target: Entity
    
    init(battle : BattleModel, target : Entity) {
        self.model  = battle
        self.target = target
    }
    
    func runCommand() {
        let actionsRuleSystem : GKRuleSystem = GKRuleSystem()
        
        actionsRuleSystem.addRule(TargetSelectedRule(battle: self.model, target: self.target))
        
        actionsRuleSystem.evaluate()
    }
}
