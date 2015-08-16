//
//  CharacterMenuScene.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 8/9/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import SpriteKit

class CharacterMenuScene : GameplayScene, TouchSpriteListener {
    
    override func createSceneContents() {
        let statsPanelWidth = viewSize.width * 0.25
        let statsPanelHeight = viewSize.height * 0.95
        let statsRect = CGRectMake(0, 0, statsPanelWidth, statsPanelHeight)
        let statsPanelPath = CGPathCreateWithRoundedRect(statsRect, 3, 3, nil)
        
        let statsPane = SKShapeNode(path: statsPanelPath, centered: false)
        let margin = viewSize.height * 0.025
        statsPane.position = CGPointMake(viewSize.width * 0.75 - margin, margin)
        
        func createStatNameLabel(statName : String, position : CGPoint) -> SKLabelNode {
            let statNameLabel : SKLabelNode = SKLabelNode(fontNamed: "Helvetica")
            statNameLabel.fontSize = 20
            statNameLabel.text = statName + " :"
            statNameLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
            statNameLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
            statNameLabel.position = position
            
            return statNameLabel
        }
        
        func createStatValueLabel(statValue : UInt, position : CGPoint) -> SKLabelNode {
            let statValueLabel : SKLabelNode = SKLabelNode(fontNamed: "Helvetica")
            statValueLabel.fontSize = 20
            statValueLabel.text = String(statValue)
            statValueLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
            statValueLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
            statValueLabel.position = position
            
            return statValueLabel
        }
        
        let strNamePosition = CGPointMake(statsRect.width * 0.05, statsRect.height * 0.95)
        let intNamePosition = CGPointMake(statsRect.width * 0.05, statsRect.height * 0.85)
        let wilNamePosition = CGPointMake(statsRect.width * 0.05, statsRect.height * 0.75)
        
        let intLabelPosition = CGPointMake(statsRect.width * 0.95, statsRect.height * 0.95)
        let strLabelPosition = CGPointMake(statsRect.width * 0.95, statsRect.height * 0.85)
        let wilLabelPosition = CGPointMake(statsRect.width * 0.95, statsRect.height * 0.75)
        
        statsPane.addChild(createStatNameLabel(player.characterComponent!.strength.name, strNamePosition))
        statsPane.addChild(createStatNameLabel(player.characterComponent!.intelligence.name, intNamePosition))
        statsPane.addChild(createStatNameLabel(player.characterComponent!.will.name, wilNamePosition))
        
        statsPane.addChild(createStatValueLabel(player.characterComponent!.strength.currentValue, strLabelPosition))
        statsPane.addChild(createStatValueLabel(player.characterComponent!.intelligence.currentValue, intLabelPosition))
        statsPane.addChild(createStatValueLabel(player.characterComponent!.will.currentValue, wilLabelPosition))
        
        
        let backButton = TouchSprite(color: SKColor.greenColor(), size: CGSizeMake(150, 50))
        backButton.anchorPoint = CGPoint.zeroPoint
        backButton.position = CGPointMake(50, 50)
        backButton.addListener(self)
        
        addChild(statsPane)
        addChild(backButton)
    }
    
    func onSpriteTouched(sprite: TouchSprite) {
        sceneController?.gotoExploreScene()
    }
    
}
