//
//  Campaign.swift
//  Bouncy Smash Bros
//
//  Created by Zachary Dixon on 10/8/15.
//  Copyright © 2015 Zac Dixon. All rights reserved.
//

import SpriteKit

class Campaign: SKScene {
    var touchedNode = SKNode()
    let backButton = SKNode()
    let levelButton = SKNode()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        
        
        // Back Button
        backButton.position = CGPoint(x: 20, y: 20)
        let backText = SKLabelNode(fontNamed: ".SFUIText-Medium")
        backText.fontSize = 20
        backText.fontColor = SKColor.whiteColor()
        backText.position = CGPoint(x: 0, y: 0)
        backText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        backText.text = String("Back")
        
        let backRect = CGSize.init(width: backText.frame.width + 120, height: backText.frame.height + backText.frame.height)
        
        let backBox = SKSpriteNode.init(color: SKColor(white: 1.0, alpha: 0.1), size: backRect)
        //box.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backBox.position = CGPoint(x: 0.0, y: 8)
        
        backButton.addChild(backText)
        backButton.addChild(backBox)
        addChild(backButton)
        
        
        // Level Button
        levelButton.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        let levelText = SKLabelNode(fontNamed: ".SFUIText-Medium")
        levelText.fontSize = 30
        levelText.fontColor = SKColor.whiteColor()
        levelText.position = CGPoint(x: 0, y: 0)
        levelText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        levelText.text = String("1")
        
        let circle = CGSize.init(width: levelText.frame.width + 30, height: levelText.frame.height + levelText.frame.height)
        
        let levelCircle = SKSpriteNode.init(color: SKColor(white: 1.0, alpha: 0.1), size: circle)
        //box.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        levelCircle.position = CGPoint(x: 0.0, y: 8)
        
        levelButton.addChild(levelText)
        levelButton.addChild(levelCircle)
        addChild(levelButton)
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Transition back to the Game
        let touch = touches.first! as UITouch
        let position = touch.locationInNode(self)
        touchedNode = self.nodeAtPoint(position)
        if touchedNode.parent == backButton || touchedNode.parent == levelButton {
            let shrink = SKAction.scaleTo(0.75, duration: 0.05)
            touchedNode.parent!.runAction(shrink)
        }
        
        //let reveal = SKTransition.moveInWithDirection(SKTransitionDirection.Right, duration: 0.5)
        //let gameScene = GameScene(size: self.size)
        //self.view!.presentScene(gameScene, transition: reveal)
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Transition back to the Game
        
        if touchedNode.parent == backButton {
            let grow = SKAction.scaleTo(1, duration: 0.2)
            touchedNode.parent!.runAction(grow)
            //let gameScene = MainMenu(size: self.size)
            //self.view!.presentScene(gameScene, transition: reveal)
        } else if touchedNode.parent == levelButton {
            let grow = SKAction.scaleTo(1, duration: 0.2)
            touchedNode.parent!.runAction(grow)
            let reveal = SKTransition.moveInWithDirection(SKTransitionDirection.Left, duration: 0.2)
            let gameScene = GameScene(size: self.size)
            self.view!.presentScene(gameScene, transition: reveal)
        }
        
    }
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        // Transition back to the Game
        
        if touchedNode.parent == backButton || touchedNode.parent == levelButton {
            let grow = SKAction.scaleTo(1, duration: 0.2)
            touchedNode.parent!.runAction(grow)
        }
        //let reveal = SKTransition.moveInWithDirection(SKTransitionDirection.Right, duration: 0.5)
        //let gameScene = GameScene(size: self.size)
        //self.view!.presentScene(gameScene, transition: reveal)
    }
}
