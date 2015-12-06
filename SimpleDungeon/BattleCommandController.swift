//
//  BattleCommandController.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 11/22/15.
//  Copyright © 2015 Todd Greener. All rights reserved.
//

import SpriteKit

protocol BattleCommand {
    func runCommand() -> Void
}

struct BattleCommandController {
    
    var commands : [BattleCommand] = Array<BattleCommand>()
    
    mutating func addCommand(command : BattleCommand) { commands.append(command) }
    
    mutating func commit() {
        for command in commands { command.runCommand() }
        clear()
    }
    
    mutating func clear() { commands.removeAll() }
    
    func runSingleCommand(command : BattleCommand) { command.runCommand() }
    
    mutating func addAndCommit(command : BattleCommand) {
        addCommand(command)
        commit()
    }
}
