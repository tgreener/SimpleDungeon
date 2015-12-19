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

enum BattleFlowFacts : String {
    case SkillSelected, TargetSelected
}

protocol BattleRef : class {
    var battle     : BattleModel! { get }
    var battleView : BattleUI!    { get }
    var battleFlowRuleSystem : GKRuleSystem { get }
}

class BattleScene : GameplayScene, BattleListener, BattleUIDelegate, BattleRef {
    
    var battle : BattleModel!
    var battleView : BattleUI!
    var battleCommandController = BattleCommandController()
    
    let battleFlowRuleSystem = GKRuleSystem()

    override func createSceneContents() {
        super.createSceneContents()
        
        battleFlowRuleSystem.addRule(PlayerBattleActionRule(ref: self))
        battleFlowRuleSystem.addRule(TurnRule(ref: self))
        
        player.graphicComponent?.battleGraphic?.addTouchHandler { sprite in
            self.sceneController?.gotoCharacterMenuScene()
        }
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
        
        battleFlowRuleSystem.reset()
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
            battleFlowRuleSystem.reset()
            
            guard let _ = battle.currentSkill else { break }
            battleFlowRuleSystem.assertFact(String(BattleFlowFacts.SkillSelected))
        case Turn.Enemy:
            battleView.touchEnabled = false
            
//            func performActionOnTarget(target: Entity, attacker: GameCharacter) {
//                guard let targetCharacter = target.characterComponent else { return }
//                
//                let skillApplicationRuleSystem = GKRuleSystem()
//                skillApplicationRuleSystem.addRule(SkillApplicationRule(target: targetCharacter))
//                skillApplicationRuleSystem.addRule(DidBlockRule(ref: self, defender: target, attacker: attacker))
//                skillApplicationRuleSystem.addRule(DidParryRule(ref: self, defender: target, attacker: attacker))
//                skillApplicationRuleSystem.addRule(DidDodgeRule(ref: self, defender: target, attacker: attacker))
//                skillApplicationRuleSystem.addRule(FailedDefenseRule(ref: self, defender: target, attacker: attacker))
//                
//                skillApplicationRuleSystem.evaluate()
//            }
//            
//            func performAction(skill: Skill) {
//                guard let primaryTarget = skill.primaryTarget else {return}
//                performActionOnTarget(primaryTarget, attacker: skill.character)
//                
//                for guy in skill.targets {
//                    guard let target = guy else { continue }
//                    performActionOnTarget(target, attacker: skill.character)
//                }
//            }
//
//            func generateBadGuyActions() -> [()->Void]{
//                var actionFunctions : [() -> Void] = Array<()->Void>()
//                
//                for guy in battle.badGuys {
//                    let badSkill = Skill(character: guy!.characterComponent!, targetFilterCreator: skillTargetNone)
//                    badSkill.setTarget([], primary: player)
//                    
//                    actionFunctions.append {
//                        performAction(badSkill)
//                    }
//                }
//                
//                return actionFunctions
//            }
//            
//            let badGuyActionFunctions = generateBadGuyActions()
//            
//            func runBadGuyActions(actions : [()->Void]) {
//                runAction(SKAction.sequence([
//                    SKAction.waitForDuration(0.4),
//                    SKAction.runBlock {
//                        if actions.count > 0 {
//                            actions[0]()
//                            runBadGuyActions(Array(actions[1..<actions.count]))
//                        }
//                        else {
//                            self.battleView.touchEnabled = true
//                            let badGuyTurnCompleteRules = GKRuleSystem()
//                            badGuyTurnCompleteRules.assertFact(String(TurnFacts.AITurnComplete))
//                            
//                            badGuyTurnCompleteRules.addRule(TurnRule(ref: self))
//                            badGuyTurnCompleteRules.evaluate()
//                        }
//                    }
//                    ]))
//            }
//            
//            runBadGuyActions(badGuyActionFunctions)
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
        battleCommandController.runSingleCommand(ActionSelectedCommand(ref: self, skill: s))
        battleFlowRuleSystem.evaluate()
    }
    
    func onTargetTouched(target: Entity) -> Void {
        battleCommandController.runSingleCommand(TargetSelectedCommand(ref: self, target: target))
        battleFlowRuleSystem.evaluate()
        
        if battle.badGuys.count == 0 { self.battle.notifier.notify({ listener in listener.onBattleEnded() }) }
    }
}
