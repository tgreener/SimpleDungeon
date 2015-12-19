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
    func onEntityDestroyed(entity : Entity) -> Void
    func didSetPrimaryTarget(entity : Entity) -> Void
    func onBattleEnded() -> Void
    
    func onActionPerformed() -> Void
    func onTurnChanged(turn : Turn) -> Void
}

// Super janky proto-demo/just-make-it work code
enum Ability {
    case Str, Int, Wil, None
}
// End jankiness //

class BattleModel {
    let notifier : Notifier<BattleListener> = Notifier<BattleListener>()
    
    var badGuys : [Entity?]
    var entityIndexes : [Entity : Int] = [Entity : Int]()
    
    let player  : Entity
    var currentSkill : Skill?
    var primaryTarget: Entity? { didSet {
        guard let t = primaryTarget else { return }
        notifier.notify { listener in listener.didSetPrimaryTarget(t) }
    }}
    
    let strSkill : Skill
    let intSkill : Skill
    let wilSkill : Skill
    
    var currentTurn : Turn = Turn.Player { didSet {
        notifier.notify { listener in listener.onTurnChanged(self.currentTurn) }
    }}

    init(player : Entity, badGuys : [Entity?]) {
        self.player = player
        self.badGuys = badGuys
        
        for (index, g) in self.badGuys.enumerate() {
            if let guy = g { entityIndexes[guy] = index }
        }
        
        strSkill = Skill(character: player.characterComponent!, targetFilterCreator: skillTargetNone)
        intSkill = Skill(character: player.characterComponent!, targetFilterCreator: skillTargetRow)
        wilSkill = Skill(character: player.characterComponent!, targetFilterCreator: skillTargetNextInColumn)
        
        strSkill.updateTargetFilter(self)
        intSkill.updateTargetFilter(self)
        wilSkill.updateTargetFilter(self)
    }
}
