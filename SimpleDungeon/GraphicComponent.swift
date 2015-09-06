//
//  GraphicComponent.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 8/9/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import SpriteKit

class GraphicComponent {
    let exploreGraphic : TouchSprite?
    let battleGraphic : BattleGraphic?
    
    init(explore : TouchSprite?, battle : BattleGraphic?) {
        exploreGraphic = explore
        battleGraphic = battle
    }
}
