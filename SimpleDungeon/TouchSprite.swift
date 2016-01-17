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
    var border : SKShapeNode? = nil
    
    init(texture : SKTexture?) {
        super.init(texture: texture, color: UIColor.clearColor(), size: texture!.size())
        self.userInteractionEnabled = true
    }
    
    init(color : SKColor, size : CGSize) {
        super.init(texture: nil, color: color, size: size)
        self.userInteractionEnabled = true
    }
    
    convenience init(size : CGSize) {
        self.init(color: UIColor.clearColor(), size: size)
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
    
    func setBorder() {
        let rectanglePath = CGPathCreateWithRect(CGRect(origin: CGPoint.zero, size: self.size), nil)
        self.border = SKShapeNode(path: rectanglePath, centered: true)
        
        guard let border = self.border else { return }
        
        border.strokeColor = UIColor.whiteColor()
        border.position = CGPoint(x: border.frame.midX, y: border.frame.midY)
        
        self.addChild(border)
    }
    
    func setBorderGlowValue(value : CGFloat) {
        guard let border = self.border else { return }
        
        border.glowWidth = value
    }
}

class LabeledTouchSprite : TouchSprite {
    let label : SKLabelNode
    
    init(label : String, size : CGSize) {
        self.label = SKLabelNode(fontNamed: "Courier")
        super.init(color: UIColor.clearColor(), size : size)
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.label.text = label
        self.label.fontSize = 12
        self.addChild(self.label)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

    



