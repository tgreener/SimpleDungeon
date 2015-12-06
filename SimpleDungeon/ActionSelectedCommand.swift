//
//  ActionSelectedCommand.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 12/5/15.
//  Copyright © 2015 Todd Greener. All rights reserved.
//

import Foundation

struct ActionSelectedCommand : BattleCommand {
    unowned let model : BattleModel
    unowned let skill : Skill
    
    init(model : BattleModel, skill : Skill) {
        self.model = model
        self.skill = skill
    }
    
    func runCommand() -> Void {
        self.model.currentSkill = self.skill
    }
}
