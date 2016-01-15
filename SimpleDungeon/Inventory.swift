//
//  Inventory.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 8/9/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import Foundation

class Equipment {
    
    enum EquipmentSlot {
        case Armor, Weapon
    }
    
    var slotMap : [EquipmentSlot: InventoryItem] = [EquipmentSlot: InventoryItem]()
    
    func setEquipment(equip : InventoryItem) {
        if let slot = equip.slot { slotMap[slot] = equip }
    }
    
    func calculateBonus(bonusType : EquipmentAffix.Bonus) -> Int {
        return Array(slotMap.values).map( { item in item.getBonus(bonusType)} ).reduce(0, combine: { accum, stat in return accum + stat })
    }
    
    func getAllSkillsGenerators() -> [SkillCreationFunction] {
        return Array(slotMap.values).map { item in
            return item.getSkills()
        }.reduce([SkillCreationFunction]()) { accum, skills in
            return accum + skills
        }
    }
}

class Pack {
    var items : [InventoryItem] = []
}

class Inventory {
    let pack : Pack
    let equipment : Equipment
    
    init() {
        pack = Pack()
        equipment = Equipment()
    }
}
