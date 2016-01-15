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
    func getSkills() -> [SkillCreationFunction]
    
    var affixes : [EquipmentAffix] { get }
    var slot : Equipment.EquipmentSlot? { get }
}

struct EquipmentAffix {
    enum Bonus {
        case Power, Spell, Hit, Dodge, Block, Parry
    }
    
    var bonus : [Bonus : Int] = [Bonus : Int]()
    var skills : [SkillCreationFunction] = [SkillCreationFunction]()
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
    
    func getSkills() -> [SkillCreationFunction] {
        return affixes.map({ (affix: EquipmentAffix) -> [SkillCreationFunction] in
            return affix.skills
        }).reduce([SkillCreationFunction]()) { accum, skills in
            return accum + skills
        }
    }
}

class InventoryItem : Equipable, Stackable, Consumable {
    let stackable : Stackable?
    let consumable : Consumable?
    let equipable : Equipable?
    let name : String
    
    var affixes : [EquipmentAffix] {
        get {
            guard let e = equipable else { return [] }
            return e.affixes
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
        guard let e = equipable else { return false }
        return e.isEquipment()
    }
    
    func getBonus(bonus: EquipmentAffix.Bonus) -> Int {
        guard let e = equipable else { return 0 }
        return e.getBonus(bonus)
    }
    
    func getSkills() -> [SkillCreationFunction] {
        guard let e = equipable else { return [] }
        return e.getSkills()
    }
    
    func isConsumable() -> Bool {
        guard let c = consumable else { return false }
        return c.isConsumable()
    }
    
    func isStackable() -> Bool {
        guard let s = stackable else { return false }
        return s.isStackable()
    }
}

