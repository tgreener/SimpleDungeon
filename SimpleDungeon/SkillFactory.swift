//
//  SkillFactory.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 8/22/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import Foundation

typealias SkillCreationFunction = () -> Skill

let skillTargetRow = { (skill : Skill, battle : BattleModel) -> (Entity) -> Bool  in
    return { [unowned battle, unowned skill] g in
        if g.characterComponent!.isDead { return false }
        
        let primaryIndex = battle.entityIndexes[skill.primaryTarget]
        let currentIndex = battle.entityIndexes[g]
        let modDifference = abs((primaryIndex! % 3) - (currentIndex! % 3))
        
        return modDifference == 0 && (primaryIndex != currentIndex)
    }
}

let skillTargetNextInColumn = { (skill : Skill, battle : BattleModel) -> (Entity) -> Bool in
    return { [unowned battle, unowned skill] g in
        if g.characterComponent!.isDead { return false }
        
        let primaryIndex = battle.entityIndexes[skill.primaryTarget]
        let currentIndex = battle.entityIndexes[g]
        let difference = abs(primaryIndex! - currentIndex!)
        let modDifference = abs((primaryIndex! % 3) - (currentIndex! % 3))
        
        return difference == 1 && modDifference == 1
    }
}

let skillTargetNone = { (skill : Skill, battle : BattleModel) -> (Entity) -> Bool in
    return { guy in return false }
}

class SkillBuilder {
    
    enum Error : ErrorType {
        case BuildErrorUnsetValues
    }
    
    weak var character : GameCharacter! = nil
    var targetFilterGenerator : ((Skill, BattleModel) -> ((Entity) -> Bool))!
    var characterChangeVector : CharacterDescriptionVector!
    
    func set(character : GameCharacter) -> SkillBuilder {
        self.character = character
        return self
    }
    
    func set(targetFilterGenerator : (Skill, BattleModel) -> ((Entity) -> Bool)) -> SkillBuilder {
        self.targetFilterGenerator = targetFilterGenerator
        return self
    }
    
    func set(characterChangeVector : CharacterDescriptionVector) -> SkillBuilder {
        self.characterChangeVector = characterChangeVector
        return self
    }
    
    func build() throws -> Skill {
        guard let c = self.character, t = self.targetFilterGenerator, v = self.characterChangeVector else {
            throw Error.BuildErrorUnsetValues
        }
        
        return Skill(character: c, characterChangeVector: v, targetFilterCreator: t)
    }
}
