//
//  SkillFactory.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 8/22/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import Foundation

let skillTargetRow = { (skill : Skill, battle : BattleModel) -> (Entity) -> Bool  in
    return { g in
        if g.characterComponent!.isDead { return false }
        
        let primaryIndex = battle.entityIndexes[skill.primaryTarget]
        let currentIndex = battle.entityIndexes[g]
        let modDifference = abs((primaryIndex! % 3) - (currentIndex! % 3))
        
        return modDifference == 0 && (primaryIndex != currentIndex)
    }
}

let skillTargetNextInColumn = { (skill : Skill, battle : BattleModel) -> (Entity) -> Bool in
    return { g in
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

