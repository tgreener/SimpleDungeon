//
//  PlayerActionCommand.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 11/21/15.
//  Copyright © 2015 Todd Greener. All rights reserved.
//

import SpriteKit

struct PlayerActionCommand {
    unowned let battle : BattleModel
    
    weak var primaryTarget : Entity? = nil
    var selectedAbility : Ability? = nil
    
    init(battle : BattleModel) {
        self.battle = battle
    }
    
    func runCommand() {
        guard let target = self.primaryTarget, let ability = self.selectedAbility else { return }
        
        battle.setAbility(ability)
        battle.setTarget(target)
        
        battle.actWhenReady()
    }
}

