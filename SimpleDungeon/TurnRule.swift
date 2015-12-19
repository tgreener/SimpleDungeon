//
//  TurnRule.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 11/16/15.
//  Copyright © 2015 Todd Greener. All rights reserved.
//

import GameplayKit

enum TurnFacts : String {
    case PlayerTurnComplete, AITurnComplete
}

class TurnRule : GKRule {
    
    unowned let ref : BattleRef
    
    init(ref: BattleRef) {
        self.ref = ref
    }
    
    override func evaluatePredicateWithSystem(system: GKRuleSystem) -> Bool {
        return system.gradeForFact(String(TurnFacts.PlayerTurnComplete)) == 1.0 ||
               system.gradeForFact(String(TurnFacts.AITurnComplete)) == 1.0
    }
    
    override func performActionWithSystem(system: GKRuleSystem) {
        ref.battle.currentTurn = ref.battle.currentTurn == Turn.Player ? Turn.Enemy : Turn.Player
    }
}
