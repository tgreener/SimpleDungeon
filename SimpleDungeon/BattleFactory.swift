//
//  BattleFactory.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 11/15/15.
//  Copyright © 2015 Todd Greener. All rights reserved.
//

import SpriteKit

struct BattleFactory {
    
    static func createBattle(player : Entity) -> BattleModel {
        var badGuys = [Entity]()
        var grid : BattleGrid = BaseBattleGrid()
        
        for index : UInt in 0...5 {
            let badGuyGraphic = BattleGraphic(color: SKColor.yellowColor(), size: CGSizeMake(10, 10))
            let badCharacter = GameCharacter(strVal: 2, intVal: 2, wilVal: 2)
            
            badCharacter.equip(ItemFactory.createBoringShield())
            badCharacter.equip(ItemFactory.createBoringSword(2))
            
            let badGuy = Entity(graphic: GraphicComponent(explore: nil, battle: badGuyGraphic), position: nil, character: badCharacter)
            badGuys.append(badGuy)
            
            do { try grid.placeEntity(badGuy, column: index / 3, row: index % 3) } catch { continue }
        }
        
        return BattleModel(player: player, badGuys: badGuys, battleGrid: grid)
    }
}

