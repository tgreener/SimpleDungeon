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
        let playerBattleSquare = TouchSprite(color: SKColor.redColor(), size: CGSizeMake(10, 10))
        let graphicComponent = GraphicComponent(explore: playerAdventureSquare, battle: playerBattleSquare)
        let character = GameCharacter(strVal: 5, intVal: 5, wilVal: 5)
        let player = Entity(graphic: graphicComponent, position: IPoint(x: 0, y: 0), character : character)
        
        var swordAffix : EquipmentAffix = EquipmentAffix()
        swordAffix.bonus[EquipmentAffix.Bonus.Power] = 5
        let swordEquipable : Equipable = EquipableItem(slot: Equipment.EquipmentSlot.Weapon, affixes: [swordAffix])
        let sword : InventoryItem = InventoryItem(name: "Sword", stackable: nil, consumable: nil, equipable: swordEquipable)
        
        var shieldAffix : EquipmentAffix = EquipmentAffix()
        shieldAffix.bonus[EquipmentAffix.Bonus.Block] = 5
        let shieldEquipable : Equipable = EquipableItem(slot: Equipment.EquipmentSlot.Armor, affixes: [shieldAffix])
        let shield : InventoryItem = InventoryItem(name: "Shield", stackable: nil, consumable: nil, equipable: shieldEquipable)
        
        player.characterComponent?.inventory.equipment.setEquipment(sword, slot: sword.slot!)
        player.characterComponent?.inventory.equipment.setEquipment(shield, slot: shield.slot!)
        
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
