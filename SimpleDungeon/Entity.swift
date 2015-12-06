//
//  Entity.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 8/6/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import SpriteKit

class Entity : Hashable {
    let graphicComponent : GraphicComponent?
    let characterComponent : GameCharacter?
    var positionComponent : IPoint?
    
    init(graphic : GraphicComponent?, position : IPoint?, character : GameCharacter?) {
        graphicComponent = graphic
        positionComponent = position
        characterComponent = character
        
        graphicComponent?.battleGraphic?.entity = self
    }
    
    var hashValue : Int {
        get {
            return Int(ObjectIdentifier(self).uintValue)
        }
    }
}

func == (lhs : Entity, rhs : Entity) -> Bool {
    return lhs.hashValue == rhs.hashValue
}