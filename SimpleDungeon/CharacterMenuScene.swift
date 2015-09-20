//
//  CharacterMenuScene.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 8/9/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import SpriteKit

class CharacterMenuScene : GameplayScene, TouchSpriteListener {
    
    var strLabel : SKLabelNode!
    var intLabel : SKLabelNode!
    var wilLabel : SKLabelNode!
    
    var pwrLabel : SKLabelNode!
    var splLabel : SKLabelNode!
    var hitLabel : SKLabelNode!
    var blkLabel : SKLabelNode!
    var dgeLabel : SKLabelNode!
    var pryLabel : SKLabelNode!
    
    var amrLabel : SKLabelNode!
    var wpnLabel : SKLabelNode!
    
    override func createSceneContents() {
        super.createSceneContents()
        let statsPanelWidth = viewSize.width * 0.25
        let statsPanelHeight = viewSize.height * 0.95
        let statsRect = CGRectMake(0, 0, statsPanelWidth, statsPanelHeight)
        let statsPanelPath = CGPathCreateWithRoundedRect(statsRect, 3, 3, nil)
        
        let statsPane = SKShapeNode(path: statsPanelPath, centered: false)
        let margin = viewSize.height * 0.025
        statsPane.position = CGPointMake(viewSize.width * 0.75 - margin, margin)
        
        let statsDividerLinePath = CGPathCreateMutable()
        CGPathMoveToPoint(statsDividerLinePath, nil, 0, 0)
        CGPathAddLineToPoint(statsDividerLinePath, nil, statsPanelWidth, 0)
        let divider = SKShapeNode(path: statsDividerLinePath, centered: false)
        
        func createStatNameLabel(statName : String, position : CGPoint) -> SKLabelNode {
            let statNameLabel : SKLabelNode = SKLabelNode(fontNamed: "Helvetica")
            statNameLabel.fontSize = 20
            statNameLabel.text = statName + " :"
            statNameLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
            statNameLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
            statNameLabel.position = position
            
            return statNameLabel
        }
        
        func createStatValueLabel( position : CGPoint) -> SKLabelNode {
            let statValueLabel : SKLabelNode = SKLabelNode(fontNamed: "Helvetica")
            statValueLabel.fontSize = 20
            statValueLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
            statValueLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
            statValueLabel.position = position
            
            return statValueLabel
        }
        
        let strNamePosition = CGPointMake(statsRect.width * 0.05, statsRect.height * 0.95)
        let intNamePosition = CGPointMake(statsRect.width * 0.05, statsRect.height * 0.875)
        let wilNamePosition = CGPointMake(statsRect.width * 0.05, statsRect.height * 0.8)
        
        let strLabelPosition = CGPointMake(statsRect.width * 0.95, statsRect.height * 0.95)
        let intLabelPosition = CGPointMake(statsRect.width * 0.95, statsRect.height * 0.875)
        let wilLabelPosition = CGPointMake(statsRect.width * 0.95, statsRect.height * 0.8)
        
        let pwrNamePosition = CGPointMake(statsRect.width * 0.05, statsRect.height * 0.7)
        let splNamePosition = CGPointMake(statsRect.width * 0.05, statsRect.height * 0.625)
        let hitNamePosition = CGPointMake(statsRect.width * 0.05, statsRect.height * 0.55)
        let blkNamePosition = CGPointMake(statsRect.width * 0.05, statsRect.height * 0.475)
        let dgeNamePosition = CGPointMake(statsRect.width * 0.05, statsRect.height * 0.4)
        let pryNamePosition = CGPointMake(statsRect.width * 0.05, statsRect.height * 0.325)
        
        let pwrLabelPosition = CGPointMake(statsRect.width * 0.95, statsRect.height * 0.7)
        let splLabelPosition = CGPointMake(statsRect.width * 0.95, statsRect.height * 0.625)
        let hitLabelPosition = CGPointMake(statsRect.width * 0.95, statsRect.height * 0.55)
        let blkLabelPosition = CGPointMake(statsRect.width * 0.95, statsRect.height * 0.475)
        let dgeLabelPosition = CGPointMake(statsRect.width * 0.95, statsRect.height * 0.4)
        let pryLabelPosition = CGPointMake(statsRect.width * 0.95, statsRect.height * 0.325)
        
        divider.position = CGPointMake(0, statsRect.height * 0.75)
        
        statsPane.addChild(createStatNameLabel(player.characterComponent!.strength.name, position: strNamePosition))
        statsPane.addChild(createStatNameLabel(player.characterComponent!.intelligence.name, position: intNamePosition))
        statsPane.addChild(createStatNameLabel(player.characterComponent!.will.name, position: wilNamePosition))
        
        statsPane.addChild(createStatNameLabel("Attack", position: pwrNamePosition))
        statsPane.addChild(createStatNameLabel("Spell", position: splNamePosition))
        statsPane.addChild(createStatNameLabel("Hit", position: hitNamePosition))
        statsPane.addChild(createStatNameLabel("Block", position: blkNamePosition))
        statsPane.addChild(createStatNameLabel("Dodge", position: dgeNamePosition))
        statsPane.addChild(createStatNameLabel("Parry", position: pryNamePosition))
        
        strLabel = createStatValueLabel(strLabelPosition)
        intLabel = createStatValueLabel(intLabelPosition)
        wilLabel = createStatValueLabel(wilLabelPosition)
        
        pwrLabel = createStatValueLabel(pwrLabelPosition)
        splLabel = createStatValueLabel(splLabelPosition)
        hitLabel = createStatValueLabel(hitLabelPosition)
        blkLabel = createStatValueLabel(blkLabelPosition)
        dgeLabel = createStatValueLabel(dgeLabelPosition)
        pryLabel = createStatValueLabel(pryLabelPosition)
        
        statsPane.addChild(strLabel)
        statsPane.addChild(intLabel)
        statsPane.addChild(wilLabel)
        statsPane.addChild(divider)
        statsPane.addChild(pwrLabel)
        statsPane.addChild(splLabel)
        statsPane.addChild(hitLabel)
        statsPane.addChild(blkLabel)
        statsPane.addChild(dgeLabel)
        statsPane.addChild(pryLabel)
        
        let weaponNamePosition = CGPointMake(viewSize.width * 0.01, viewSize.height * 0.8)
        let armorNamePosition  = CGPointMake(viewSize.width * 0.01, viewSize.height * 0.725)
        
        let weaponValuePosition = CGPointMake(viewSize.width * 0.25, viewSize.height * 0.8)
        let armorValuePosition = CGPointMake(viewSize.width * 0.25, viewSize.height * 0.725)
        
        let weaponNameLabel = createStatNameLabel("Weapon", position: weaponNamePosition)
        let armorNameLabel  = createStatNameLabel("Armor",  position: armorNamePosition)
        
        wpnLabel = createStatValueLabel(weaponValuePosition)
        amrLabel = createStatValueLabel(armorValuePosition)
        
        addChild(weaponNameLabel)
        addChild(armorNameLabel)
        addChild(wpnLabel)
        addChild(amrLabel)
        
        let backButton = TouchSprite(color: SKColor.greenColor(), size: CGSizeMake(150, 50))
        backButton.anchorPoint = CGPoint.zero
        backButton.position = CGPointMake(50, 50)
        backButton.addListener(self)
        
        addChild(statsPane)
        addChild(backButton)
    }
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        strLabel.text = String(player.characterComponent!.strength.currentValue)
        intLabel.text = String(player.characterComponent!.intelligence.currentValue)
        wilLabel.text = String(player.characterComponent!.will.currentValue)
        
        pwrLabel.text = String(player.characterComponent!.power)
        splLabel.text = String(player.characterComponent!.spell)
        hitLabel.text = String(player.characterComponent!.hit)
        blkLabel.text = String(player.characterComponent!.block)
        dgeLabel.text = String(player.characterComponent!.dodge)
        pryLabel.text = String(player.characterComponent!.parry)
        
        wpnLabel.text = player.characterComponent!.inventory.equipment.slotMap[Equipment.EquipmentSlot.Weapon]!.name
        amrLabel.text = player.characterComponent!.inventory.equipment.slotMap[Equipment.EquipmentSlot.Armor]!.name
    }
    
    func onSpriteTouched(sprite: TouchSprite) {
        sceneController?.gotoExploreScene()
    }
    
}
