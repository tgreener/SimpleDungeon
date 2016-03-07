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

enum SkillRuleStateKey : Int {
    case TargetList, State
}

class SkillRuleState {
    var primaryTarget : BattleGridPosition? = nil
    var battle : BattleModel? = nil
    var targetEntities : [Entity] = [Entity]()
}

class Skill : SkillUIInfo {
    let targetSelectionRules : RepeatableRuleSystem
    
    let characterChangeVector : CharacterDescriptionVector
    let name : String
    
    var target : BattleGridPosition? { get { return skillRuleState.primaryTarget } }
    var skillRuleState : SkillRuleState! { get {
        return self.targetSelectionRules.state[SkillRuleStateKey.State.rawValue] as! SkillRuleState
        }
    }
    weak var character : GameCharacter!
    
    init(name                 : String,
        character             : GameCharacter,
        characterChangeVector : CharacterDescriptionVector,
        targetSelectionRules  : RepeatableRuleSystem
        )
    {
        self.character = character
        self.characterChangeVector = characterChangeVector.normalize()
        self.name = name
        self.targetSelectionRules = targetSelectionRules
        self.targetSelectionRules.state[SkillRuleStateKey.State.rawValue] = SkillRuleState()
    }
    
    func setTarget(target: BattleGridPosition) {
        skillRuleState.primaryTarget = target
        skillRuleState.targetEntities.removeAll()
        targetSelectionRules.evaluate()
    }
    
    func resetTargetRules(battle : BattleModel) {
        skillRuleState.battle = battle
        skillRuleState.primaryTarget = nil
        skillRuleState.targetEntities.removeAll()
    }
    
    func perform() {
        guard let primaryTarget = skillRuleState.primaryTarget?.entity else { return }
        performActionOnTarget(primaryTarget, attacker: self.character)
        
        for target in skillRuleState.targetEntities {
            performActionOnTarget(target, attacker: self.character)
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

