//
//  Battle.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 8/12/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import Foundation

protocol BattleListener {
    func onEntityDestroyed(entity : Entity) -> Void
    func onBattleEnded() -> Void
}

// Super janky proto-demo/just-make-it work code
enum Ability {
    case Str, Int, Wil, None
}
// End jankiness //

class BattleModel {
    let notifier : Notifier<BattleListener> = Notifier<BattleListener>()
    var badGuys : [Entity?]
    let player  : Entity
    
    var currentAbility = Ability.None
    var primaryTarget : Entity?
    var secondaryTargets : [Entity?] = []
    var entityIndexes : [Entity : Int] = [Entity : Int]()
    
    init(player : Entity, badGuys : [Entity?]) {
        self.player = player
        self.badGuys = badGuys
        
        for (index, g) in enumerate(self.badGuys) {
            if let guy = g { entityIndexes[guy] = index }
        }
    }
    
    func setAbility(a : Ability) {
        currentAbility = a
    }
    
    func setTarget(guy : Entity) {
        secondaryTargets.removeAll(keepCapacity: true)
        primaryTarget = guy
        calcSecondaryTargets()
    }
    
    func calcSecondaryTargets() {
        func wilFilter(guy : Entity?) -> Bool {
            if let g = guy {
                let primaryIndex = entityIndexes[self.primaryTarget!]
                let currentIndex = entityIndexes[g]
                let difference = abs(primaryIndex! - currentIndex!)
                let modDifference = abs((primaryIndex! % 3) - (currentIndex! % 3))
                
                return difference == 1 && modDifference == 1
            }
            return false
        }
        
        func intFilter(guy : Entity?) -> Bool {
            if let g = guy {
                let primaryIndex = entityIndexes[self.primaryTarget!]
                let currentIndex = entityIndexes[g]
                let modDifference = abs((primaryIndex! % 3) - (currentIndex! % 3))
                
                return modDifference == 0
            }
            
            return false
        }
        
        var filter : (Entity?) -> Bool = { (guy : Entity?) -> Bool in return false }
        
        if currentAbility == Ability.Int { filter = intFilter }
        else if currentAbility == Ability.Wil { filter = wilFilter }
        
        secondaryTargets = badGuys.filter(filter)
    }
    
    func performAction() {
        if let target = primaryTarget {
            notifier.notify({ listener in listener.onEntityDestroyed(target) })
            badGuys = badGuys.filter() { $0 !== self.primaryTarget }
            for guy in secondaryTargets {
                notifier.notify({ listener in listener.onEntityDestroyed(guy!) })
                badGuys = badGuys.filter() { $0 !== guy }
            }
        }
        
        if badGuys.count == 0 { notifier.notify({ listener in listener.onBattleEnded() }) }
    }
    
    func actWhenReady() {
        let hasTarget = primaryTarget != nil
        let hasAbility = currentAbility != Ability.None
        
        if hasTarget && hasAbility { performAction() }
    }
}
