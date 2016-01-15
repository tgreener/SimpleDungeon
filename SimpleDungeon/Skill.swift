//
//  Skill.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 8/20/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import GameplayKit


protocol SkillUIInfo {
    var name : String { get }
}

class Skill : SkillUIInfo {
    let targetFilterGenerator : SkillTargetFilterGenerator
    var targetFilter : ((Entity) -> Bool)!
    
    let characterChangeVector : CharacterDescriptionVector
    let name : String
    
    var targets : [Entity] = []
    var primaryTarget : Entity!
    weak var character : GameCharacter!
    
    init(name                 : String,
        character             : GameCharacter,
        characterChangeVector : CharacterDescriptionVector,
        targetFilterCreator   : SkillTargetFilterGenerator
        )
    {
        self.targetFilter = nil
        self.targetFilterGenerator = targetFilterCreator
        self.character = character
        self.characterChangeVector = characterChangeVector.normalize()
        self.name = name
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
        
        character.calculateChangeFromVector(characterChangeVector)
        character.gameClockAdvanced(0.5)
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

