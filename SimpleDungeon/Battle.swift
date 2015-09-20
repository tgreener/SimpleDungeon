//
//  Battle.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 8/12/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import Foundation

protocol BattleListener {
    func onEntityDestroyed(entity : Entity) -> Void
    func onBattleEnded() -> Void
    
    func onActionPerformed() -> Void
    func onTurnChanged(turn : Turn) -> Void
}

// Super janky proto-demo/just-make-it work code
enum Ability {
    case Str, Int, Wil, None
}
// End jankiness //

enum Turn {
    case Player, Enemy
}

class BattleModel {
    let notifier : Notifier<BattleListener> = Notifier<BattleListener>()
    
    var badGuys : [Entity?]
    var entityIndexes : [Entity : Int] = [Entity : Int]()
    
    let player  : Entity
    var currentSkill : Skill?
    
    let strSkill : Skill
    let intSkill : Skill
    let wilSkill : Skill
    
    var currentTurn : Turn = Turn.Player

    struct SkillListener : SkillApplicationListener {
        let model : BattleModel
        
        init(model : BattleModel) {
            self.model = model
        }
        
        func receivesDamage(target target: Entity, amount: Int) {
            target.characterComponent?.health.decrease(amount)
            target.graphicComponent?.battleGraphic?.showDamagePopup(amount)
            
            print((target === model.player ? "Player" : "Target") + " HP : \(target.characterComponent!.health.currentValue)")
            if target.characterComponent?.health.currentValue == 0 {
                model.notifier.notify() { listener in listener.onEntityDestroyed(target) }
                model.badGuys = model.badGuys.filter() { $0 !== target }
            }
        }
        
        func receivesHealing(target target: Entity, amount: Int) {
            
        }
        
        func receivesBuff(target target: Entity, buff: AnyObject?) {
            
        }
        
        func blocksAttack(target target: Entity, baseDamage: Int) {
            target.graphicComponent?.battleGraphic?.showBlockPopup()
            print((target === model.player ? "Player" : "Target") + " blocks!")
        }
        
        func dodgesAttack(target target: Entity, baseDamage: Int) {
            
        }
        
        func parriesAttack(target target: Entity, baseDamage: Int) {
            
        }
    }
    
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
    
    func setAbility(a : Ability) {
        switch a {
        case Ability.Str : currentSkill = strSkill
        case Ability.Int : currentSkill = intSkill
        case Ability.Wil : currentSkill = wilSkill
        default : currentSkill = nil
        }
    }
    
    func setTarget(guy : Entity) {
        if let s = currentSkill {
            s.setTarget(badGuys, primary: guy)
        }
    }
    
    func performAction() {
        if let s = currentSkill {
            s.perform(SkillListener(model: self))
            currentTurn = Turn.Enemy
            
            notifier.notify() { listener in listener.onActionPerformed() }
            notifier.notify() { listener in listener.onTurnChanged(self.currentTurn) }
            
            if badGuys.count == 0 { notifier.notify({ listener in listener.onBattleEnded() }) }
        }
    }
    
    func actWhenReady() {
        let hasTarget = currentSkill?.primaryTarget != nil
        let hasAbility = currentSkill != nil
        
        if hasTarget && hasAbility { performAction() }
    }
    
    func performBadGuyActions() {
        for guy in badGuys {
            let badSkill = Skill(character: guy!.characterComponent!, targetFilterCreator: skillTargetNone)
            badSkill.setTarget([], primary: player)
            badSkill.perform(SkillListener(model: self))
        }
        
        currentTurn = Turn.Player
        notifier.notify() { listener in listener.onTurnChanged(self.currentTurn) }
        
        if player.characterComponent?.health.currentValue <= 0 { notifier.notify { listener in listener.onBattleEnded() } }
    }
}
