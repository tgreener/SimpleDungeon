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
        
        let slashSkillCreator : SkillCreationFunction = { character in
            return try! SkillBuilder().set(character)
                .set("Slash")
                .set(CharacterDescriptionVector(intellect: 0, strength: 1, will: 0))
                .set(skillTargetNone)
                .set(RepeatableRuleSystem())
                .build()
        }
        let cleaveSkillCreator : SkillCreationFunction = { character in
            return try! SkillBuilder().set(character)
                .set("Cleave")
                .set(CharacterDescriptionVector(intellect: 1, strength: 1, will: 0))
                .set(skillTargetNextInColumn)
                .set(RepeatableRuleSystem())
                .build()
        }
        swordAffix.skills.append(slashSkillCreator)
        swordAffix.skills.append(cleaveSkillCreator)
        
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
        
        let shieldSkillCreator : SkillCreationFunction = { character in
            return try! SkillBuilder().set(character)
                .set("Shield Bash")
                .set(CharacterDescriptionVector(intellect: 0, strength: 1, will: 1))
                .set(skillTargetRow)
                .set(RepeatableRuleSystem())
                .build()
        }
        shieldAffix.skills.append(shieldSkillCreator)
        
        let shieldEquipable : Equipable = EquipableItem(slot: Equipment.EquipmentSlot.Armor, affixes: [shieldAffix])
        let shield : InventoryItem = InventoryItem(name: "Shield", stackable: nil, consumable: nil, equipable: shieldEquipable)
        
        return shield
    }
    
    static func createBoringShield() -> InventoryItem {
        return createBoringShield(5)
    }
}
