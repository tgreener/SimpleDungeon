//
//  BattleScene.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 8/7/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

//TODO: UI maintains provides valid state to commands
//TODO: Commands apply rules

import SpriteKit
import GameKit

let BATTLE_LISTENER_KEY = "BATTLE_LISTENER_KEY"

class BattleScene : GameplayScene, BattleListener, BattleUIDelegate {
    
    var battle : BattleModel!
    var battleView : BattleUI!
    var battleCommandController = BattleCommandController()

    override func createSceneContents() {
        super.createSceneContents()
    }
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        var badGuyGraphics : [BattleGraphic] = [BattleGraphic]()
        
        for guy in battle.badGuys {
            if let graphic = guy?.graphicComponent?.battleGraphic {
                badGuyGraphics.append(graphic)
            }
        }
        
        battleView = BattleUI(viewSize: self.viewSize, playerGraphic: player.graphicComponent!.battleGraphic!, badGuyGraphics: badGuyGraphics, delegate: self, battle: battle);
        battleView.didMoveToView(view)
        addChild(battleView)
        
        battle.notifier.addListenerWithName(self, name: BATTLE_LISTENER_KEY)
        player.graphicComponent?.battleGraphic?.addTouchHandler { sprite in
            self.sceneController?.gotoCharacterMenuScene()
        }
    }
    
    override func willMoveFromView(view: SKView) {
        battleView.willMoveFromView(view)
        battleView.removeFromParent()
        battle.notifier.removeListener(named: BATTLE_LISTENER_KEY)
    }

    func didSetPrimaryTarget(entity: Entity) {
        battleView.primaryTargetChosen(entity.graphicComponent!.battleGraphic!, target: entity)
    }
    
    func onEntityDestroyed(entity: Entity) {
        battleView.onEntityDestroyed(entity)
    }
    
    func onBattleEnded() {
        sceneController?.gotoExploreScene()
    }
    
    func onActionPerformed() {
        battleView.onActionPerformed()
    }
    
    func onTurnChanged(turn: Turn) {
        switch turn {
        case Turn.Player:
            battleView.touchEnabled = true
        case Turn.Enemy:
            battleView.touchEnabled = false
            
            struct SkillListener : SkillApplicationListener {
                let model : BattleModel
                
                init(model : BattleModel) {
                    self.model = model
                }
                
                func receivesDamage(target target: Entity, amount: Int) {
                    target.characterComponent?.health.decrease(amount)
                    target.graphicComponent?.battleGraphic?.showDamagePopup(amount)
                    
                    print((target === model.player ? "Player" : "Target") + " HP : \(target.characterComponent!.health.currentValue)")
                    if target.characterComponent?.health.currentValue == 0 {
                        model.notifier.notify() { listener in listener.onEntityDestroyed(target) }
                        model.badGuys = model.badGuys.filter() { $0 !== target }
                    }
                }
                
                func receivesHealing(target target: Entity, amount: Int) {
                    target.characterComponent?.health.increase(amount)
                    target.graphicComponent?.battleGraphic?.showHealingPopup(amount)
                }
                
                func receivesBuff(target target: Entity, buff: AnyObject?) {
                    
                }
                
                func blocksAttack(target target: Entity, baseDamage: Int) {
                    target.graphicComponent?.battleGraphic?.showBlockPopup()
                    print((target === model.player ? "Player" : "Target") + " blocks!")
                }
                
                func dodgesAttack(target target: Entity, baseDamage: Int) {
                    target.graphicComponent?.battleGraphic?.showDodgePopup()
                    print((target === model.player ? "Player" : "Target") + " dodges!")
                }
                
                func parriesAttack(target target: Entity, baseDamage: Int) {
                    target.graphicComponent?.battleGraphic?.showParryPopup()
                    print((target === model.player ? "Player" : "Target") + " parries!")
                }
            }
            
            func generateBadGuyActions() -> [()->Void]{
                var actionFunctions : [() -> Void] = Array<()->Void>()
                
                for guy in battle.badGuys {
                    let badSkill = Skill(character: guy!.characterComponent!, targetFilterCreator: skillTargetNone)
                    badSkill.setTarget([], primary: player)
                    
                    actionFunctions.append {
                        badSkill.perform(SkillListener(model: self.battle))
                    }
                }
                
                return actionFunctions
            }
            
            let badGuyActionFunctions = generateBadGuyActions()
            
            func runBadGuyActions(actions : [()->Void]) {
                runAction(SKAction.sequence([
                    SKAction.waitForDuration(0.4),
                    SKAction.runBlock {
                        if actions.count > 0 {
                            actions[0]()
                            runBadGuyActions(Array(actions[1..<actions.count]))
                        }
                        else {
                            self.battleView.touchEnabled = true
                            let badGuyTurnCompleteRules = GKRuleSystem()
                            badGuyTurnCompleteRules.assertFact(String(TurnFacts.AITurnComplete))
                            
                            badGuyTurnCompleteRules.addRule(TurnRule(battle: self.battle))
                            badGuyTurnCompleteRules.evaluate()
                        }
                    }
                    ]))
            }
            
            runBadGuyActions(badGuyActionFunctions)
        }
    }
    
    func onAbilityButtonTouched(ability : Ability) -> Void {
        var skill : Skill? = nil
        switch ability {
        case Ability.Str : skill = battle.strSkill
        case Ability.Int : skill = battle.intSkill
        case Ability.Wil : skill = battle.wilSkill
        default : skill = nil
        }
        
        guard let s = skill else { return }
        battleCommandController.runSingleCommand(ActionSelectedCommand(model: self.battle, skill: s))
    }
    
    func onTargetTouched(target: Entity) -> Void {
        battleCommandController.runSingleCommand(TargetSelectedCommand(battle: self.battle, target: target))
        
        if battle.badGuys.count == 0 { self.battle.notifier.notify({ listener in listener.onBattleEnded() }) }
    }
}
