//
//  BattleGraphic.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 9/6/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import SpriteKit

class BattleGraphic: TouchSprite {

    weak var entity: Entity!
    
    func createPopUp(text : String, color : SKColor) -> SKLabelNode {
        let popup = SKLabelNode(text: text)
        popup.fontColor = color
        popup.fontName = "Helvetica"
        popup.fontSize = 16
        popup.setScale(1 / self.xScale)
        popup.position = CGPoint(x: (self.frame.size.width * 0.375) / self.xScale, y: (self.frame.size.height * 0.375) / yScale)
        
        let floatAction = SKAction.sequence( [
            SKAction.moveByX(0, y: 25 / self.xScale, duration: 0.2),
            SKAction.removeFromParent()
            ])
        
        popup.runAction(floatAction)
        
        return popup
    }
    
    func showDamagePopup(damage : Int) {
        addChild(createPopUp("\(damage)", color: SKColor.orangeColor()))
        
        guard let character = entity.characterComponent else { return }
        print((character.isPlayer ? "Player" : "Target") + " HP : \(character.health.currentValue)")
    }
    
    func showHealingPopup(amount : Int) {
        addChild(createPopUp("\(amount)", color: SKColor.greenColor()))
        
        guard let character = entity.characterComponent else { return }
        print((character.isPlayer ? "Player" : "Target") + " HP : \(character.health.currentValue)")
    }
    
    func showBlockPopup() {
        addChild(createPopUp("BLOCK", color: SKColor.whiteColor()))
        
        guard let character = entity.characterComponent else { return }
        print((character.isPlayer ? "Player" : "Target") + " blocks!")
    }
    
    func showParryPopup() {
        addChild(createPopUp("PARRY", color: SKColor.whiteColor()))
        
        guard let character = entity.characterComponent else { return }
        print((character.isPlayer ? "Player" : "Target") + " parries!")
    }
    
    func showDodgePopup() {
        addChild(createPopUp("DODGE", color: SKColor.whiteColor()))
        
        guard let character = entity.characterComponent else { return }
        print((character.isPlayer ? "Player" : "Target") + " dodges!")
    }
}
