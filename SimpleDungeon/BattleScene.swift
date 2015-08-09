//
//  BattleScene.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 8/7/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import SpriteKit

class BattleScene : GameplayScene, TileSpriteListener {
    
    var badGuys : [Entity] = []
    
    override func createSceneContents() {
        super.createSceneContents()
        
        func createBattleButton(color : SKColor) -> TileSprite {
            let battleButton = TileSprite(color: color, size: CGSize(width: 100, height: 40))
            battleButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            battleButton.position = CGPoint(x: self.view!.frame.width / 2, y: self.view!.frame.height / 2)
            battleButton.userInteractionEnabled = true
            
            return battleButton
        }
        
        let strengthBattleButton = createBattleButton(SKColor.redColor())
        strengthBattleButton.position = CGPointMake(strengthBattleButton.position.x, strengthBattleButton.position.y + 50)
        let intelligenceBattleButton = createBattleButton(SKColor.blueColor())
        let willBattleButton = createBattleButton(SKColor.greenColor())
        willBattleButton.position = CGPointMake(willBattleButton.position.x, willBattleButton.position.y - 50)
        
        strengthBattleButton.addListener(self)
        intelligenceBattleButton.addListener(self)
        willBattleButton.addListener(self)
        
        addChild(strengthBattleButton)
        addChild(intelligenceBattleButton)
        addChild(willBattleButton)
    }
    
    func onTileTouched(sprite: TileSprite) {
        sceneController?.gotoExploreScene()
    }
}
