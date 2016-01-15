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

// Super janky proto-demo/just-make-it work code
enum Ability {
    case Str, Int, Wil, None
}
// End jankiness //

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
    
    let strSkill : Skill
    let intSkill : Skill
    let wilSkill : Skill
    
    var currentTurn : Turn = Turn.Player
    
    init(player : Entity, badGuys : [Entity]) {
        self.player = player
        self.badGuys = badGuys
        
        for (index, guy) in self.badGuys.enumerate() {
            entityIndexes[guy] = index
        }
        
        let strBuilder = SkillBuilder()
        let intBuilder = SkillBuilder()
        let wilBuilder = SkillBuilder()
        
        strSkill = try! strBuilder
            .set("Strength Skill")
            .set(player.characterComponent!)
            .set(CharacterDescriptionVector.normStr)
            .set(skillTargetNone)
            .build()
        intSkill = try! intBuilder
            .set("Intelligence Skill")
            .set(player.characterComponent!)
            .set(CharacterDescriptionVector.normInt)
            .set(skillTargetRow)
            .build()
        wilSkill = try! wilBuilder
            .set("Will Skill")
            .set(player.characterComponent!)
            .set(CharacterDescriptionVector.normWil)
            .set(skillTargetNextInColumn)
            .build()
        
        strSkill.updateTargetFilter(self)
        intSkill.updateTargetFilter(self)
        wilSkill.updateTargetFilter(self)
    }
}
