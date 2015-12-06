//
//  TouchSprite.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 8/9/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import SpriteKit

class TouchSprite : SKSpriteNode {
    var callbacks : [(sprite : TouchSprite) -> Void] = Array<(sprite : TouchSprite) -> Void>()
    
    init(texture : SKTexture?) {
        super.init(texture: texture, color: UIColor.clearColor(), size: texture!.size())
        self.userInteractionEnabled = true
    }
    
    init(color : SKColor, size : CGSize) {
        super.init(texture: nil, color: color, size: size)
        self.userInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        callbacks.forEach { callback in callback(sprite: self) }
    }
    
    func addTouchHandler(callback : (sprite : TouchSprite) -> Void) {
        callbacks.append(callback)
    }
}
