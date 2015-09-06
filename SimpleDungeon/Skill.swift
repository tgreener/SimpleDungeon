//
//  Skill.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 8/20/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import Foundation

protocol SkillApplicationListener {
    func receivesDamage(#target : Entity, amount : Int) -> Void
    func receivesHealing(#target : Entity, amount : Int) -> Void
    
    func blocksAttack(#target : Entity, baseDamage : Int) -> Void
    func parriesAttack(#target : Entity, baseDamage : Int) -> Void
    func dodgesAttack(#target : Entity, baseDamage : Int) -> Void
    
    func receivesBuff(#target : Entity, buff : AnyObject?) -> Void
}

class Skill {
    let targetFilterGenerator : (skill : Skill, battle : BattleModel) -> ((Entity?) -> Bool)
    var targetFilter : ((Entity?) -> Bool)!
    
    var targets : [Entity?] = []
    var primaryTarget : Entity!
    weak var character : GameCharacter!
    
    init(character : GameCharacter, targetFilterCreator : (Skill, BattleModel) -> ((Entity?) -> Bool)) {
        self.targetFilter = nil
        self.targetFilterGenerator = targetFilterCreator
        self.character = character
    }
    
    func setTarget(entities : [Entity?], primary : Entity) {
        primaryTarget = primary
        if entities.count > 0 { targets = entities.filter(targetFilter) }
    }
    
    func updateTargetFilter(battle: BattleModel) {
        self.targetFilter = targetFilterGenerator(skill: self, battle: battle)
    }
    
    func perform(skillListener : SkillApplicationListener) -> Void {
        if let target = primaryTarget {
            apply(target : self.primaryTarget, skillListener : skillListener)
            for guy in targets {
                apply(target : guy!, skillListener : skillListener)
            }
        }
    }
    
    func apply(#target : Entity, skillListener : SkillApplicationListener) {
        let defenseRoll : Int = Int(random(0, 99))
        let baseDamage : Int = character.power
        
        if defenseRoll < target.characterComponent?.block {
            skillListener.blocksAttack(target: target, baseDamage: baseDamage)
        }
        else {
            skillListener.receivesDamage(target: target, amount: baseDamage)
        }
    }
}
