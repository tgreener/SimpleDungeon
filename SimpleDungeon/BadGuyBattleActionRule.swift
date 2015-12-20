//
//  BadGuyActionRule.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 12/15/15.
//  Copyright © 2015 Todd Greener. All rights reserved.
//

import GameplayKit

// TODO: Give bad guys a little bit of a brain, but for now I don't need this

class BadGuyBattleActionRule : GKRule {
    override func evaluatePredicateWithSystem(system: GKRuleSystem) -> Bool {
        return false
    }
    
    override func performActionWithSystem(system: GKRuleSystem) {
        
    }
}
