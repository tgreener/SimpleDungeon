//
//  BattleGraphic.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 9/6/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import SpriteKit

protocol BattleGraphicDelegate : class {
    func battleAnimationComplete(battleGraphice : BattleGraphic, entity: Entity) -> Void
    func battleAnimationBeginning(battleGraphice : BattleGraphic, entity: Entity) -> Void
}

class BattleGraphic: TouchSprite {

    weak var entity: Entity!
    weak var delegate: BattleGraphicDelegate?
    let targetRectangle : SKShapeNode = SKShapeNode(path: CGPathCreateWithRect(CGRectMake(0, 0, 10, 10), nil), centered: true)
    
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
    
    func setAsTarget() {
        if targetRectangle.parent == nil {
            targetRectangle.strokeColor = SKColor.whiteColor()
            targetRectangle.position = CGPoint.zero
            addChild(targetRectangle)
        }
        
        targetRectangle.hidden = false
    }
    
    func doBattleAnimation() {
        let wiggleAction = SKAction.sequence([
            SKAction.moveBy(CGVector(dx: 5, dy: 0), duration: 0.1),
            SKAction.moveBy(CGVector(dx: -10, dy: 0), duration: 0.2),
            SKAction.moveBy(CGVector(dx: 5, dy: 0), duration: 0.1)
            ])
        
        delegate?.battleAnimationBeginning(self, entity: self.entity)
        runAction(SKAction.sequence([
            wiggleAction,
            SKAction.runBlock({ [weak delegate] in
                delegate?.battleAnimationComplete(self, entity: self.entity)
            })
            ]))
    }
    
    func didDie() {
        guard let _ = self.parent else { return }
        removeFromParent()
    }
    
    func didReceiveDamage(value : UInt) {
        showDamagePopup(Int(value))
    }
    
    func didReceiveHealing(value : UInt) {
        showHealingPopup(Int(value))
    }
}
