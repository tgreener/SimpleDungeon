//
//  BattleUI.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 11/24/15.
//  Copyright © 2015 Todd Greener. All rights reserved.
//

import SpriteKit

protocol BattleUIDelegate : class {
    func onSkillButtonTouched(skillIndex : Int) -> Void
    func onTargetTouched(target: Entity) -> Void
    
    func onActionAnimationFinished() -> Void
}

class BattleUI : SKNode, BattleGraphicDelegate {
    let badGuyPositions : [CGPoint]
    let targetRectangle : SKShapeNode = SKShapeNode(path: CGPathCreateWithRect(CGRectMake(0, 0, 10, 10), nil), centered: true)
    var currentlySelectedSkill : TouchSprite? = nil
    
    var touchEnabled : Bool = true
    
    let viewSize : CGSize
    let playerGraphic : BattleGraphic
    let playerSkills  : [SkillUIInfo]
    let battleGrid: BattleGrid
    unowned let delegate : BattleUIDelegate
    
    init(viewSize : CGSize,
        playerGraphic : BattleGraphic,
        battleGrid : BattleGrid,
        delegate : BattleUIDelegate,
        playerSkills : [SkillUIInfo]
        )
    {
        self.viewSize = viewSize
        self.playerGraphic = playerGraphic
        self.playerSkills  = playerSkills
        self.battleGrid = battleGrid
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
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didMoveToView(view: SKView) {
        setupSkillButtons()
        setupPlayerGraphic()
        setupEnemyGraphics()
    }
    
    func willMoveFromView(view: SKView) {
        for position in battleGrid.positions {
            if let graphic = position.entity?.graphicComponent?.battleGraphic { graphic.removeFromParent() }
        }
        playerGraphic.removeFromParent()
        
        self.removeAllChildren()
        self.removeFromParent()
    }
    
    func setupSkillButtons() {
        func createSkillButton(index : Int, skill : SkillUIInfo) -> LabeledTouchSprite {
            let skillButton = LabeledTouchSprite(label: skill.name, size: CGSize(width: 100, height: 40))
            
            skillButton.position = CGPoint(x: viewSize.width * 0.75, y: viewSize.height * 0.75)
            skillButton.userInteractionEnabled = true
            skillButton.setBorder()
            
            skillButton.addTouchHandler { [unowned self] sprite in
                guard self.touchEnabled else { return }
                
                if let current = self.currentlySelectedSkill {
                    current.setBorderGlowValue(0)
                }
                
                self.currentlySelectedSkill = sprite
                sprite.setBorderGlowValue(3.5)
                self.skillChosen(index)
            }
            
            return skillButton
        }
        
        for (index, skill) in playerSkills.enumerate() {
            let skillButton = createSkillButton(index, skill: skill)
            skillButton.position = CGPoint(x: skillButton.position.x, y: skillButton.position.y - (CGFloat(index) * 50))
            addChild(skillButton)
        }
    }
    
    func setBattleSpriteScale(sprite : SKSpriteNode) {
        sprite.setScale(1.0)
        sprite.setScale((viewSize.height / sprite.frame.height) * 0.16)
    }
    
    func setupPlayerGraphic() {
        self.playerGraphic.delegate = self
        playerGraphic.position = CGPointMake(viewSize.width * 0.5, viewSize.height * 0.5)
        setBattleSpriteScale(playerGraphic)
        
        addChild(playerGraphic)
    }
    
    func getBattlePosition(gridPosition : BattleGridPosition) -> CGPoint {
        let position : UIPoint = gridPosition.position
        let index = Int((position.x * battleGrid.numRows) + position.y)
        return badGuyPositions[index]
    }
    
    func setupEnemyGraphics() {
        for position in battleGrid.positions {
            guard let guy = position.entity else { continue }
            guard let guyGraphic = guy.graphicComponent?.battleGraphic else { continue }
            
            guyGraphic.delegate = self
            guyGraphic.position = getBattlePosition(position)
            setBattleSpriteScale(guyGraphic)
            
            guyGraphic.addTouchHandler { sprite in
                guard self.touchEnabled else { return }
                self.targetTouched(sprite, position: position)
            }
            
            addChild(guyGraphic)
        }
    }
    
    // MARK: UI Behaviors
    
    func targetTouched(sprite : SKSpriteNode, target: Entity) {
        delegate.onTargetTouched(target)
    }
    
    func targetTouched(sprite : SKSpriteNode, position: BattleGridPosition) {
        guard let target = position.entity else { return }
        delegate.onTargetTouched(target)
    }
    
    func primaryTargetChosen(sprite : SKSpriteNode, target: Entity) {
        targetRectangle.position = sprite.position
        targetRectangle.setScale(sprite.xScale)
        if targetRectangle.parent == nil { addChild(targetRectangle) }
    }
    
    func skillChosen(skillIndex : Int) {
         delegate.onSkillButtonTouched(skillIndex)
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
