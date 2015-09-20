//
//  TitleScene.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 8/5/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import SpriteKit

class TitleScene : BaseScene {
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        sceneController?.gotoExploreScene()
    }
    
    override func createSceneContents() {
        super.createSceneContents()
        self.createHelloNode()
    }
    
    func createHelloNode() -> Void
    {
        let titleNode = SKLabelNode(fontNamed: "Helvetica")
        let touchToStartNode : SKLabelNode = SKLabelNode(fontNamed: "Helvetica")
        
        titleNode.text = "Simple Dungeon"
        titleNode.fontSize = 50
        
        touchToStartNode.text = "Touch to Start"
        touchToStartNode.fontSize = 32
        
        titleNode.addChild(touchToStartNode)
        
        let pos = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        titleNode.position = pos
        touchToStartNode.position = CGPointMake(0, -50)
        
        self.addChild(titleNode)
    }
}
