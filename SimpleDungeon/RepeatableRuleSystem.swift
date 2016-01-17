//
//  RepeatableRuleSystem.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 1/17/16.
//  Copyright © 2016 Todd Greener. All rights reserved.
//

import GameKit

class RepeatableRuleSystem : GKRuleSystem {
    override func evaluate() {
        super.evaluate()
        self.reset()
    }
}
