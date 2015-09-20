//
//  TouchSprite.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 8/9/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import SpriteKit

protocol TouchSpriteListener {
    func onSpriteTouched(sprite : TouchSprite) -> Void
}

class TouchSprite : SKSpriteNode {
    let notifier : Notifier<TouchSpriteListener> = Notifier<TouchSpriteListener>()
    
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
        notifier.notify({ listener in  listener.onSpriteTouched(self) })
    }
    
    func addListener(listener : TouchSpriteListener) {
        notifier.addListener(listener)
    }
}
