//
//  MainMenu.swift
//  Bouncy Smash Bros
//
//  Created by Zachary Dixon on 10/7/15.
//  Copyright © 2015 Zac Dixon. All rights reserved.
//

import SpriteKit
import GameKit
import Parse
import FBSDKCoreKit
import ParseFacebookUtilsV4

import UIKit
import SpriteKit


class MainMenu: SKScene {
    var touchedNode = SKNode()
    let lblCampaign = SKNode()
    let lblSurvival = SKNode()
    let lblSettings = SKNode()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
                
        
        //let skView = view as! SKView
        //skView.multipleTouchEnabled = false
        
        func authenticateLocalPlayer(){
            
            let localPlayer = GKLocalPlayer.localPlayer()
            
            localPlayer.authenticateHandler = {(viewController, error) -> Void in
                
                if (viewController != nil) {
                    
                }
                    
                else {
                    print((GKLocalPlayer.localPlayer().authenticated))
                }
            }
        }
        authenticateLocalPlayer()
        
        
        
        let lblBouncySmash = SKLabelNode(fontNamed: ".SFUIText-Bold")
        lblBouncySmash.fontSize = 50
        lblBouncySmash.fontColor = SKColor.whiteColor()
        lblBouncySmash.position = CGPoint(x: self.size.width/2, y: self.size.height-80)
        lblBouncySmash.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        lblBouncySmash.text = String("Bouncy Smash")
        addChild(lblBouncySmash)
        
        
        // Survival
        lblSurvival.position = CGPoint(x: self.size.width / 2, y: self.size.height-160)
        let survivalText = SKLabelNode(fontNamed: ".SFUIText-Medium")
        survivalText.fontSize = 20
        survivalText.fontColor = SKColor.whiteColor()
        survivalText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        survivalText.text = String("Play")
        let survivalRect = CGSize.init(width: survivalText.frame.width + 120, height: survivalText.frame.height + survivalText.frame.height)
        
        let survivalBox = SKSpriteNode.init(color: SKColor(white: 1.0, alpha: 0.1), size: survivalRect)
        survivalBox.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        survivalBox.position = CGPoint(x: 0.0, y: 8)
        
        lblSurvival.addChild(survivalText)
        lblSurvival.addChild(survivalBox)
        addChild(lblSurvival)

        
        // Settings
        lblSettings.position = CGPoint(x: self.size.width / 2, y: self.size.height-210)
        let settingsText = SKLabelNode(fontNamed: ".SFUIText-Medium")
        settingsText.fontSize = 20
        settingsText.fontColor = SKColor.whiteColor()
        settingsText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        settingsText.text = String("Settings")
        lblSettings.addChild(settingsText)
        addChild(lblSettings)
    }
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Transition back to the Game
        let touch = touches.first! as UITouch
        let position = touch.locationInNode(self)
        touchedNode = self.nodeAtPoint(position)
        if touchedNode.parent == lblCampaign {
            let shrink = SKAction.scaleTo(0.75, duration: 0.05)
            touchedNode.parent!.runAction(shrink)
        }

    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Transition back to the Game
        let gameScene = GameScene(size: self.size)
        let reveal = SKTransition.moveInWithDirection(SKTransitionDirection.Right, duration: 0.2)
        self.view!.presentScene(gameScene, transition: reveal)
        
        if touchedNode.parent == lblCampaign {
            let grow = SKAction.scaleTo(1, duration: 0.2)
            touchedNode.parent!.runAction(grow)
            /*
            let reveal = SKTransition.moveInWithDirection(SKTransitionDirection.Right, duration: 0.2)
            let gameScene = Campaign(size: self.size)
            self.view!.presentScene(gameScene, transition: reveal)
            */
            let gameScene = GameScene(size: self.size)
            let reveal = SKTransition.moveInWithDirection(SKTransitionDirection.Right, duration: 0.2)
            self.view!.presentScene(gameScene, transition: reveal)
        } else if touchedNode.parent == lblSurvival {
            let grow = SKAction.scaleTo(1, duration: 0.2)
            touchedNode.parent!.runAction(grow)
            
        } else if touchedNode.parent == lblSettings {
            let permissions = ["public_profile", "user_friends", "user_about_me"]
            PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) {
                (user: PFUser?, error: NSError?) -> Void in
                if let user = user {
                    if user.isNew {
                        print("User signed up and logged in through Facebook!")
                        self.getFBInfo(self)
                    } else {
                        print("User logged in through Facebook!")
                        self.getFBInfo(self)
                    }
                } else {
                    print("Uh oh. The user cancelled the Facebook login.")
                }
            }
        }
        
    }
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        // Transition back to the Game
        
        if touchedNode.parent == lblCampaign {
            let grow = SKAction.scaleTo(1, duration: 0.2)
            touchedNode.parent!.runAction(grow)
        } else if touchedNode.parent == lblSurvival {
            let grow = SKAction.scaleTo(1, duration: 0.2)
            touchedNode.parent!.runAction(grow)
        }
        //let reveal = SKTransition.moveInWithDirection(SKTransitionDirection.Right, duration: 0.5)
        //let gameScene = GameScene(size: self.size)
        //self.view!.presentScene(gameScene, transition: reveal)
    }
    
    func getFBInfo(sender: AnyObject){
        
        if let currentUser = PFUser.currentUser() {
            
            var fbID = String()
            
            let fbRequestName = FBSDKGraphRequest(graphPath:"/me", parameters: nil);
            fbRequestName.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
                
                if error == nil {
                    
                    let userInformation = result as! NSDictionary
                    print(userInformation)
                    let userName = userInformation["name"]
                    fbID = userInformation["id"] as! NSString as String
                    currentUser["name"] = userName
                    print("Facebook ID: \(fbID)")
                    currentUser["fbID"] = fbID
                    currentUser.saveInBackground()
                    
                    self.getProfilePicture(fbID)
                    
                } else {
                    
                    print("Error Getting Friends \(error)");
                    
                }
            }
            
            let fbRequestFriends = FBSDKGraphRequest(graphPath:"/me/friends", parameters: nil);
            fbRequestFriends.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
                
                if error == nil {
                    
                    //print("Friends are : \(result)")
                    let userInformation = result as! NSDictionary
                    let friendsList = userInformation["data"] as! NSArray
                    currentUser["facebookFriends"] = friendsList
                    currentUser.saveInBackground()
                    
                } else {
                    
                    print("Error Getting Friends \(error)");
                    
                }
            }
            
            
        }
    }
    
    func getProfilePicture(facebookID: String) {
        if let currentUser = PFUser.currentUser() {
            let pictureURL = "https://graph.facebook.com/\(facebookID)/picture?type=small"
            
            let URLRequest = NSURL(string: pictureURL)
            
            let request = NSMutableURLRequest(URL: URLRequest!)
            let session = NSURLSession.sharedSession()
            request.HTTPMethod = "GET"
            
            let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                print("Response: \(response)")
                let picture = PFFile(data: data!)
                currentUser.setObject(picture!, forKey: "profilePicture")
                currentUser.saveInBackground()
            })
            
            task.resume()
        }
    }
    
    
    
}

