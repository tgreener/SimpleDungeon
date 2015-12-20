//
//  Skill.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 8/20/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import GameplayKit

protocol SkillApplicationListener {
    func receivesDamage(target target : Entity, amount : Int) -> Void
    func receivesHealing(target target : Entity, amount : Int) -> Void
    
    func blocksAttack(target target : Entity, baseDamage : Int) -> Void
    func parriesAttack(target target : Entity, baseDamage : Int) -> Void
    func dodgesAttack(target target : Entity, baseDamage : Int) -> Void
    
    func receivesBuff(target target : Entity, buff : AnyObject?) -> Void
}

class Skill {
    let targetFilterGenerator : (skill : Skill, battle : BattleModel) -> ((Entity) -> Bool)
    var targetFilter : ((Entity) -> Bool)!
    
    var targets : [Entity] = []
    var primaryTarget : Entity!
    weak var character : GameCharacter!
    
    init(character : GameCharacter, targetFilterCreator : (Skill, BattleModel) -> ((Entity) -> Bool)) {
        self.targetFilter = nil
        self.targetFilterGenerator = targetFilterCreator
        self.character = character
    }
    
    func setTarget(entities : [Entity], primary : Entity) {
        primaryTarget = primary
        if entities.count > 0 { targets = entities.filter(targetFilter) }
    }
    
    func updateTargetFilter(battle: BattleModel) {
        self.targetFilter = targetFilterGenerator(skill: self, battle: battle)
    }
    
    func perform(ref : BattleRef) {
        guard let primaryTarget = self.primaryTarget else { return }
        performActionOnTarget(primaryTarget, attacker: self.character, ref: ref)
        
        for guy in self.targets {
            guard !(guy.characterComponent!.isDead) else { continue }
            performActionOnTarget(guy, attacker: self.character, ref: ref)
        }
    }
    
    func performActionOnTarget(target: Entity, attacker: GameCharacter, ref : BattleRef) {
        guard let targetCharacter = target.characterComponent else { return }
        
        let skillApplicationRuleSystem = GKRuleSystem()
        skillApplicationRuleSystem.addRule(SkillApplicationRule(target: targetCharacter))
        skillApplicationRuleSystem.addRule(DidBlockRule(ref: ref, defender: target, attacker: attacker))
        skillApplicationRuleSystem.addRule(DidParryRule(ref: ref, defender: target, attacker: attacker))
        skillApplicationRuleSystem.addRule(DidDodgeRule(ref: ref, defender: target, attacker: attacker))
        skillApplicationRuleSystem.addRule(FailedDefenseRule(ref: ref, defender: target, attacker: attacker))
        
        skillApplicationRuleSystem.evaluate()
    }
}
