//
//  InventoryItem.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 8/9/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import Foundation

protocol Item {
    var name : String { get }
}

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
    func getBonus(bonus : EquipmentAffix.Bonus) -> Int
    
    var affixes : [EquipmentAffix] { get }
    var slot : Equipment.EquipmentSlot? { get }
}

struct EquipmentAffix {
    enum Bonus {
        case Power, Spell, Hit, Dodge, Block, Parry
    }
    
    var bonus : [Bonus : Int] = [Bonus : Int]()
}

class EquipableItem : Equipable {
    
    let affixes : [EquipmentAffix]
    var slot : Equipment.EquipmentSlot?
    
    init(slot : Equipment.EquipmentSlot, affixes : [EquipmentAffix]) {
        self.affixes = affixes
        self.slot = slot
    }
    
    func isEquipment() -> Bool {
        return true
    }
    
    func getBonus(bonusType: EquipmentAffix.Bonus) -> Int {
        return affixes.map({ affix in
            if let b = affix.bonus[bonusType] { return b }
            return 0
        }).reduce(0, combine: { accum, bonusVal in
            return accum + bonusVal
        })
    }
}

class InventoryItem : Equipable, Stackable, Consumable {
    let stackable : Stackable?
    let consumable : Consumable?
    let equipable : Equipable?
    let name : String
    
    var affixes : [EquipmentAffix] {
        get {
            if let e = equipable { return e.affixes }
            return []
        }
    }
    
    var slot : Equipment.EquipmentSlot? {
        get {
            return equipable?.slot
        }
    }
    
    init(name : String, stackable : Stackable?, consumable : Consumable?, equipable :Equipable?) {
        self.stackable = stackable
        self.consumable = consumable
        self.equipable = equipable
        self.name = name
    }
    
    func isEquipment() -> Bool {
        if let e = equipable { return e.isEquipment() }
        return false
    }
    
    func getBonus(bonus: EquipmentAffix.Bonus) -> Int {
        if let e = equipable { return e.getBonus(bonus) }
        return 0
    }
    
    func isConsumable() -> Bool {
        if let c = consumable { return c.isConsumable() }
        return false
    }
    
    func isStackable() -> Bool {
        if let s = stackable { return s.isStackable() }
        return false
    }
}

