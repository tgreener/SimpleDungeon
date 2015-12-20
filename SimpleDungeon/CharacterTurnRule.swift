//
//  CharacterTurnRule.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 12/19/15.
//  Copyright © 2015 Todd Greener. All rights reserved.
//

import GameplayKit

class CharacterTurnRule : GKRule {
    
    let turnValue : NSNumber
    let entity : Entity
    let actionFunction : (system : GKRuleSystem, entity : Entity) -> Void
    
    init(turnValue : UInt, entity : Entity, actionFunction : (system : GKRuleSystem, entity : Entity) -> Void) {
        self.turnValue = NSNumber(unsignedInteger: turnValue)
        self.entity = entity
        self.actionFunction = actionFunction
    }
    
    override func evaluatePredicateWithSystem(system: GKRuleSystem) -> Bool {
        return system.gradeForFact(turnValue) == 1.0
    }
    
    override func performActionWithSystem(system: GKRuleSystem) {
        self.actionFunction(system: system, entity: entity)
    }
}
