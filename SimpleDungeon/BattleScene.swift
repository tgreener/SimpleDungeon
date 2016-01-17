//
//  BattleScene.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 8/7/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import SpriteKit
import GameKit

let BATTLE_LISTENER_KEY = "BATTLE_LISTENER_KEY"

enum PlayerBattleFlowFacts : String {
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

        player.characterComponent?.skills.forEach { skill in skill.updateTargetFilter(battle) }
        let playerSkills : [SkillUIInfo] = player.characterComponent!.skills.map { skill in return skill as SkillUIInfo }
        
        battleView = BattleUI(viewSize: self.viewSize,
            playerGraphic  : player.graphicComponent!.battleGraphic!,
            badGuyGraphics : badGuyGraphics,
            delegate       : self,
            playerSkills   : playerSkills
        );
        
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
    
    func onBattleEnded() {
        player.characterComponent!.health.increase(100)
        sceneController?.gotoExploreScene()
    }
    
    func onActionPerformed() {
        player.graphicComponent?.battleGraphic?.doBattleAnimation()
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
        
        let skillBuilder = SkillBuilder()
        let badSkill = try! skillBuilder
            .set("Bad Guy Skill")
            .set(guy.characterComponent!)
            .set(CharacterDescriptionVector.normStr)
            .set(skillTargetNone)
            .build()
        badSkill.setTarget([], primary: player)
        
        badSkill.perform()
        guy.graphicComponent?.battleGraphic?.doBattleAnimation()
    }
    
    func onPlayerAction() {
        battleView.beginPlayerTurn()
        playerInteractionRuleSystem.reset()
        
        if let _ = battle.currentSkill { playerInteractionRuleSystem.assertFact(String(PlayerBattleFlowFacts.SkillSelected)) }
    }
    
    
    // MARK: BattleUI Button Listeners
    func onSkillButtonTouched(skillIndex: Int) {
        guard let skill = player.characterComponent?.skills[skillIndex] else { return }
        
        battleCommandController.runSingleCommand(ActionSelectedCommand(ref: self, skill: skill))
        playerInteractionRuleSystem.evaluate()
    }
    
    func onTargetTouched(target: Entity) -> Void {
        battleCommandController.runSingleCommand(TargetSelectedCommand(ref: self, target: target))
        playerInteractionRuleSystem.evaluate()
    }
}
