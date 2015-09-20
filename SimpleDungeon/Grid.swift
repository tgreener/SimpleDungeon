//
//  Grid.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 8/5/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import SpriteKit

protocol SpacialSpriteGrid  {
    var xSize : Int { get }
    var ySize : Int { get }
    func getSpriteAt(x x : Int, y : Int) -> TileSprite
}

struct BaseGrid : SpacialSpriteGrid {
    let xSize : Int
    let ySize : Int
    
    var container : [TileSprite]
    
    init(x : Int, y : Int) {
        self.xSize = x
        self.ySize = y
        
        container = [TileSprite](count: x * y, repeatedValue: TileSprite(color: SKColor.whiteColor(), size: CGSizeMake(16, 16)))
    }
    
    mutating func setSpriteAt(x x : Int, y : Int, sprite : TileSprite) {
        sprite.userInteractionEnabled = true
        sprite.anchorPoint = CGPoint.zero
        sprite.position = CGPointMake(CGFloat(x) * (sprite.frame.width + 1), CGFloat(y) * (sprite.frame.height + 1))
        sprite.gridPosition = IPoint(x: x, y: y)
        
        container[(xSize * y) + x] = sprite
    }
    
    func getSpriteAt(x x : Int, y : Int) -> TileSprite {
        return container[(xSize * y) + x]
    }
}

struct ColoredGrid : SpacialSpriteGrid {
    var innerGrid : BaseGrid
    var xSize : Int {
        get { return innerGrid.xSize }
    }
    var ySize : Int {
        get { return innerGrid.ySize }
    }
    
    init(x : Int, y : Int, color : SKColor, squareDimension : CGFloat, listener : TileSpriteListener) {
        innerGrid = BaseGrid(x: x, y: y)
        
        for var x = 0 ; x < innerGrid.xSize ; x++ {
            for var y = 0 ; y < innerGrid.ySize ; y++ {
                setSpriteAt(x: x, y: y, color: color, squareDimension: squareDimension, listener : listener)
            }
        }
    }
    
    mutating func setSpriteAt(x x : Int, y : Int, color : SKColor, squareDimension : CGFloat, listener : TileSpriteListener) {
        let sprite = TileSprite(color: color, size: CGSizeMake(squareDimension, squareDimension))
        sprite.addListener(listener)
        innerGrid.setSpriteAt(x: x, y: y, sprite: sprite)
    }
    
    func getSpriteAt(x x : Int, y : Int) -> TileSprite {
        return innerGrid.container[(innerGrid.xSize * y) + x]
    }
}

struct TexturedGrid : SpacialSpriteGrid {
    var innerGrid : BaseGrid
    var xSize : Int {
        get { return innerGrid.xSize }
    }
    var ySize : Int {
        get { return innerGrid.ySize }
    }
    
    init(x : Int, y : Int, texture : SKTexture, listener : TileSpriteListener) {
        innerGrid = BaseGrid(x: x, y: y)
        
        for var x = 0 ; x < innerGrid.xSize ; x++ {
            for var y = 0 ; y < innerGrid.ySize ; y++ {
                setSpriteAt(x: x, y: y, texture: texture, listener : listener)
            }
        }
    }
    
    mutating func setSpriteAt(x x : Int, y : Int, texture : SKTexture, listener : TileSpriteListener) {
        let sprite = TileSprite(texture: texture)
        sprite.addListener(listener)
        innerGrid.setSpriteAt(x: x, y: y, sprite: sprite)
    }
    
    func getSpriteAt(x x : Int, y : Int) -> TileSprite {
        return innerGrid.container[(innerGrid.xSize * y) + x]
    }
}

class GridNode : SKNode {
    let grid : SpacialSpriteGrid
    
    init(grid: SpacialSpriteGrid) {
        self.grid = grid
        super.init()
        
        for var x = 0 ; x < grid.xSize ; x++ {
            for var y = 0 ; y < grid.ySize ; y++ {
                addChild(grid.getSpriteAt(x: x, y: y))
            }
        }
    }
    
    func placeSpriteAtLocation(x : Int, y : Int, sprite : SKSpriteNode) {
        let tileSprite = grid.getSpriteAt(x: x, y: y)
        let xPosition = tileSprite.position.x + (tileSprite.frame.width / 2)
        let yPosition = tileSprite.position.y + (tileSprite.frame.height / 2)
        sprite.anchorPoint = CGPointMake(0.5, 0.5)
        sprite.position = CGPointMake(xPosition, yPosition)
        
        if sprite.parent !== self && sprite.parent == nil { addChild(sprite) }
    }
    
    func placeSpriteAtLocation(point : IPoint, sprite : SKSpriteNode) {
        placeSpriteAtLocation(point.x, y: point.y, sprite: sprite)
    }
    
    func moveSpriteToLocation(x : Int, y : Int, sprite : SKSpriteNode, completionHandler : () -> Void) {
        if (sprite.parent === self) {
            let tileSprite = grid.getSpriteAt(x: x, y: y)
            let xPosition = tileSprite.position.x + (tileSprite.frame.width / 2)
            let yPosition = tileSprite.position.y + (tileSprite.frame.height / 2)
            
            let moveAction = SKAction.moveTo(CGPointMake(xPosition, yPosition), duration: 0.2)
            let afterMoveCall = SKAction.runBlock(completionHandler)
            sprite.runAction(SKAction.sequence([
                moveAction,
                afterMoveCall
                ]))
        }
    }
    
    func moveSpriteToLocation(point : IPoint, sprite : SKSpriteNode, completionHandler : () -> Void) {
        moveSpriteToLocation(point.x, y: point.y, sprite: sprite, completionHandler: completionHandler)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


