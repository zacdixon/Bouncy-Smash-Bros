//
//  Survival.swift
//  Bouncy Smash Bros
//
//  Created by Zachary Dixon on 10/10/15.
//  Copyright © 2015 Zac Dixon. All rights reserved.
//

import SpriteKit
import Parse
import UIKit


class ViewController: UIViewController {
    
    var touchLocation = CGPointZero
    var touchTime: CFTimeInterval = 0
    var touchedNode = SKNode()
    let backButton = SKNode()
    var touchesEnabled = true
    var popUpView = UIView()
    var blackFadeButton = UIButton()
    var levelMenu = UIView()
    
    //let levelButton = SKNode()
    
    let gridSize = 20 as CGFloat
    
    
    
    class levels: SKSpriteNode {
        var levelNumber = Int()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        view?.addSubview(levelMenu)
        let lvlButton = UIView()
        lvlButton.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
        //lvlButton.center = CGPoint(x: frame.size.width / 2, y: 0)
        lvlButton.backgroundColor = UIColor.redColor()
        lvlButton.alpha = 1.0
        //lvlButton.addTarget(self, action: "removeLevelPopUp:", forControlEvents: UIControlEvents.TouchUpInside)
        levelMenu.addSubview(lvlButton)
    }
    /*
    override init(size: CGSize) {
        super.init(size: size)
        
        //scene?.backgroundColor = SKColor.whiteColor()
        
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
        
        let player = createPlayer(CGPoint(x: frame.width/2, y: 40))
        addChild(player)
        
        
        
        for index in 1...4 {
            
            
            let width = (scene!.size.width - gridSize*5) / 4
            let height = 2*scene!.size.height/3
            let positionX = CGFloat(index - 1)*width + CGFloat(index-1)*gridSize + gridSize + width/2
            let positionY = (scene?.frame.height)! / 2 as CGFloat
            let position = CGPoint(x: positionX, y: positionY)
            let levelButtonB = createLevelButton(position, width: width, height: height, levelNumber: index)
            addChild(levelButtonB)
        }
        
        
    }
    */
    func createLevelButton(position: CGPoint, width: CGFloat, height: CGFloat, levelNumber: Int) -> levels {
        
        let rank = GameState.sharedInstance.level
        let levelPlist = NSBundle.mainBundle().pathForResource("Level01", ofType: "plist")
        let levelData = NSDictionary(contentsOfFile: levelPlist!)!
        let levelList = levelData["Levels"] as! NSArray
        let levelInfo = levelList[levelNumber - 1] as! NSDictionary
        let levelTitle = levelInfo["Title"] as! String
        let levelReqNumber = levelInfo["Level"] as! Int
        
        
        
        let levelButton = levels()
        levelButton.position = position
        levelButton.levelNumber = levelNumber
        let levelText = SKLabelNode(fontNamed: ".SFUIText-Medium")
        levelText.fontSize = 15
        levelText.fontColor = SKColor.whiteColor()
        levelText.position = CGPoint(x: 0, y: width / 2 + 20)
        levelText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        levelText.text = String("\(levelTitle)")
        levelText.zPosition = 2
        
        let box = CGSize.init(width: width / 2, height: height)
        
        let hexagonPath = GameState.sharedInstance.createHexagonPath(10)
        let hexagon = SKShapeNode(path: hexagonPath, centered: true)
        hexagon.strokeColor = SKColor.whiteColor()
        hexagon.fillColor = SKColor.whiteColor()
        hexagon.position = CGPoint(x: 0.0, y: 0.0)
        hexagon.zPosition = 2
        
        let levelBox = SKSpriteNode(color: SKColor.grayColor(), size: CGSize(width: width, height: height))
        levelBox.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        levelBox.position = CGPoint(x: 0.0, y: 8)
        
        levelButton.addChild(hexagon)
        levelButton.addChild(levelText)
        levelButton.addChild(levelBox)
        
        if levelReqNumber > rank {
            
            //levelBox.fillColor = SKColor(hue: 0, saturation: 1.0, brightness: 0.5, alpha: 1.0)
            let levelReqText = SKLabelNode(fontNamed: ".SFUIText-Medium")
            levelReqText.fontSize = 15
            levelReqText.fontColor = SKColor.whiteColor()
            levelReqText.position = CGPoint(x: 0, y: -10)
            levelReqText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
            levelReqText.text = String("Rank \(levelReqNumber)")
            
            
            let lockIcon = SKSpriteNode(imageNamed: "Lock Icon")
            lockIcon.position = CGPoint(x: 0, y: 20)
            
            levelButton.addChild(levelReqText)
            levelButton.addChild(lockIcon)
        }
        
        return levelButton

    }
    

    
    /*
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Transition back to the Game
        
        if let touch = touches.first {
            
            let location = touch.locationInNode(self)
            touchLocation = location
            
            touchedNode = self.nodeAtPoint(location)
            
            touchTime = CACurrentMediaTime()
            
        }
        
        
        
        let touch = touches.first! as UITouch
        let position = touch.locationInNode(self)
        touchedNode = self.nodeAtPoint(position)
        if touchedNode.parent == backButton {
            let shrink = SKAction.scaleTo(0.75, duration: 0.05)
            touchedNode.parent!.runAction(shrink)
        }
        
        if let parent = touchedNode.parent as? levels {
            print(parent.levelNumber)
        }
        parent
        //let reveal = SKTransition.moveInWithDirection(SKTransitionDirection.Right, duration: 0.5)
        //let gameScene = GameScene(size: self.size)
        //self.view!.presentScene(gameScene, transition: reveal)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Transition back to the Game
        if touchesEnabled == true {
            if touchedNode.parent == backButton {
                let grow = SKAction.scaleTo(1, duration: 0.2)
                touchedNode.parent!.runAction(grow)
                let reveal = SKTransition.moveInWithDirection(SKTransitionDirection.Left, duration: 0.2)
                let gameScene = MainMenu(size: self.size)
                self.view!.presentScene(gameScene, transition: reveal)
            }
            
            if let parent = touchedNode.parent as? levels {
                print(parent.levelNumber)
                let grow = SKAction.scaleTo(1, duration: 0.2)
                touchedNode.parent!.runAction(grow)
                
                
                //self.view!.presentScene(gameScene, transition: reveal)
                levelPopUp(parent.levelNumber)
            }
        }
        
        

        
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        // Transition back to the Game
        
        if touchedNode.parent == backButton {
            let grow = SKAction.scaleTo(1, duration: 0.2)
            touchedNode.parent!.runAction(grow)
        }
        
        if let parent = touchedNode.parent as? levels {
            let grow = SKAction.scaleTo(1, duration: 0.2)
            parent.runAction(grow)
        }

    }
    
    */
    
