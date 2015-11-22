//
//  ItemFactory.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 9/1/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import Foundation

class  ItemFactory {
    static func createBoringSword(atkVal : Int) -> InventoryItem {
        var swordAffix : EquipmentAffix = EquipmentAffix()
        swordAffix.bonus[EquipmentAffix.Bonus.Power] = atkVal
        let swordEquipable : Equipable = EquipableItem(slot: Equipment.EquipmentSlot.Weapon, affixes: [swordAffix])
        let sword : InventoryItem = InventoryItem(name: "Sword", stackable: nil, consumable: nil, equipable: swordEquipable)
        
        return sword
    }
    
    static func createBoringSword() -> InventoryItem {
        return createBoringSword(5)
    }
    

    static func createBoringShield(blkVal : Int) -> InventoryItem {
        var shieldAffix : EquipmentAffix = EquipmentAffix()
        shieldAffix.bonus[EquipmentAffix.Bonus.Block] = blkVal
        let shieldEquipable : Equipable = EquipableItem(slot: Equipment.EquipmentSlot.Armor, affixes: [shieldAffix])
        let shield : InventoryItem = InventoryItem(name: "Shield", stackable: nil, consumable: nil, equipable: shieldEquipable)
        
        return shield
    }
    
    static func createBoringShield() -> InventoryItem {
        return createBoringShield(5)
    }
}
