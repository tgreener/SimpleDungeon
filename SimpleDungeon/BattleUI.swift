//
//  BattleUI.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 11/24/15.
//  Copyright © 2015 Todd Greener. All rights reserved.
//

import SpriteKit

protocol BattleUIDelegate : class {
    func onAbilityButtonTouched(ability : Ability) -> Void
    func onTargetTouched(target: Entity) -> Void
    
    func onActionAnimationFinished() -> Void
}

class BattleUI : SKNode, BattleGraphicDelegate {
    var badGuyPositions : [CGPoint] = []
    let targetRectangle : SKShapeNode = SKShapeNode(path: CGPathCreateWithRect(CGRectMake(0, 0, 10, 10), nil), centered: true)
    let abilityRectangle : SKShapeNode = SKShapeNode(path: CGPathCreateWithRect(CGRectMake(0, 0, 100, 40), nil), centered: true)
    
    var touchEnabled : Bool = true
    
    let viewSize : CGSize
    let playerGraphic : BattleGraphic
    let badGuyGraphics: [BattleGraphic]
    unowned let delegate : BattleUIDelegate
    
    init(viewSize : CGSize,
        playerGraphic : BattleGraphic,
        badGuyGraphics : [BattleGraphic],
        delegate : BattleUIDelegate,
        playerSkills : [SkillUIInfo]
        )
    {
        self.viewSize = viewSize
        self.playerGraphic = playerGraphic
        self.badGuyGraphics = badGuyGraphics
        targetRectangle.strokeColor = SKColor.whiteColor()
        
        badGuyPositions = [
            CGPointMake(viewSize.width * 0.30, viewSize.height * 0.8),
            CGPointMake(viewSize.width * 0.30, viewSize.height * 0.5),
            CGPointMake(viewSize.width * 0.30, viewSize.height * 0.2),
            CGPointMake(viewSize.width * 0.15, viewSize.height * 0.75),
            CGPointMake(viewSize.width * 0.1, viewSize.height * 0.5),
            CGPointMake(viewSize.width * 0.15, viewSize.height * 0.25)
        ]
        
        self.delegate = delegate

        super.init()
        
        self.playerGraphic.delegate = self
        for guy in self.badGuyGraphics {
            guy.delegate = self
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupAbilityButtons() {
        func createBattleButton(color : SKColor, ability : Ability) -> TouchSprite {
            let battleButton = TouchSprite(color: color, size: CGSize(width: 100, height: 40))
            battleButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            battleButton.position = CGPoint(x: viewSize.width * 0.75, y: viewSize.height * 0.5)
            battleButton.userInteractionEnabled = true
            
            battleButton.addTouchHandler { sprite in
                guard self.touchEnabled else { return }
                self.abilityChosen(sprite, ability: ability)
            }
            
            return battleButton
        }
        
        func setBattleSpriteScale(sprite : SKSpriteNode) {
            sprite.setScale(1.0)
            sprite.setScale((viewSize.height / sprite.frame.height) * 0.16)
        }
        
        let strengthBattleButton = createBattleButton(SKColor.redColor(), ability: Ability.Str)
        let intelligenceBattleButton = createBattleButton(SKColor.blueColor(), ability: Ability.Int)
        let willBattleButton = createBattleButton(SKColor.greenColor(), ability: Ability.Wil)
        
        strengthBattleButton.position = CGPointMake(strengthBattleButton.position.x, strengthBattleButton.position.y + 50)
        willBattleButton.position = CGPointMake(willBattleButton.position.x, willBattleButton.position.y - 50)
        
        playerGraphic.position = CGPointMake(viewSize.width * 0.5, viewSize.height * 0.5)
        setBattleSpriteScale(playerGraphic)
        
        addChild(strengthBattleButton)
        addChild(intelligenceBattleButton)
        addChild(willBattleButton)
        addChild(playerGraphic)
    }
    
    func setupEnemyInteractions() {
        for (index, guy) in badGuyGraphics.enumerate() {
            if !(index < 6) { break }
            
            guy.position = badGuyPositions[index]
            guy.setScale((viewSize.height / guy.frame.height) * 0.16)
            
            guy.addTouchHandler { sprite in
                guard self.touchEnabled else { return }
                self.targetTouched(sprite, target: guy.entity)
            }
            
            addChild(guy)
        }
    }
    
    func didMoveToView(view: SKView) {
        setupAbilityButtons()
        setupEnemyInteractions()
    }
    
    func willMoveFromView(view: SKView) {
        for guy in badGuyGraphics {
            if let _ = guy.parent { guy.removeFromParent() }
        }
        playerGraphic.removeFromParent()
        
        self.removeAllChildren()
        self.removeFromParent()
    }
    
    // MARK: UI Behaviors
    
    func targetTouched(sprite : SKSpriteNode, target: Entity) {
        delegate.onTargetTouched(target)
    }
    
    func primaryTargetChosen(sprite : SKSpriteNode, target: Entity) {
        targetRectangle.position = sprite.position
        targetRectangle.setScale(sprite.xScale)
        if targetRectangle.parent == nil { addChild(targetRectangle) }
    }
    
    func abilityChosen(sprite : SKSpriteNode, ability: Ability) {
        delegate.onAbilityButtonTouched(ability)
        
        abilityRectangle.position = sprite.position
        abilityRectangle.setScale(sprite.xScale)
        if abilityRectangle.parent == nil { addChild(abilityRectangle) }
    }
    
    func battleAnimationBeginning(battleGraphice: BattleGraphic, entity: Entity) {
        self.touchEnabled = false
    }
    
    func battleAnimationComplete(battleGraphice: BattleGraphic, entity: Entity) {
        self.targetRectangle.removeFromParent()
        self.delegate.onActionAnimationFinished()
    }
    
    func beginPlayerTurn() {
        self.touchEnabled = true
    }
}
