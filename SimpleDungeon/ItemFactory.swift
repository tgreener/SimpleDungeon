//
//  ItemFactory.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 9/1/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import Foundation

class  ItemFactory {
    static func createBoringSword() -> InventoryItem {
        var swordAffix : EquipmentAffix = EquipmentAffix()
        swordAffix.bonus[EquipmentAffix.Bonus.Power] = 5
        let swordEquipable : Equipable = EquipableItem(slot: Equipment.EquipmentSlot.Weapon, affixes: [swordAffix])
        let sword : InventoryItem = InventoryItem(name: "Sword", stackable: nil, consumable: nil, equipable: swordEquipable)
        
        return sword
    }
    
    static func createBoringShield() -> InventoryItem {
        var shieldAffix : EquipmentAffix = EquipmentAffix()
        shieldAffix.bonus[EquipmentAffix.Bonus.Block] = 5
        let shieldEquipable : Equipable = EquipableItem(slot: Equipment.EquipmentSlot.Armor, affixes: [shieldAffix])
        let shield : InventoryItem = InventoryItem(name: "Shield", stackable: nil, consumable: nil, equipable: shieldEquipable)
        
        return shield
    }
}
