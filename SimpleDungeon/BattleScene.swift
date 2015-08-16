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
    
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
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
            let battle : BattleModel
            let ability : Ability
            let scene : BattleScene
            
            init(battle : BattleModel, ability : Ability, scene : BattleScene) {
                self.battle = battle
                self.ability = ability
                self.scene = scene
            }
            
            func onSpriteTouched(sprite: TouchSprite) {
                battle.setAbility(ability)
                scene.abilityChosen(sprite)
                battle.actWhenReady()
            }
        }
        
        strengthBattleButton.addListener(AbilityButtonListener(battle: battle, ability : Ability.Str, scene : self))
        intelligenceBattleButton.addListener(AbilityButtonListener(battle: battle, ability : Ability.Int, scene : self))
        willBattleButton.addListener(AbilityButtonListener(battle: battle, ability : Ability.Wil, scene : self))
        
        addChild(strengthBattleButton)
        addChild(intelligenceBattleButton)
        addChild(willBattleButton)
        addChild(player.graphicComponent!.battleGraphic!)
        
        for (index, guy) in enumerate(battle.badGuys) {
            if !(index < 6) { break }
            
            if let battleSprite = guy?.graphicComponent?.battleGraphic {
                
                class BadGuySpriteListener : TouchSpriteListener {
                    let guy : Entity
                    let battle : BattleModel
                    let scene : BattleScene
                    init(guy : Entity, battle : BattleModel, scene : BattleScene) {
                        self.guy = guy
                        self.battle = battle
                        self.scene = scene
                    }
                    
                    func onSpriteTouched(sprite: TouchSprite) {
                        if battle.currentAbility != Ability.None {
                            battle.setTarget(guy)
                            scene.primaryTargetChosen(sprite)
                            battle.actWhenReady()
                        }
                    }
                }
                
                battleSprite.position = badGuyPositions[index]
                battleSprite.setScale((viewSize.height / battleSprite.frame.height) * 0.16)
                battleSprite.addListener(BadGuySpriteListener(guy: guy!, battle: battle, scene : self))
                addChild(battleSprite)
            }
        }
        
        battle.notifier.addListenerWithName(self, name: BATTLE_LISTENER_KEY)
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
    
    func primaryTargetChosen(sprite : SKSpriteNode) {
        targetRectangle.position = sprite.position
        targetRectangle.setScale(sprite.xScale)
        if targetRectangle.parent == nil { addChild(targetRectangle) }
    }
    
    func abilityChosen(sprite : SKSpriteNode) {
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
}
