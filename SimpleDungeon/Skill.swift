//
//  Skill.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 8/20/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import GameplayKit

class Skill {
    let targetFilterGenerator : (skill : Skill, battle : BattleModel) -> ((Entity) -> Bool)
    var targetFilter : ((Entity) -> Bool)!
    
    let characterChangeVector : CharacterDescriptionVector
    
    var targets : [Entity] = []
    var primaryTarget : Entity!
    weak var character : GameCharacter!
    
    init(
        character : GameCharacter,
        characterChangeVector : CharacterDescriptionVector,
        targetFilterCreator : (Skill, BattleModel) -> ((Entity) -> Bool))
    {
        self.targetFilter = nil
        self.targetFilterGenerator = targetFilterCreator
        self.character = character
        self.characterChangeVector = characterChangeVector.normalize()
    }
    
    func setTarget(entities : [Entity], primary : Entity) {
        primaryTarget = primary
        if entities.count > 0 { targets = entities.filter(targetFilter) }
    }
    
    func updateTargetFilter(battle: BattleModel) {
        self.targetFilter = targetFilterGenerator(skill: self, battle: battle)
    }
    
    func perform() {
        guard let primaryTarget = self.primaryTarget else { return }
        performActionOnTarget(primaryTarget, attacker: self.character)
        
        for guy in self.targets {
            guard !(guy.characterComponent!.isDead) else { continue }
            performActionOnTarget(guy, attacker: self.character)
        }
    }
    
    func performActionOnTarget(target: Entity, attacker: GameCharacter) {
        guard let targetCharacter = target.characterComponent else { return }
        
        let skillApplicationRuleSystem = GKRuleSystem()
        skillApplicationRuleSystem.addRule(SkillApplicationRule(target: targetCharacter))
        skillApplicationRuleSystem.addRule(DidBlockRule(defender: target, attacker: attacker))
        skillApplicationRuleSystem.addRule(DidParryRule(defender: target, attacker: attacker))
        skillApplicationRuleSystem.addRule(DidDodgeRule(defender: target, attacker: attacker))
        skillApplicationRuleSystem.addRule(FailedDefenseRule(defender: target, attacker: attacker))
        
        skillApplicationRuleSystem.evaluate()
    }
}

