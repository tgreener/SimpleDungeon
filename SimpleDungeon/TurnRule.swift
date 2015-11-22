//
//  TurnRule.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 11/16/15.
//  Copyright © 2015 Todd Greener. All rights reserved.
//

import Foundation

enum Turn {
    case Player, Enemy
}

class TurnRule {
    unowned let battle : BattleModel
    
    init(battle : BattleModel) {
        self.battle = battle
    }
    
    func applyRule() {
        battle.currentTurn = battle.currentTurn == Turn.Player ? Turn.Enemy : Turn.Player
    }
}
