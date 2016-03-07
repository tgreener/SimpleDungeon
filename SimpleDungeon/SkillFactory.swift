//
//  SkillFactory.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 8/22/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import Foundation

typealias SkillCreationFunction = (character: GameCharacter) -> Skill

let skillTargetNone = { (skill : Skill, battle : BattleModel) -> (Entity) -> Bool in
    return { guy in return false }
}

class SkillBuilder {
    
    enum Error : ErrorType {
        case BuildErrorUnsetValues
    }
    
    weak var character : GameCharacter! = nil
    var characterChangeVector : CharacterDescriptionVector!
    var name : String!
    var targetRules : RepeatableRuleSystem!
    
    func set(name : String) -> SkillBuilder {
        self.name = name
        return self
    }
    
    func set(character : GameCharacter) -> SkillBuilder {
        self.character = character
        return self
    }
    
    func set(characterChangeVector : CharacterDescriptionVector) -> SkillBuilder {
        self.characterChangeVector = characterChangeVector
        return self
    }
    
    func set(targetRules : RepeatableRuleSystem) -> SkillBuilder {
        self.targetRules = targetRules
        return self
    }
    
    func build() throws -> Skill {
        guard let n = self.name, c = self.character, v = self.characterChangeVector, tr = self.targetRules else {
            throw Error.BuildErrorUnsetValues
        }
        
        return Skill(name: n, character: c, characterChangeVector: v, targetSelectionRules: tr)
    }
}
