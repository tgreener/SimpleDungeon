//
//  GameplayScene.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 8/9/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import SpriteKit

class GameplayScene : BaseScene {
    
    let player : Entity
    var viewSize : CGSize = CGSize.zero
    
    init(player : Entity) {
        self.player = player
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        viewSize = view.frame.size
        super.didMoveToView(view)
    }
}
