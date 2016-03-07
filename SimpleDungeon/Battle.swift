//
//  Battle.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 8/12/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import Foundation

enum Turn {
    case Player, Enemy
}

protocol BattleListener {
    func didSetPrimaryTarget(entity : Entity) -> Void
}

class BattleModel {
    let notifier : Notifier<BattleListener> = Notifier<BattleListener>()

    let player  : Entity
    let playerPosition : BattleGridPosition
    
    let battleGrid : BattleGrid
    var badGuys : [Entity]
    
    var currentSkill : Skill?

    init(player : Entity, badGuys : [Entity], battleGrid : BattleGrid) {
        self.player = player
        self.playerPosition = BaseBattleGrid.GridPosition(entity: player)
        self.badGuys = badGuys
        
        self.battleGrid = battleGrid
    }
}
