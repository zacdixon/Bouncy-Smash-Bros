//
//  EndGameScene.swift
//  Bouncy Smash Bros
//
//  Created by Zachary Dixon on 9/18/15.
//  Copyright © 2015 Zac Dixon. All rights reserved.
//

import SpriteKit
import GameKit
import Parse

class EndGameScene: SKScene {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        
        let titleSize = 30 as CGFloat
        let subTitleSize = 20 as CGFloat
        let bodyTextSize = 15 as CGFloat
        
        let gridSize = 10 as CGFloat
        let containerSize = CGSize.init(width: 2*frame.width/3, height: 240)
        let scoreContainer = SKSpriteNode.init(color: SKColor(white: 1.0, alpha: 0.1), size:containerSize)
        scoreContainer.position = CGPoint(x: frame.width/2, y: frame.height/2)
        addChild(scoreContainer)
        
        
        // Stars
        let star = SKSpriteNode(imageNamed: "Enemy Regular")
        star.position = CGPoint(x: 25, y: self.size.height-30)
        addChild(star)
        
        let lblEnemies = SKLabelNode(fontNamed: ".SFUIText-Light")
        lblEnemies.fontSize = subTitleSize
        lblEnemies.fontColor = SKColor.whiteColor()
        lblEnemies.position = CGPoint(x: 50, y: self.size.height-40)
        lblEnemies.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        lblEnemies.text = String(format: "X %d", GameState.sharedInstance.enemies)
        scoreContainer.addChild(lblEnemies)
        
        // Score
        let lblScore = SKLabelNode(fontNamed: ".SFUIText-Bold")
        lblScore.fontSize = titleSize
        lblScore.fontColor = SKColor.whiteColor()
        lblScore.position = CGPoint(x: 0, y: containerSize.height/2 - titleSize - gridSize)
        lblScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        lblScore.text = String(format: "%d", GameState.sharedInstance.score)
        scoreContainer.addChild(lblScore)
        
        // High Score
        let lblHighScore = SKLabelNode(fontNamed: ".SFUIText-Light")
        lblHighScore.fontSize = subTitleSize
        lblHighScore.fontColor = SKColor.cyanColor()
        lblHighScore.position = CGPoint(x: 0, y: lblScore.position.y - subTitleSize - gridSize)
        lblHighScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        lblHighScore.text = String(format: "High Score: %d", GameState.sharedInstance.highScore)
        scoreContainer.addChild(lblHighScore)
        
        // Try again
        let lblTryAgain = SKLabelNode(fontNamed: ".SFUIText-Light")
        lblTryAgain.fontSize = subTitleSize
        lblTryAgain.fontColor = SKColor.whiteColor()
        lblTryAgain.position = CGPoint(x: frame.width - gridSize*2, y: gridSize*2)
        lblTryAgain.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        lblTryAgain.text = "Retry"
        addChild(lblTryAgain)
        
        let lblBack = SKLabelNode(fontNamed: ".SFUIText-Light")
        lblBack.fontSize = subTitleSize
        lblBack.fontColor = SKColor.whiteColor()
        lblBack.position = CGPoint(x: gridSize*2, y: gridSize*2)
        lblBack.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        lblBack.text = "Back to Menu"
        addChild(lblBack)
        
        //send high score to leaderboard
        func saveHighscore(score:Int) {
            
            //check if user is signed in
            if GKLocalPlayer.localPlayer().authenticated {
                
                let scoreReporter = GKScore(leaderboardIdentifier: "survival01") //leaderboard id here
                
                scoreReporter.value = Int64(score) //score variable here (same as above)
                
                let scoreArray: [GKScore] = [scoreReporter]
                
                GKScore.reportScores(scoreArray, withCompletionHandler: {(error : NSError?) -> Void in
                    if error != nil {
                        print("Game Center score report error")
                    } else {
                        print("Game Center score report success")
                    }
                })
                
            }
            
        }
        
        saveHighscore(GameState.sharedInstance.score)
        
        
        
        // Parse
        if let currentUser = PFUser.currentUser() {
            let score = GameState.sharedInstance.score
            if currentUser["highScore"] == nil {
                currentUser["highScore"] = GameState.sharedInstance.score
                currentUser.saveInBackground()
                print("No score in Parse, so current score has been saved")
            } else {
                if score > currentUser["highScore"] as! Int {
                    currentUser["highScore"] = GameState.sharedInstance.score
                    currentUser.saveInBackground()
                    print("Score saved to Parse")
                    
                } else {
                    print("Score is not higher than what is already on Parse, so nothing was done")
                }
            }
            
            
            let fbFriends = currentUser["facebookFriends"] as! NSArray
            
            for var indexFriend = 0; indexFriend < fbFriends.count; ++indexFriend {
                
                let fbFriend = fbFriends[indexFriend] as! NSDictionary
                let friendID = fbFriend["id"]
                
                let query : PFQuery = PFUser.query()!
                query.whereKey("fbID", equalTo: friendID!)
                query.findObjectsInBackgroundWithBlock({(NSArray objects, NSError error) in
                    if (error != nil) {
                        
                        NSLog("error on getting highscores " + error!.localizedDescription)
                        
                    } else {
                        
                        if objects!.count > 0 {
                            let object = objects![0]
                            let highScore = object["highScore"]
                            let name = object["name"]
                            print(indexFriend)
                            
                            let lblHighScore = SKLabelNode(fontNamed: ".SFUIText-Light")
                            lblHighScore.fontSize = subTitleSize
                            lblHighScore.fontColor = SKColor.cyanColor()
                            lblHighScore.position = CGPoint(x: CGFloat(Int(gridSize) * indexFriend * -10), y: lblScore.position.y - subTitleSize * 2 - gridSize * 10)
                            lblHighScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
                            lblHighScore.text = "\(highScore)"
                            lblHighScore.name = "score\(indexFriend)"
                            scoreContainer.addChild(lblHighScore)
                            
                            let lblName = SKLabelNode(fontNamed: ".SFUIText-Light")
                            lblName.fontSize = subTitleSize
                            lblName.fontColor = SKColor.cyanColor()
                            lblName.position = CGPoint(x: CGFloat(Int(gridSize) * indexFriend * -10), y: lblScore.position.y - subTitleSize * 2 - gridSize * 2)
                            lblName.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
                            lblName.text = "\(name)"
                            lblName.name = "name\(indexFriend)"
                            scoreContainer.addChild(lblName)
                            
                        }
                    }
                })
                
            }
            
            
        } else {
            print("No user logged in, so nothing was saved")
        }

        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Transition back to the Game
        let reveal = SKTransition.fadeWithDuration(0.5)
        let gameScene = GameScene(size: self.size)
        self.view!.presentScene(gameScene, transition: reveal)
    }
}
