//
//  TurnRule.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 11/16/15.
//  Copyright © 2015 Todd Greener. All rights reserved.
//

import GameplayKit

enum Turn {
    case Player, Enemy
}

enum TurnFacts : String {
    case PlayerTurnComplete, AITurnComplete
}

class TurnRule : GKRule {
    
    unowned let battle : BattleModel
    
    init(battle: BattleModel) {
        self.battle = battle
    }
    
    override func evaluatePredicateWithSystem(system: GKRuleSystem) -> Bool {
        return system.gradeForFact(String(TurnFacts.PlayerTurnComplete)) == 1.0 ||
               system.gradeForFact(String(TurnFacts.AITurnComplete)) == 1.0
    }
    
    override func performActionWithSystem(system: GKRuleSystem) {
        self.battle.currentTurn = self.battle.currentTurn == Turn.Player ? Turn.Enemy : Turn.Player
    }
}
