//
//  TargetSelectionRule.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 2/4/16.
//  Copyright © 2016 Todd Greener. All rights reserved.
//

import GameplayKit

class TargetSelectionRule : GKRule {
    
    let delta : IPoint
    var target: Entity? = nil
    
    init(dX : Int, dY : Int) {
        self.delta = IPoint(x: dX, y: dY)
    }
    
    func onFalsePredicate() -> Bool {
        target = nil
        return false
    }
    
    override func evaluatePredicateWithSystem(system: GKRuleSystem) -> Bool {
        guard let battle = system.state[SkillRuleStateKey.Battle.rawValue] as? BattleModel else { return onFalsePredicate() }
        guard let primaryTargetPosition = battle.primaryTargetPosition else { return onFalsePredicate() }
        let grid = battle.battleGrid
        
        do {
            if let t = try grid.getEntityAt(UInt(primaryTargetPosition.x + delta.x), row: UInt(primaryTargetPosition.y + delta.y)) {
                target = t
                return true
            }
        } catch {}
        return onFalsePredicate()
    }
    
    override func performActionWithSystem(system: GKRuleSystem) {
        guard var targetList = system.state[SkillRuleStateKey.TargetList.rawValue] as? [Entity] else { return }
        guard let t = target else { return }
        
        targetList.append(t)
        system.state[SkillRuleStateKey.TargetList.rawValue] = targetList
    }
}
