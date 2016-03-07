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
        guard let state = (system.state[SkillRuleStateKey.State.rawValue] as? SkillRuleState) else { return onFalsePredicate() }
        guard let grid = state.battle?.battleGrid else { return onFalsePredicate() }
        guard let primaryTargetPosition = state.primaryTarget?.position else { return onFalsePredicate() }
        
        do {
            let x : Int = primaryTargetPosition.ix + delta.x
            let y : Int = primaryTargetPosition.iy + delta.y
            
            guard x >= 0 && y >= 0 else { return onFalsePredicate() }
            
            if let t = try grid.getEntityAt(UInt(x), row: UInt(y)) {
                target = t
                return true
            }
        }
        catch BaseBattleGrid.BattleGridError.OutOfBoundsError {}
        catch {}
        return onFalsePredicate()
    }
    
    override func performActionWithSystem(system: GKRuleSystem) {
        guard let state = (system.state[SkillRuleStateKey.State.rawValue] as? SkillRuleState) else { return }
        guard let t = target else { return }
        
        state.targetEntities.append(t)
    }
}
