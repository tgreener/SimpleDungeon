//
//  SceneController.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 8/7/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import SpriteKit

class SceneController {
    let exploreScene : SKScene
    let battleScene : BattleScene
    let titleScene : SKScene
    let view : SKView
    
    init(view : SKView, explore : SKScene, battle : BattleScene, title : SKScene) {
        exploreScene = explore
        battleScene  = battle
        titleScene = title
        self.view = view
    }
    
    func gotoBattleScene(badGuys : [Entity]) {
        battleScene.badGuys = badGuys
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
    
    func gotoTitleScene() {
        self.view.presentScene(titleScene)
    }
}

