//
//  Entity.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 8/6/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import SpriteKit

class Entity {
    let graphicComponent : SKSpriteNode?
    let characterComponent : GameCharacter?
    var positionComponent : IPoint?
    
    init(graphic : SKSpriteNode?, position : IPoint?, character : GameCharacter?) {
        graphicComponent = graphic
        positionComponent = position
        characterComponent = character
    }
}