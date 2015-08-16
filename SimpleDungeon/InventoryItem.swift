//
//  InventoryItem.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 8/9/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import Foundation

protocol Stackable {
    func isStackable() -> Bool
}

class StackableItem : Stackable {
    func isStackable() -> Bool {
        return true
    }
}

protocol Consumable {
    func isConsumable() -> Bool
}

class ConsumableItem : Consumable {
    func isConsumable() -> Bool {
        return true
    }
}

protocol Equipable {
    func isEquipment() -> Bool
}

class EquipmentAffix {
    
}

class EquipableItem : Equipable {
    
    let affixes : EquipmentAffix
    
    init(affixes : EquipmentAffix) {
        self.affixes = affixes
    }
    
    func isEquipment() -> Bool {
        return true
    }
}

class InventoryItem : Stackable, Consumable, Equipable {
    let stackable : Stackable?
    let consumable : Consumable?
    let equipable : Equipable?
    let name : String
    
    init(name : String, stackable : Stackable?, consumable : Consumable?, equipable :Equipable?) {
        self.stackable = stackable
        self.consumable = consumable
        self.equipable = equipable
        self.name = name
    }
    
    func isEquipment() -> Bool {
        return false
    }
    
    func isConsumable() -> Bool {
        return false
    }
    
    func isStackable() -> Bool {
        return false
    }
}

