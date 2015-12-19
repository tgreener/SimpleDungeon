//
//  TargetSelectedRule.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 12/5/15.
//  Copyright © 2015 Todd Greener. All rights reserved.
//

import GameplayKit

class TargetSelectedRule: GKRule {
    
    unowned let model : BattleModel
    unowned let target: Entity
    
    init(battle : BattleModel, target : Entity) {
        self.model  = battle
        self.target = target
    }
    
    override func evaluatePredicateWithSystem(system: GKRuleSystem) -> Bool {
        return self.model.currentSkill != nil
    }
    
    override func performActionWithSystem(system: GKRuleSystem) {
        guard let currentSkill = self.model.currentSkill else { return }
        self.model.primaryTarget = target
        currentSkill.setTarget(self.model.badGuys, primary: target)
        currentSkill.perform(SkillListener(model: self.model))
        
        self.model.notifier.notify() { listener in listener.onActionPerformed() }
        
        system.assertFact(String(TurnFacts.PlayerTurnComplete))
    }
    
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
            target.characterComponent?.health.increase(amount)
            target.graphicComponent?.battleGraphic?.showHealingPopup(amount)
        }
        
        func receivesBuff(target target: Entity, buff: AnyObject?) {
            
        }
        
        func blocksAttack(target target: Entity, baseDamage: Int) {
            target.graphicComponent?.battleGraphic?.showBlockPopup()
            print((target === model.player ? "Player" : "Target") + " blocks!")
        }
        
        func dodgesAttack(target target: Entity, baseDamage: Int) {
            target.graphicComponent?.battleGraphic?.showDodgePopup()
            print((target === model.player ? "Player" : "Target") + " dodges!")
        }
        
        func parriesAttack(target target: Entity, baseDamage: Int) {
            target.graphicComponent?.battleGraphic?.showParryPopup()
            print((target === model.player ? "Player" : "Target") + " parries!")
        }
    }

}
