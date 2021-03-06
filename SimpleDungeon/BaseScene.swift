//
//  BaseScene.swift
//  TextRPG
//
//  Created by Todd Greener on 4/14/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import SpriteKit

public class BaseScene : SKScene {
    var contentCreated : Bool = false
    var sceneController : SceneController? = nil
    
    override init() {
        super.init(size: UIScreen.mainScreen().bounds.size)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func didMoveToView(view: SKView) -> Void
    {
        if !self.contentCreated
        {
            self.backgroundColor = SKColor.grayColor()
            self.scaleMode = .AspectFit
            self.size = self.view!.frame.size
            self.createSceneContents()
        }
    }
    
    /**
    * This method will only be run the first time a scene moves to the view.
    * If you override didMoveToView make sure to call super.didMoveToView to
    * ensure that this method is executed correctly.
    */
    public func createSceneContents() {
        self.contentCreated = true
    }
    
}
