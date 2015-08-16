//
//  PlayScene.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 8/5/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import SpriteKit

class ExploreScene : GameplayScene, TileSpriteListener, TouchSpriteListener {
    
    var grid : ColoredGrid!
    var gridNode : GridNode!
    var hasFinishedMove = true
    
    override func createSceneContents() {
        super.createSceneContents()
        
        grid = ColoredGrid(x: 3, y: 3, color: SKColor.greenColor(), squareDimension: 16, listener: self)
        gridNode = GridNode(grid: grid)
        
        let boardScale = view!.frame.height / gridNode.calculateAccumulatedFrame().height
        
        gridNode.position = CGPointMake(self.view!.frame.width / 5, 0)
        gridNode.setScale(boardScale)

        addChild(gridNode)
        
        player.graphicComponent!.exploreGraphic!.addListener(self)
    }
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        gridNode.placeSpriteAtLocation(player.positionComponent!, sprite: player.graphicComponent!.exploreGraphic!)
    }
    
    override func willMoveFromView(view: SKView) {
        player.graphicComponent!.exploreGraphic!.removeAllActions()
    }
    
    func onTileTouched(sprite: TileSprite) {
        let absX = abs(player.positionComponent!.x - sprite.gridPosition.x)
        let absY = abs(player.positionComponent!.y - sprite.gridPosition.y)
        
        if (absX + absY) == 1 && hasFinishedMove {
            player.positionComponent = sprite.gridPosition
            hasFinishedMove = false
            
            gridNode.moveSpriteToLocation(player.positionComponent!, sprite: player.graphicComponent!.exploreGraphic!) {
                self.hasFinishedMove = true
                self.advanceGameClock(5.0)
                
                var badGuys = [Entity?]()
                
                if random(1, 100) > 60 {
                    for i in 0...5 {
                        let badGuyGraphic = TouchSprite(color: SKColor.yellowColor(), size: CGSizeMake(10, 10))
                        let badCharacter = GameCharacter(strVal: 2, intVal: 2, wilVal: 2)
                        
                        let badGuy = Entity(graphic: GraphicComponent(explore: nil, battle: badGuyGraphic), position: nil, character: badCharacter)
                        badGuys.append(badGuy)
                    }
                    
                    self.sceneController?.gotoBattleScene(badGuys)
                }
            }
        }
    }
    
    func onSpriteTouched(sprite: TouchSprite) {
        if sprite === self.player.graphicComponent!.exploreGraphic {
            self.sceneController?.gotoCharacterMenuScene()
        }
    }
    
    func advanceGameClock(dt : Float) {
        player.characterComponent!.gameClockAdvanced(dt)
    }
}
