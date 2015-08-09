//
//  TileSprite.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 8/6/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import SpriteKit

protocol TileSpriteListener {
    func onTileTouched(sprite : TileSprite) -> Void
}

class TileSprite : SKSpriteNode {
    var gridPosition : IPoint = IPoint(x: 0, y: 0)
    let notifier : Notifier<TileSpriteListener> = Notifier<TileSpriteListener>()
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        notifier.notify({ listener in  listener.onTileTouched(self) })
    }
    
    func addListener(listener : TileSpriteListener) {
        notifier.addListener(listener)
    }
}
