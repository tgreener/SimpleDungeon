//
//  GameViewController.swift
//  TextRPG
//
//  Created by Todd Greener on 4/14/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//
import UIKit
import SpriteKit

class GameViewController: UIViewController {
    var startScene : TitleScene!
    var showNodeCount : Bool = true
    var showFPS : Bool = true
    var ignoreSiblingOrder : Bool = true
    
    override func loadView() {
        super.loadView();
        
        let gameView : SKView = SKView(frame: UIScreen.mainScreen().bounds)
        
        self.view = gameView;
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let spriteView : SKView = self.view as! SKView
        spriteView.showsNodeCount = self.showNodeCount
        spriteView.showsFPS = self.showFPS
        spriteView.ignoresSiblingOrder = self.ignoreSiblingOrder
        
        let playerSquare = SKSpriteNode(color: SKColor.redColor(), size: CGSizeMake(10, 10))
        let character = GameCharacter(strVal: 5, intVal: 5, wilVal: 5)
        let player = Entity(graphic: playerSquare, position: IPoint(x: 0, y: 0), character : character)
        
        let explore = ExploreScene(player : player)
        let battle = BattleScene(player : player)
        
        let sceneController = SceneController(view: spriteView, explore: explore, battle: battle, title : startScene)
        explore.sceneController = sceneController
        battle.sceneController = sceneController
        startScene.sceneController = sceneController
        
        sceneController.gotoTitleScene()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
