//
//  BattleScene.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 8/7/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import SpriteKit

let BATTLE_LISTENER_KEY = "BATTLE_LISTENER_KEY"

class BattleScene : GameplayScene, BattleListener {
    
    var badGuyPositions : [CGPoint] = []
    var battle : BattleModel!
    let targetRectangle : SKShapeNode = SKShapeNode(path: CGPathCreateWithRect(CGRectMake(0, 0, 10, 10), nil), centered: true)
    let abilityRectangle : SKShapeNode = SKShapeNode(path: CGPathCreateWithRect(CGRectMake(0, 0, 100, 40), nil), centered: true)
    
    var touchEnabled : Bool = true
    
    var playerActionCommand : PlayerActionCommand! = nil
    
    override func createSceneContents() {
        super.createSceneContents()
        
        targetRectangle.strokeColor = SKColor.whiteColor()
        
        badGuyPositions = [
            CGPointMake(viewSize.width * 0.30, viewSize.height * 0.8),
            CGPointMake(viewSize.width * 0.30, viewSize.height * 0.5),
            CGPointMake(viewSize.width * 0.30, viewSize.height * 0.2),
            CGPointMake(viewSize.width * 0.15, viewSize.height * 0.75),
            CGPointMake(viewSize.width * 0.1, viewSize.height * 0.5),
            CGPointMake(viewSize.width * 0.15, viewSize.height * 0.25)
        ]
    }
    
    func setupAbilityButtons() {
        func createBattleButton(color : SKColor) -> TouchSprite {
            let battleButton = TouchSprite(color: color, size: CGSize(width: 100, height: 40))
            battleButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            battleButton.position = CGPoint(x: viewSize.width * 0.75, y: viewSize.height * 0.5)
            battleButton.userInteractionEnabled = true
            
            return battleButton
        }
        
        func setBattleSpriteScale(sprite : SKSpriteNode) {
            sprite.setScale(1.0)
            sprite.setScale((viewSize.height / sprite.frame.height) * 0.16)
        }
        
        let strengthBattleButton = createBattleButton(SKColor.redColor())
        strengthBattleButton.position = CGPointMake(strengthBattleButton.position.x, strengthBattleButton.position.y + 50)
        let intelligenceBattleButton = createBattleButton(SKColor.blueColor())
        let willBattleButton = createBattleButton(SKColor.greenColor())
        willBattleButton.position = CGPointMake(willBattleButton.position.x, willBattleButton.position.y - 50)
        
        player.graphicComponent!.battleGraphic!.position = CGPointMake(viewSize.width * 0.5, viewSize.height * 0.5)
        setBattleSpriteScale(player.graphicComponent!.battleGraphic!)
        
        class AbilityButtonListener : TouchSpriteListener {
            let ability : Ability
            let scene : BattleScene
            
            init(ability : Ability, scene : BattleScene) {
                self.ability = ability
                self.scene = scene
            }
            
            func onSpriteTouched(sprite: TouchSprite) {
                if scene.touchEnabled {
                    scene.abilityChosen(sprite, ability: ability)
                }
            }
        }
        
        strengthBattleButton.addListener(AbilityButtonListener(ability : Ability.Str, scene : self))
        intelligenceBattleButton.addListener(AbilityButtonListener(ability : Ability.Int, scene : self))
        willBattleButton.addListener(AbilityButtonListener(ability : Ability.Wil, scene : self))
        
        addChild(strengthBattleButton)
        addChild(intelligenceBattleButton)
        addChild(willBattleButton)
        addChild(player.graphicComponent!.battleGraphic!)
    }
    
    func setupEnemyInteractions() {
        for (index, guy) in battle.badGuys.enumerate() {
            if !(index < 6) { break }
            
            if let battleSprite = guy?.graphicComponent?.battleGraphic {
                
                class BadGuySpriteListener : TouchSpriteListener {
                    let guy : Entity
                    let scene : BattleScene
                    init(guy : Entity, scene : BattleScene) {
                        self.guy = guy
                        self.scene = scene
                    }
                    
                    func onSpriteTouched(sprite: TouchSprite) {
                        if scene.playerActionCommand.selectedAbility != nil && scene.touchEnabled {
                            scene.primaryTargetChosen(sprite, target: guy)
                        }
                    }
                }
                
                battleSprite.position = badGuyPositions[index]
                battleSprite.setScale((viewSize.height / battleSprite.frame.height) * 0.16)
                battleSprite.addListener(BadGuySpriteListener(guy: guy!, scene : self))
                addChild(battleSprite)
            }
        }
    }
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        setupAbilityButtons()
        setupEnemyInteractions()
        
        battle.notifier.addListenerWithName(self, name: BATTLE_LISTENER_KEY)
        player.graphicComponent?.battleGraphic?.addCallback { entity in
            self.sceneController?.gotoCharacterMenuScene()
        }
        
        playerActionCommand = PlayerActionCommand(battle: battle)
    }
    
    override func willMoveFromView(view: SKView) {
        for guy in battle.badGuys {
            if let sprite = guy?.graphicComponent?.battleGraphic {
                sprite.removeFromParent()
            }
        }
        
        self.removeAllChildren()
        battle.notifier.removeListener(named: BATTLE_LISTENER_KEY)
    }
    
    func primaryTargetChosen(sprite : SKSpriteNode, target: Entity) {
        playerActionCommand.primaryTarget = target
        
        targetRectangle.position = sprite.position
        targetRectangle.setScale(sprite.xScale)
        if targetRectangle.parent == nil { addChild(targetRectangle) }
        
        playerActionCommand.runCommand()
    }
    
    func abilityChosen(sprite : SKSpriteNode, ability: Ability) {
        playerActionCommand.selectedAbility = ability
        
        abilityRectangle.position = sprite.position
        abilityRectangle.setScale(sprite.xScale)
        if abilityRectangle.parent == nil { addChild(abilityRectangle) }
    }
    
    func onEntityDestroyed(entity: Entity) {
        entity.graphicComponent?.battleGraphic?.removeFromParent()
    }
    
    func onBattleEnded() {
        sceneController?.gotoExploreScene()
    }
    
    func onActionPerformed() {
        touchEnabled = false
        runAction(SKAction.sequence([
            SKAction.waitForDuration(0.2),
            SKAction.runBlock({
                self.targetRectangle.removeFromParent()
            })
        ]))
    }
    
    func onTurnChanged(turn: Turn) {
        switch turn {
        case Turn.Player:
            touchEnabled = true
            playerActionCommand = PlayerActionCommand(battle: battle)
        case Turn.Enemy:
            touchEnabled = false
            
            let badGuyActionFunctions = battle.generateBadGuyActions()
            
            func runBadGuyActions(actions : [()->Void]) {
                runAction(SKAction.sequence([
                    SKAction.waitForDuration(0.4),
                    SKAction.runBlock {
                        if actions.count > 0 {
                            actions[0]()
                            runBadGuyActions(Array(actions[1..<actions.count]))
                        }
                        else {
                            self.touchEnabled = true
                        }
                    }
                    ]))
            }
            
            runBadGuyActions(badGuyActionFunctions)
        }
    }
}
