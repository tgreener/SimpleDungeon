//
//  PlayScene.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 8/5/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import SpriteKit

class ExploreScene : GameplayScene, TileSpriteListener {
    
    var grid : ColoredGrid!
    
    var gridNode : GridNode!
    
    override func createSceneContents() {
        super.createSceneContents()
        
        grid = ColoredGrid(x: 3, y: 3, color: SKColor.greenColor(), squareDimension: 16, listener: self)
        gridNode = GridNode(grid: grid)
        
        let boardScale = view!.frame.height / gridNode.calculateAccumulatedFrame().height
        
        gridNode.position = CGPointMake(self.view!.frame.width / 5, 0)
        gridNode.setScale(boardScale)


        addChild(gridNode)
        gridNode.placeSpriteAtLocation(player.positionComponent!, sprite: player.graphicComponent!)
    }
    
    func onTileTouched(sprite: TileSprite) {
        let absX = abs(player.positionComponent!.x - sprite.gridPosition.x)
        let absY = abs(player.positionComponent!.y - sprite.gridPosition.y)
        if (absX + absY) == 1 {
            player.positionComponent = sprite.gridPosition
            gridNode.moveSpriteToLocation(player.positionComponent!, sprite: player.graphicComponent!)
            advanceGameClock(5.0)
            if random(1, 100) > 60 {
                sceneController?.gotoBattleScene([])
            }
        }
    }
    
    func advanceGameClock(dt : Float) {
        player.characterComponent!.gameClockAdvanced(dt)
    }
}