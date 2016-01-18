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
    func onBattleEnded() -> Void
    
    func onActionPerformed() -> Void
}

class BattleModel {
    let notifier : Notifier<BattleListener> = Notifier<BattleListener>()
    
    var badGuys : [Entity]
    var entityIndexes : [Entity : Int] = [Entity : Int]()
    
    let player  : Entity
    var currentSkill : Skill?
    var primaryTarget: Entity? { didSet {
        guard let t = primaryTarget else { return }
        notifier.notify { listener in listener.didSetPrimaryTarget(t) }
    }}
    
    var currentTurn : Turn = Turn.Player
    
    init(player : Entity, badGuys : [Entity]) {
        self.player = player
        self.badGuys = badGuys
        
        for (index, guy) in self.badGuys.enumerate() {
            entityIndexes[guy] = index
        }
    }
}
