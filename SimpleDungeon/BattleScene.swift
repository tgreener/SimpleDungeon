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
    var playerInteractionRuleSystem : GKRuleSystem { get }
}

class BattleScene : GameplayScene, BattleListener, BattleUIDelegate, BattleRef {
    
    var battle : BattleModel!
    var battleView : BattleUI!
    var battleCommandController = BattleCommandController()
    
    var characterTurnCounter : UInt = 0
    
    let playerInteractionRuleSystem = GKRuleSystem()
    let battleTurnRuleSystem = GKRuleSystem()

    override func createSceneContents() {
        super.createSceneContents()
        
        playerInteractionRuleSystem.addRule(PlayerBattleActionRule(ref: self))
        
        player.graphicComponent?.battleGraphic?.addTouchHandler { sprite in
            self.sceneController?.gotoCharacterMenuScene()
        }
    }
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        // Setup View
        var badGuyGraphics : [BattleGraphic] = [BattleGraphic]()
        
        for guy in battle.badGuys {
            if let graphic = guy.graphicComponent?.battleGraphic {
                badGuyGraphics.append(graphic)
            }
        }
        
        battleView = BattleUI(viewSize: self.viewSize,
            playerGraphic  : player.graphicComponent!.battleGraphic!,
            badGuyGraphics : badGuyGraphics,
            delegate       : self);
        
        battleView.didMoveToView(view)
        addChild(battleView)
        
        // Let's try to get rid of this weirdness
        battle.notifier.addListenerWithName(self, name: BATTLE_LISTENER_KEY)
        
        // Setup Rules
        playerInteractionRuleSystem.reset()
        
        battleTurnRuleSystem.removeAllRules()
        battleTurnRuleSystem.reset()
        
        let badGuyTurnAction = { (system : GKRuleSystem, entity : Entity) in self.onBadGuyAction(entity) }
        let playerTurnAction = { (system : GKRuleSystem, entity : Entity) in self.onPlayerAction() }
        
        battleTurnRuleSystem.addRule(CharacterTurnRule(turnValue: 0, entity: self.player, actionFunction: playerTurnAction))
        
        var counter : UInt = 1
        for guy in battle.badGuys {
            battleTurnRuleSystem.addRule(CharacterTurnRule(turnValue: counter, entity: guy, actionFunction: badGuyTurnAction))
            counter++
        }
        
        self.characterTurnCounter = 0
        evaluateTurnOrder()
    }
    
    override func willMoveFromView(view: SKView) {
        battleView.willMoveFromView(view)
        battleView.removeFromParent()
        battle.notifier.removeListener(named: BATTLE_LISTENER_KEY)
        battle = nil
    }

    // MARK: Battle Behavior Methods
    func evaluateTurnOrder() {
        battleTurnRuleSystem.assertFact(NSNumber(unsignedInteger: self.characterTurnCounter))
        battleTurnRuleSystem.evaluate()
        battleTurnRuleSystem.reset()
        
        let numFighters : UInt = 1 + UInt(battle.badGuys.count)
        self.characterTurnCounter = (characterTurnCounter + 1) % numFighters
    }
    
    // MARK: Battle model event listeners
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
    
    // MARK: UI Action Completion Listener
    func onActionAnimationFinished() {
        let allDead = battle.badGuys.reduce(true) { (allDead : Bool, entity : Entity) in
            return allDead && entity.characterComponent!.isDead
        }
        
        let playerDead = player.characterComponent!.isDead
        
        if allDead || playerDead {
            self.battle.notifier.notify({ listener in listener.onBattleEnded() })
            return
        }
        
        evaluateTurnOrder()
    }
    
    // MARK: Entity Action Methods.
    // battleTurnRuleSystem.evaluate() CANNOT be called by these methods
    func onBadGuyAction(guy : Entity) {
        if guy.characterComponent!.isDead {
            runAction(SKAction.runBlock { self.onActionAnimationFinished() })
            return
        }
        
        let badSkill = Skill(character: guy.characterComponent!, targetFilterCreator: skillTargetNone)
        badSkill.setTarget([], primary: player)
        
        badSkill.perform(self)
        onActionPerformed()
    }
    
    func onPlayerAction() {
        battleView.touchEnabled = true
        playerInteractionRuleSystem.reset()
        
        if let _ = battle.currentSkill { playerInteractionRuleSystem.assertFact(String(BattleFlowFacts.SkillSelected)) }
    }
    
    
    // MARK: BattleUI Button Listeners
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
        playerInteractionRuleSystem.evaluate()
    }
    
    func onTargetTouched(target: Entity) -> Void {
        battleCommandController.runSingleCommand(TargetSelectedCommand(ref: self, target: target))
        playerInteractionRuleSystem.evaluate()
    }
}