    func createPlayer(position: CGPoint) -> SKNode {
        
        let playerNode = SKSpriteNode(imageNamed: "Player Red Circle")
        playerNode.position = position
        playerNode.zPosition = 1
        
        
        playerNode.name = "player"
        // 1
        playerNode.physicsBody = SKPhysicsBody(circleOfRadius: playerNode.size.width / 2)
        // 2
        playerNode.physicsBody?.dynamic = false
        // 3
        playerNode.physicsBody?.allowsRotation = false
        // 4
        playerNode.physicsBody?.restitution = 1.0
        playerNode.physicsBody?.friction = 0.0
        playerNode.physicsBody?.angularDamping = 0.0
        playerNode.physicsBody?.linearDamping = 0.1
        playerNode.physicsBody?.affectedByGravity = false
        
        
        //Add Eyes
        let playerEyes = SKSpriteNode(imageNamed: "Player Eyes")
        let blinkClose = SKAction.scaleYTo(0, duration: 0.1)
        let blinkOpen = SKAction.scaleYTo(1.0, duration: 0.1)
        let blinkWait = SKAction.waitForDuration(3.0, withRange: 2.5)
        playerEyes.runAction(SKAction.repeatActionForever(SKAction.sequence([blinkClose, blinkOpen, blinkWait])))
        playerEyes.position = CGPoint(x: 0, y: 0)
        playerEyes.zPosition = 1.1
        playerEyes.name = "eyes"
        
        playerNode.addChild(playerEyes)
        
        let playerPupils = SKSpriteNode(imageNamed: "Player Pupils")
        playerPupils.position = CGPoint(x: 0, y: 0)
        playerPupils.zPosition = 1.2
        playerPupils.name = "pupils"
        
        playerNode.addChild(playerPupils)
        
        let playerMouth = SKSpriteNode(imageNamed: "Player Mouth")
        playerMouth.position = CGPoint(x: 0, y: -7)
        playerMouth.zPosition = 1.1
        playerMouth.name = "mouth"
        playerEyes.addChild(playerMouth)
        
        
        let playerMaskImage = SKSpriteNode(imageNamed: "Player Red Circle")
        playerMaskImage.position = CGPoint(x: 0, y: 0)
        let playerCrop = SKCropNode()
        playerCrop.maskNode = playerMaskImage
        let playerBottom = SKSpriteNode(imageNamed: "Player Red Bottom")
        playerBottom.position = CGPoint(x: 0, y: -18)
        playerBottom.name = "bottom"
        let playerHair = SKSpriteNode(imageNamed: "Player Red Hair")
        playerHair.name = "hair"
        playerHair.position = CGPoint(x: 0, y: 10)
        playerCrop.zPosition = 1.4
        playerCrop.name = "crop"
        playerCrop.addChild(playerHair)
        playerCrop.addChild(playerBottom)
        playerNode.addChild(playerCrop)
        
        return playerNode
    }
    /*
    func levelPopUp(levelNumber: Int) {
        
        let popUpWidth = frame.width / 2
        let popUpHeight = frame.height - frame.height / 4
        //let popUpView = UIView()
        
        let levelPlist = NSBundle.mainBundle().pathForResource("Level01", ofType: "plist")
        let levelData = NSDictionary(contentsOfFile: levelPlist!)!
        let levelList = levelData["Levels"] as! NSArray
        let levelInfo = levelList[levelNumber - 1] as! NSDictionary
        let levelTitle = levelInfo["Title"] as! String
        let levelNumber = levelInfo["Level"] as! Int
        
        blackFadeButton = UIButton(type: UIButtonType.System) as UIButton
        blackFadeButton.frame = CGRectMake(0, 0, frame.size.width, frame.size.height)
        blackFadeButton.backgroundColor = UIColor.blackColor()
        blackFadeButton.alpha = 0.75
        blackFadeButton.addTarget(self, action: "removeLevelPopUp:", forControlEvents: UIControlEvents.TouchUpInside)
        view?.addSubview(blackFadeButton)
        
        popUpView.frame = CGRect(origin: CGPointZero, size: CGSize(width: popUpWidth, height: popUpHeight))
        popUpView.backgroundColor = UIColor.whiteColor()
        popUpView.center = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        view?.addSubview(popUpView)
        
        
        let lblLevelTitle = UILabel(frame: CGRectMake(0, 0, popUpWidth, 20))
        lblLevelTitle.font = UIFont(name: ".SFUIText-Medium", size: 20)
        lblLevelTitle.textColor = UIColor.blackColor()
        lblLevelTitle.center = CGPoint(x: popUpWidth / 2, y: popUpHeight / 10)
        lblLevelTitle.textAlignment = NSTextAlignment.Center
        lblLevelTitle.text = "\(levelTitle)"
        popUpView.addSubview(lblLevelTitle)
        
        let scoreBoard = createScoreBoard(popUpWidth, frameHeight: popUpHeight / 3)
        scoreBoard.center = CGPoint(x: popUpWidth / 2, y: popUpHeight - popUpHeight / 2)
        popUpView.addSubview(scoreBoard)
        
        let smashButton = UIButton(type: UIButtonType.System) as UIButton
        smashButton.frame = CGRectMake(0, popUpHeight * 0.75, popUpWidth, popUpHeight / 4)
        smashButton.backgroundColor = UIColor.blueColor()
        smashButton.setTitle("Smash!", forState: UIControlState.Normal)
        smashButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        smashButton.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        popUpView.addSubview(smashButton)
        

        
        
    }
    */
    func removeLevelPopUp(sender:UIButton!) {
        for view in popUpView.subviews {
            view.removeFromSuperview()
        }
        popUpView.removeFromSuperview()
        blackFadeButton.removeFromSuperview()
        
    }
    /*
    func buttonAction(sender:UIButton!)
        
    {
        for view in popUpView.subviews {
            view.removeFromSuperview()
        }
        popUpView.removeFromSuperview()
        blackFadeButton.removeFromSuperview()
    
        let gameScene = GameScene(size: self.size)
        let reveal = SKTransition.moveInWithDirection(SKTransitionDirection.Right, duration: 0.2)
        self.view!.presentScene(gameScene, transition: reveal)
    }
    
    
    func createScoreBoard(frameWidth: CGFloat, frameHeight: CGFloat) -> UIScrollView {
        var scoreBoardView = UIView()
        var scrollView = UIScrollView()
        scoreBoardView = UIView()
        scoreBoardView.backgroundColor = UIColor.clearColor()
        
        if let currentUser = PFUser.currentUser() {

            let score = GameState.sharedInstance.score
            
            let leaderDict = NSArray()
            
            let fbFriends = currentUser["facebookFriends"] as! NSArray
            
            scoreBoardView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: frameWidth / 3 * (CGFloat(fbFriends.count)), height: frameHeight))
            
            scoreBoardView.alpha = 1.0
            
            //scrollView = UIScrollView()
            //self.scrollView.pagingEnabled = true
            scrollView.contentSize = CGSizeMake(frameWidth / 3 * (CGFloat(fbFriends.count)), frameHeight)
            scrollView.frame = CGRect(origin: CGPoint(x: frame.width / 4, y: frame.height / 4), size: CGSize(width: frameWidth, height: frameHeight))
            scrollView.backgroundColor = UIColor.clearColor()
            scrollView.alpha = 1.0
            scrollView.addSubview(scoreBoardView)
            
            for var indexFriend = 0; indexFriend < fbFriends.count; ++indexFriend {
                let titleSize = 14 as CGFloat
                let subTitleSize = 10 as CGFloat
                
                let xPosition = CGFloat(indexFriend) * frameWidth / 3 + frameWidth / 6 as CGFloat
                
                let lblHighScore = UILabel(frame: CGRectMake(0, 0, 100, 20))
                lblHighScore.font = UIFont(name: ".SFUIText-Medium", size: titleSize)
                lblHighScore.textColor = UIColor.blackColor()
                lblHighScore.center = CGPointMake(xPosition, frameHeight - titleSize / 2 - 2.5 * frameHeight / 10)
                lblHighScore.textAlignment = NSTextAlignment.Center
                lblHighScore.text = ""
                scoreBoardView.addSubview(lblHighScore)
                
                let lblName = UILabel(frame: CGRectMake(0, 0, 100, 20))
                lblName.font = UIFont(name: ".SFUIText-Light", size: subTitleSize)
                lblName.textColor = UIColor.grayColor()
                lblName.center = CGPointMake(xPosition, frameHeight - subTitleSize / 2 - frameHeight / 10)
                lblName.textAlignment = NSTextAlignment.Center
                lblName.text = ""
                scoreBoardView.addSubview(lblName)
                
                let imageSize = frameHeight / 2
                let image = getStockProfileImage(CGSize(width: imageSize, height: imageSize))
                var imageView = UIImageView(image: image)
                
                
                imageView.frame = CGRect(x: 0, y: 0, width: imageSize, height: imageSize)
                imageView.center = CGPointMake(xPosition, imageSize / 2 + frameHeight / 10)
                
                scoreBoardView.addSubview(imageView)
                
                let hexagonPath = GameState.sharedInstance.createHexagonPath(imageSize/2)
                
                let maskLayer = CAShapeLayer()
                maskLayer.path = hexagonPath
                maskLayer.position = CGPoint(x: imageSize/2, y: imageSize/2)
                imageView.layer.mask = maskLayer
                
                let fbFriend = fbFriends[indexFriend] as! NSDictionary
                let friendID = fbFriend["id"]
                
                var highScore = 0 as Int
                var name = ""
                
                
                let query : PFQuery = PFUser.query()!
                query.whereKey("fbID", equalTo: friendID!)
                query.cachePolicy = .CacheElseNetwork
                query.findObjectsInBackgroundWithBlock({(NSArray objects, NSError error) in
                    if (error != nil) {
                        
                        NSLog("error on getting highscores " + error!.localizedDescription)
                        
                    } else {
                        
                        if objects!.count > 0 {
                            let object = objects![0]
                            if object["highScore"] != nil {
                                highScore = object["highScore"] as! Int
                                lblHighScore.text = "\(highScore)"
                            }
                            
                            if object["name"] != nil {
                                let nameString = object["name"] as! String
                                let myArray : [String] = nameString.componentsSeparatedByString(" ")
                                name = myArray[0]
                                lblName.text = "\(name)"
                            }
                            
                            
                            if let userImageFile = object["profilePicture"] as? PFFile {
                                userImageFile.getDataInBackgroundWithBlock {
                                    (imageData: NSData?, error: NSError?) -> Void in
                                    if error == nil {
                                        if let imageData = imageData {
                                            let image = UIImage(data:imageData)
                                            imageView.image = image
                                            
                                        }
                                    }
                                }
                            }
                            
                            
                        }
                    }
                })
                
                
                
            }
            
            
        } else {
            print("No user logged in, so nothing was saved")
        }
        return scrollView
    }
    */
    func getStockProfileImage(size: CGSize) -> UIImage {
        let color = UIColor.redColor()
        
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

}
