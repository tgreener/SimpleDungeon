//
//  SceneController.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 8/7/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import SpriteKit

class SceneController {
    let exploreScene : ExploreScene
    let battleScene : BattleScene
    let characterMenuScene : CharacterMenuScene
    let titleScene : BaseScene
    let view : SKView
    
    init(view : SKView, explore : ExploreScene, battle : BattleScene, title : BaseScene, character : CharacterMenuScene) {
        exploreScene = explore
        battleScene  = battle
        titleScene = title
        characterMenuScene = character
        self.view = view
        
        exploreScene.sceneController = self
        battleScene.sceneController = self
        characterMenuScene.sceneController = self
        titleScene.sceneController = self
    }
    
    func gotoBattleScene(badGuys : [Entity?]) {
        let battle = BattleModel(player: battleScene.player, badGuys: badGuys)
        battleScene.battle = battle
        
        let transitionScene = SKScene()
        transitionScene.backgroundColor = SKColor.redColor()
        view.presentScene(transitionScene, transition: SKTransition.doorsCloseHorizontalWithDuration(0.2))
        transitionScene.runAction(SKAction.sequence([
            SKAction.waitForDuration(0.3),
            SKAction.runBlock({
                self.view.presentScene(self.battleScene, transition: SKTransition.doorsOpenHorizontalWithDuration(0.2))
            })
        ]))
    }
    
    func gotoExploreScene() {
        let transitionScene = SKScene()
        transitionScene.backgroundColor = SKColor.greenColor()
        view.presentScene(transitionScene, transition: SKTransition.doorsCloseHorizontalWithDuration(0.2))
        transitionScene.runAction(SKAction.sequence([
            SKAction.waitForDuration(0.3),
            SKAction.runBlock({
                self.view.presentScene(self.exploreScene, transition: SKTransition.doorsOpenHorizontalWithDuration(0.2))
            })
        ]))
    }
    
    func gotoCharacterMenuScene() {
        let transitionScene = SKScene()
        transitionScene.backgroundColor = SKColor.blueColor()
        view.presentScene(transitionScene, transition: SKTransition.doorsCloseHorizontalWithDuration(0.2))
        transitionScene.runAction(SKAction.sequence([
            SKAction.waitForDuration(0.3),
            SKAction.runBlock({
                self.view.presentScene(self.characterMenuScene, transition: SKTransition.doorsOpenHorizontalWithDuration(0.2))
            })
        ]))
    }
    
    func gotoTitleScene() {
        self.view.presentScene(titleScene)
    }
}

