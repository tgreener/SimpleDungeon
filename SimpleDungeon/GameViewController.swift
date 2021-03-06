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
        
        let playerAdventureSquare = TouchSprite(color: SKColor.redColor(), size: CGSizeMake(10, 10))
        let playerBattleSquare = BattleGraphic(color: SKColor.redColor(), size: CGSizeMake(10, 10))
        let graphicComponent = GraphicComponent(explore: playerAdventureSquare, battle: playerBattleSquare)
        let character = GameCharacter(
            strVal: CharacterStatistic.MIN_VALUE,
            intVal: CharacterStatistic.MIN_VALUE,
            wilVal: CharacterStatistic.MIN_VALUE,
            isPlayer: true
        )
        let player = Entity(graphic: graphicComponent, position: IPoint(x: 0, y: 0), character : character)
        
        player.characterComponent?.equip(ItemFactory.createBoringSword(25))
        player.characterComponent?.equip(ItemFactory.createBoringShield(20))
        
        let titleScene = TitleScene()
        let explore = ExploreScene(player : player)
        let battle = BattleScene(player : player)
        let characterMenu = CharacterMenuScene(player: player)
        
        let sceneController = SceneController(
            view: spriteView,
            explore: explore,
            battle: battle,
            title : titleScene,
            character : characterMenu
        )
        
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
