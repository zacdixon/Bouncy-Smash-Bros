//
//  GameScene.swift
//  Bouncy Smash Bros
//
//  Created by Zachary Dixon on 9/12/15.
//  Copyright (c) 2015 Zac Dixon. All rights reserved.
//

import SpriteKit
import CoreMotion
import Foundation
import GameKit
import UIKit
import GameController

let MaxPlayerAcceleration: CGFloat = 800
let MaxPlayerSpeed: CGFloat = 200

// collision Types
enum BodyType:UInt32 {
    
    case player1 = 1
    case ground = 2
    case enemy1 = 4
    case platforms = 8
    case gravity = 16
    case nogravity = 32
    case projectiles = 64
    case bonuses = 128
    case platformActivate = 256
    case playerEdge = 512
    
}



class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    
    
    // Layered Nodes
    var effectsNode: SKEffectNode!
    var scaleNode: SKNode!
    var backgroundNode: SKNode!
    var midgroundNode: SKNode!
    var midgroundTwoNode: SKNode!
    var midgroundThreeNode: SKNode!
    var foregroundNode: SKNode!
    var foregroundTwoNode: SKNode!
    var hudNode: SKNode!
    
    var hudView = UIView()
    var gameOverView = UIView()
    var bonusChooseView = UIView()
    var lblCoins = SKLabelNode()
    var specialProgressBar = SKSpriteNode()
    var specialButton = SKSpriteNode()
    var specialQueue: Array<String> = []
    var pauseMenu = UIView()
    var randomNumber = Int()
    var achievementNotificationQueue: NSMutableArray = []
    
    var scaleFactor: CGFloat!
    
    // Enemy
    var enemyNumber = 1 as Int
    var enemySpawnPoints = [NSMutableDictionary]()
    var enemyCountRound = 0 as Int
    
    // Bonus
    var bonus: SKNode!
    var bonusNumber = 1 as Int
    
    
    //Coins
    var coinNumber = 1 as Int
    var coin : SKSpriteNode!
    var coinAnimationFrames : [SKTexture]!
    
    // Ground
    var ground: SKNode!
    
    // Player 1 Score Variables
    var scoreMultiplier = 1 as Int
    var bonusMultiplier = 1 as Double
    var scoreRunning = 0 as Int
    var playerOneScore = 0 as Int
    
    //Player Variables
    var player: SKSpriteNode!
    var playerOneHealth = 0 as Int
    var playerOneHealthArray: Array<UIView> = []
    var playerOneSpecial = 0 as Int
    var playerOneSpecialActivated = false
    var playerOneInvincible = false
    var playerOneInstaKill = false
    var playerOneSpecialDuration = 8.0 as Double
    var playerOneJump = true
    
    var skipFrames = 0
    
    // Achievement Variables
    var achievLevel = 0
    var achievObjectives = [NSDictionary()]
    
    
    var achievReachRound = 0
    var achievScoreTotal = 0
    var achievScoreRound = 0
    var achievSpecialActivations = 0
    var achievSpecialKills = 0
    var achievComboScore = 0
    var achievComboMultiplier = 0
    var achievComboUnique = 0
    var achievBounceTotal = 0
    var achievKillsTotal = 0
    var achievKillsType = 0
    var achievKillsRound = 0
    var achievEnemyJumpOver = 0
    var achievEnemyJumpUnder = 0
    var achievPerfectRound = 0
    var achievAllEnemiesCleared = 0
    var achievTimePassed = 0.00
    var achievAirTime = 0.00
    var achievBonusTokens = 0
    var achievCoins = 0
    
    var achievPopUp = false
    
    // Motion manager for accelerometer
    let motionManager = CMMotionManager()
    
    var playerOneEnemyPass = [""]
    
    // Game start time
    
    let gameStartTime = CACurrentMediaTime()
    
    // Level Type
    
    var levelType = String()
    
    // Survival
    var survivalRound = 0
    var survivalRoundOver = false
    var survivalRoundScore = 0
    var survivalRoundMultiplier = 1.1
    var survivalRoundEnemyTypes = [Int]()
    var survivalRoundHealthBonus = true
    var survivalRoundBonusTypes = [Int]()
    var bonusSpawned = false
    var bonusGained = false
    
    // Character Attributes
    
    var attributeBounce: CGFloat = CGFloat()
    var attributeJump: CGFloat = CGFloat()
    var attributeHealth: Int = Int()
    var attributeSpeed: CGFloat = CGFloat()
    
    // Skills
    
    var skillDamageBubble: Int! = Int()
    var skillSpecialType: String = String()
    var skillSpecialDuration: CGFloat = CGFloat()
    var skillSpecialActivation: Int = Int()
    
    // Game over
    var gameOver = false
    
    var atlasArray = [SKTexture]()
    
    var passThroughPlatforms = false
    
    var touchedNode = SKNode()
    
    var accelerometerX: UIAccelerationValue = 0
    
    //let motionManager = CMMotionManager()
    var playerAcceleration = CGVector(dx: 0, dy: 0)
    var playerVelocity = CGVector(dx: 0, dy: 0)
    var lastUpdateTime: CFTimeInterval = 0
    
    
    // Hud Variables
    
    var kHealthHudName = "healthHud"
    var kHealthBarName = "healthBar"
    var kScoreHudName = "scoreHud"
    var kEnemyName = "enemy"
    
    
    // Flick Touch Variables
    
    var touchLocation = CGPointZero
    var touchTime: CFTimeInterval = 0
    var physicsStartTime = NSTimeInterval()
    var elapsedTime = NSTimeInterval()
    var flickActivated = false
    var flickVelocity = CGVector(dx: 0, dy: 0)
    
    // Acceleration Variables
    var accelerationPlayerOne = 1.0
    var accelerationNaturalPlayerOne = 0.0
    
    // Get the Enemy Types
    var enemies = NSDictionary()
    var enemyTypes = [NSDictionary()]
    var enemyTypesArray = [String]()
    
    
    // Get the Bonus Types
    var bonuses = NSDictionary()
    var bonusTypes = [NSDictionary()]
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
        
    }
    
    
    override init(size: CGSize) {
        super.init(size: size)
        
        
        
        
    }
    
    func setSceneValues() {
        
        let levelPlist = NSBundle.mainBundle().pathForResource("GameInfo", ofType: "plist")
        let levelData = NSDictionary(contentsOfFile: levelPlist!)!
        let characterList = levelData["Characters"] as! NSArray
        let characterInfo = characterList[GameState.sharedInstance.characterSelected] as! NSDictionary
        
        // Set attributes
        attributeHealth = characterInfo["Stat Health"] as! Int
        attributeBounce = characterInfo["Stat Bounce"] as! CGFloat
        attributeJump = characterInfo["Stat Jump"] as! CGFloat
        attributeSpeed = characterInfo["Stat Speed"] as! CGFloat
        
        // Set Skills
        skillDamageBubble = 0
        skillSpecialType = ""
        skillSpecialDuration = 0
        skillSpecialActivation = 0
        setupSkills()
        
        print("Health \(attributeHealth), Bounce \(attributeBounce), Jump \(attributeJump), Speed \(attributeSpeed)")
        
        enemyNumber = 1
        
        bonusNumber = 1
        
        coinNumber = 1

        // Player 1 Score Variables
        scoreMultiplier = 1
        bonusMultiplier = 1
        scoreRunning = 0
        playerOneScore = 0
        specialQueue = []
        achievementNotificationQueue = []
        
        playerOneHealth = attributeHealth
        playerOneHealthArray = []
        playerOneSpecial = 0
        playerOneSpecialActivated = false
        playerOneInvincible = false
        playerOneInstaKill = false
        playerOneSpecialDuration = 8.0
        playerOneJump = true
        
        skipFrames = 0
        
        playerOneEnemyPass = []
        enemyCountRound = 0 as Int
        
        
        survivalRound = 0
        survivalRoundOver = false
        survivalRoundScore = 0
        survivalRoundMultiplier = 1.1
        survivalRoundEnemyTypes = []
        survivalRoundHealthBonus = true
        survivalRoundBonusTypes = []
        bonusSpawned = false
        bonusGained = false
        
        achievReachRound = 0
        achievScoreTotal = 0
        achievScoreRound = 0
        achievSpecialActivations = 0
        achievSpecialKills = 0
        achievComboScore = 0
        achievComboMultiplier = 0
        achievComboUnique = 0
        achievBounceTotal = 0
        achievKillsTotal = 0
        achievKillsType = 0
        achievKillsRound = 0
        achievEnemyJumpOver = 0
        achievEnemyJumpUnder = 0
        achievPerfectRound = 0
        achievAllEnemiesCleared = 0
        achievTimePassed = 0.00
        achievAirTime = 0.00
        achievBonusTokens = 0
        achievCoins = 0
        
        achievPopUp = false
        
        // reset any enemies that may be spawning
        self.removeActionForKey("enemySpawn")
    }
    
    func createSceneContents() {
        
        
        achievLevel = GameState.sharedInstance.level
        GameState.sharedInstance.score = 0
        GameState.sharedInstance.enemies = 0
        gameOver = false
        
        // Background Color
        backgroundColor = SKColor.whiteColor()
        
        // Add Gravity
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -10.0)
        
        scaleFactor = self.size.width / 320.0
        
        //Add CameraScale Node
        scaleNode = SKNode()
        addChild(scaleNode)
        
        
        // Add Background Layers
        backgroundNode = createBackgroundNode()
        midgroundNode = createMidgroundNode()
        midgroundTwoNode = createMidgroundTwoNode()
        midgroundThreeNode = createMidgroundThreeNode()
        foregroundNode = createForegroundNode()
        foregroundTwoNode = createForegroundTwoNode()
        
        scaleNode.addChild(backgroundNode)
        scaleNode.addChild(midgroundThreeNode)
        scaleNode.addChild(midgroundTwoNode)
        scaleNode.addChild(midgroundNode)
        scaleNode.addChild(foregroundNode)
        scaleNode.addChild(foregroundTwoNode)
        
        // Foreground
        //foregroundNode = SKNode()
        
        
        // Add HUD Node
        hudNode = SKNode()
        hudNode.zPosition = 7
        addChild(hudNode)
        
        
        // Get Achievements
        checkAchievement("levelStart", subType: 0, amount: 0)
        
        
        // Load Animations
        
        let coinAnimatedAtlas = SKTextureAtlas(named: "CoinSmall")
        var coinFrames = [SKTexture]()
        
        let numImages = coinAnimatedAtlas.textureNames.count
        for var i=0; i<=numImages/3 - 3; i++ {
            let coinTextureName = "Coin\(i)"
            coinFrames.append(coinAnimatedAtlas.textureNamed(coinTextureName))
        }
        
        coinAnimationFrames = coinFrames
        
        // Add the player
        
        scene?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        
        // Load the level
        
        let levelPlist = NSBundle.mainBundle().pathForResource("GameInfo", ofType: "plist")
        let levelData = NSDictionary(contentsOfFile: levelPlist!)!
        
        if let dictionary = Dictionary<String, AnyObject>.loadJSONFromBundle("Map_Survival_01") {
            let layers = dictionary["layers"]! as! NSArray
            //let layerTiles = layers[0] as! NSDictionary
            let layerMeta = layers[1] as! NSDictionary
            let metaObjects = layerMeta["objects"] as! NSArray
            for metaObject in metaObjects {
                let object = metaObject as! NSDictionary
                let type = object["type"] as! String
                let positionX = object["x"] as! Int
                let positionY = object["y"] as! Int
                let height = object["height"] as! Int
                let width = object["width"] as! Int
                if type == "playerSpawn" {
                    
                    player = self.createPlayer(CGPoint(x: CGFloat(positionX), y: CGFloat(-positionY)))
                    foregroundNode.addChild(player)
                } else if type == "platform" {
                    
                    let platform = createPlatformAtPosition(CGPoint(x: CGFloat(positionX), y: CGFloat(-positionY)), height: height, width: width, ofType: type)
                    foregroundNode.addChild(platform)
                    
                    let platformActivate = createPlatformActivateAtPosition(CGPoint(x: CGFloat(positionX), y: CGFloat(-positionY)), height: height, width: width, ofType: type)
                    foregroundNode.addChild(platformActivate)
                    
                } else if type == "wallBottom" || type == "wallTop" || type == "wallVertical" || type == "wallBooster" || type == "wallAngledLeft" || type == "wallAngledRight" || type == "mapEdge" || type == "spikes" || type == "achievPerfectRound" {
                    let wall = createWall(CGPoint(x: positionX, y: -positionY), height: height, width: width, ofType: type)
                    foregroundNode.addChild(wall)
                    
                } else if type == "playerEdge" {
                    let playerEdge = createPlayerEdgeAtPosition(CGPoint(x: positionX, y: -positionY), height: height, width: width, ofType: type)
                    foregroundNode.addChild(playerEdge)
                    
                } else if type == "enemySpawn" {
                    let spawnProperties = NSMutableDictionary()
                    spawnProperties["positionX"] = positionX as Int
                    spawnProperties["positionY"] = positionY as Int
                    
                    let properties = object["properties"] as! NSDictionary
                    spawnProperties["frequency"] = Int(properties["frequency"] as! String)
                    spawnProperties["velocityX"] = Int(properties["velocityX"] as! String)
                    enemySpawnPoints.append(spawnProperties)
                    
                } else if type == "levelProperties" {
                    let properties = object["properties"] as! NSDictionary
                    let type = properties["type"]
                    levelType = type as! String
                }
                
            }
            
        }
        
        
        
        // Get the Enemy Types
        enemies = levelData["Enemies"] as! NSDictionary
        enemyTypes = enemies["Types"] as! [NSDictionary]
        
        // Get the Bonus Types
        bonuses = levelData["Bonuses"] as! NSDictionary
        bonusTypes = bonuses["Types"] as! [NSDictionary]
        
        // Add the Enemies
        
        //Survival Logic
        
        // Center Scene
        foregroundNode.position = CGPoint(x: -player.position.x, y: -player.position.y + 100)
        midgroundNode.position = CGPoint(x: 0, y: 0)
        
        setupHud()
        achievementOverlay()
        

    }
    
    func setupSkills() {
        
        let levelPlist = NSBundle.mainBundle().pathForResource("GameInfo", ofType: "plist")
        let levelData = NSDictionary(contentsOfFile: levelPlist!)!
        let skillList = levelData["Skills"] as! NSArray
        
        for var index = 0; index < GameState.sharedInstance.activeAbilities.count; ++index {
            
            let skillIndex = GameState.sharedInstance.activeAbilities[index]
            
            if skillIndex == 100 {
                //Ability slot is empty, so do nothing
            } else {
                let skillLevel = GameState.sharedInstance.abilities[skillIndex]
                let skill = skillList[skillIndex] as! NSDictionary
                let skillTitle = skill["Title"] as! String
                let skillType = skill["Type"] as! String
                let skillUpgrades = skill["Upgrades"] as! NSArray
                let skillUpgradeLevel = skillUpgrades[skillLevel] as! NSDictionary
                let skillAttributes = skillUpgradeLevel["Attributes"] as! NSArray
                
                if skillType == "Ability" {
                    
                    skillSpecialType = skillTitle
                    
                    let durationDict = skillAttributes[0] as! NSDictionary
                    let duration = durationDict["Amount"] as! CGFloat
                    let activationDict = skillAttributes[0] as! NSDictionary
                    let activation = activationDict["Amount"] as! Int
                    
                    skillSpecialDuration = duration
                    skillSpecialActivation = activation
                    
                    
                } else if skillType == "Damage Bubble" {
                    
                    let attributeOne = skillAttributes[0] as! NSDictionary
                    skillDamageBubble = attributeOne["Amount"] as! Int
                    print("SkillDamageBubble = \(skillDamageBubble)")
                    
                } else if skillType == "Bounce Boost" {
                    
                    let attributeOne = skillAttributes[0] as! NSDictionary
                    let percentage = attributeOne["Amount"] as! CGFloat
                    attributeBounce = attributeBounce + attributeBounce * percentage / 100
                    print("attributeBounce = \(attributeBounce)")
                }
                
            }
        }
        
    }
    
    func createForegroundNode() -> SKNode {
        // 1
        // Create the node
        let foregroundNode = SKNode()
        var sprite: SKSpriteNode
        sprite = SKSpriteNode(imageNamed: "Level_01_02")
        sprite.position = CGPoint(x: 4200, y: -830)
        sprite.zPosition = 4
        foregroundNode.addChild(sprite)

        let particles = createLightParticles() as SKEmitterNode
        particles.zPosition = 14
        particles.position = CGPoint(x: 4200, y:-810)
        particles.targetNode = foregroundNode

        foregroundNode.addChild(particles)
        
        return foregroundNode
        
    }
    
    func createLightBeams() -> SKNode {
        let lightBeams = SKNode()
        
        for index in 1...40 {
            
            let randNum = CGFloat(arc4random_uniform(UInt32(100)))
            let newWidth = randNum/100 + 0.2 as CGFloat
            
            let lightBeam = SKSpriteNode(color: UIColor(hue: 0.142, saturation: 0.29, brightness: 1.0, alpha: 0.2), size: CGSize(width: 100 * newWidth, height: 5000))
            
            lightBeam.position = CGPoint(x: index * 100 - 2000, y:0)
            lightBeam.zRotation = -0.5
            lightBeam.zPosition = 4
            lightBeam.blendMode = SKBlendMode.Add
            
            
            let createNewWidth = SKAction.runBlock({
                
                let randNum = CGFloat(arc4random_uniform(UInt32(200)))
                let newWidth = randNum/100 + 0.2 as CGFloat
                
                let changeWidth = SKAction.scaleXTo(newWidth, duration: 5.0)
                
                lightBeam.runAction(changeWidth)
            })
            
            let wait = SKAction.waitForDuration(20.0)
            
            
            lightBeams.addChild(lightBeam)
            
            lightBeam.runAction(SKAction.repeatActionForever(SKAction.sequence([createNewWidth, wait])))
        }

        
        return lightBeams
        
    }
    
    func createLightParticles () -> SKEmitterNode  {
        //let path = NSBundle.mainBundle().pathForResource("Forest Lights", ofType: "sks")
        let forestParticle = SKEmitterNode(fileNamed: "ForestLights.sks")
        
        //forestParticle!.position = CGPointMake(4200, -810)
        forestParticle!.name = "ForestLights"
        forestParticle!.zPosition = 7
        forestParticle!.advanceSimulationTime(10)
        
        return forestParticle!
    }
    
    func createLeavesParticles () -> SKEmitterNode {
        //let path = NSBundle.mainBundle().pathForResource("Forest Lights", ofType: "sks")
        
        let forestLeavesParticle = SKEmitterNode(fileNamed: "ForestLeaves.sks")
        forestLeavesParticle!.advanceSimulationTime(10)
        forestLeavesParticle!.name = "ForestLeaves"
        forestLeavesParticle!.zPosition = 7
        
        
        return forestLeavesParticle!
    }
    
    func createBackgroundNode() -> SKNode {
        // 1
        // Create the node
        let backgroundNode = SKNode()
        var sprite: SKSpriteNode
        sprite = SKSpriteNode(imageNamed: "Level_01_06")
        sprite.position = CGPoint(x: 0, y: 0)
        sprite.zPosition = 0
        backgroundNode.addChild(sprite)
        
        return backgroundNode
    }
    
    func createMidgroundNode() -> SKNode {
        // 1
        // Create the node
        let midgroundNode = SKNode()
        var sprite: SKSpriteNode
        sprite = SKSpriteNode(imageNamed: "Level_01_05")
        sprite.position = CGPoint(x: 0, y: 0)
        sprite.zPosition = 1
        midgroundNode.addChild(sprite)
        return midgroundNode
    }
    
    func createMidgroundTwoNode() -> SKNode {
        // 1
        // Create the node
        let midgroundTwoNode = SKNode()
        var sprite: SKSpriteNode
        sprite = SKSpriteNode(imageNamed: "Level_01_04")
        sprite.position = CGPoint(x: 0, y: 0)
        sprite.zPosition = 2
        midgroundTwoNode.addChild(sprite)
        return midgroundTwoNode
    }
    
    func createMidgroundThreeNode() -> SKNode {
        // 1
        // Create the node
        let midgroundThreeNode = SKNode()
        var sprite: SKSpriteNode
        sprite = SKSpriteNode(imageNamed: "Level_01_03")
        sprite.position = CGPoint(x: 0, y: 0)
        
        sprite.zPosition = 3
        midgroundThreeNode.addChild(sprite)
        
        let leaves = createLeavesParticles() as SKEmitterNode
        leaves.position = CGPoint(x: 0, y: 200)
        leaves.zPosition = 2.9
        leaves.targetNode = midgroundThreeNode
        midgroundThreeNode.addChild(leaves)
        
        return midgroundThreeNode
    }
    
    func createForegroundTwoNode() -> SKNode {
        // 1
        // Create the node
        let foregroundTwoNode = SKNode()
        /*
        var sprite: SKSpriteNode
        let sprite = SKSpriteNode(imageNamed: "Level_01_01") {
        sprite.position = CGPoint(x: 0, y: -12)
        sprite.zPosition = 6

        foregroundTwoNode.addChild(sprite)
        */
        
        return foregroundTwoNode
    }
    
    func createHudNode() -> SKNode {
        let hudNode = SKNode()
        
        return hudNode
    }
    
    func createPlayer(position: CGPoint) -> PlayerNode {
        
        let playerNode = PlayerNode(imageNamed: "Player Red Circle")
        playerNode.position = position
        playerNode.zPosition = 4
        
        
        playerNode.name = "player"
        playerNode.platformActivate = false
        playerNode.platformContact = false
        playerNode.physicsBody?.usesPreciseCollisionDetection = true
        // 1
        playerNode.physicsBody = SKPhysicsBody(circleOfRadius: playerNode.size.width / 2)
        // 2
        playerNode.physicsBody?.dynamic = true
        // 3
        playerNode.physicsBody?.allowsRotation = false
        // 4
        playerNode.physicsBody?.restitution = 1.0
        playerNode.physicsBody?.friction = 0.0
        playerNode.physicsBody?.angularDamping = 0.0
        playerNode.physicsBody?.linearDamping = 0.1
        playerNode.physicsBody?.affectedByGravity = true
        playerNode.physicsBody?.collisionBitMask = BodyType.enemy1.rawValue | BodyType.ground.rawValue | BodyType.playerEdge.rawValue
        // assign collision type
        playerNode.physicsBody?.categoryBitMask = BodyType.player1.rawValue
        playerNode.physicsBody?.fieldBitMask = BodyType.nogravity.rawValue
        // listen for these collisions
        playerNode.physicsBody?.contactTestBitMask = BodyType.ground.rawValue | BodyType.platforms.rawValue | BodyType.platformActivate.rawValue | BodyType.playerEdge.rawValue
        
        
        //Add Eyes
        let playerEyes = SKSpriteNode(imageNamed: "Player Eyes")
        let blinkClose = SKAction.scaleYTo(0, duration: 0.1)
        let blinkOpen = SKAction.scaleYTo(1.0, duration: 0.1)
        let blinkWait = SKAction.waitForDuration(3.0, withRange: 2.5)
        playerEyes.runAction(SKAction.repeatActionForever(SKAction.sequence([blinkClose, blinkOpen, blinkWait])))
        playerEyes.position = CGPoint(x: 0, y: 0)
        playerEyes.zPosition = 4.1
        playerEyes.name = "eyes"
        
        playerNode.addChild(playerEyes)
        
        let playerPupils = SKSpriteNode(imageNamed: "Player Pupils")
        playerPupils.position = CGPoint(x: 0, y: 0)
        playerPupils.zPosition = 4.2
        playerPupils.name = "pupils"
        
        playerNode.addChild(playerPupils)
        
        let playerMouth = SKSpriteNode(imageNamed: "Player Mouth")
        playerMouth.position = CGPoint(x: 0, y: -7)
        playerMouth.zPosition = 4.1
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
        playerCrop.zPosition = 4.3
        playerCrop.name = "crop"
        playerCrop.addChild(playerHair)
        playerCrop.addChild(playerBottom)
        playerNode.addChild(playerCrop)
        

        return playerNode
    }
    
    // Enemy
    
    func addEnemy(position: CGPoint, direction:CGVector, ofType: Int) -> EnemyNode {
        let typeDict = enemyTypes[ofType] as NSDictionary
        let typeName = typeDict["Type"] as! String
        let typeHealth = typeDict["Health"] as! Int
        
        let enemyNode = EnemyNode(imageNamed: "Enemy_\(typeName)_Body")
        
        enemyNode.name = "enemy\(ofType)_\(enemyNumber)"
        
        enemyNumber += 1
        
        
        enemyNode.position = position
        enemyNode.zPosition = 4
        enemyNode.enemyType = ofType
        
        // Set Health
        
        enemyNode.enemyHealth = typeHealth
        
        // Add Eyes and Pupils
        
        let eyes = SKSpriteNode(imageNamed: "Enemy_\(typeName)_Eyes")
        eyes.name = "Eyes"
        eyes.zPosition = 4.1
        
        enemyNode.addChild(eyes)
        
        let pupils = SKSpriteNode(imageNamed: "Enemy_\(typeName)_Pupils")
        //let pupilsTexture = SKTextureAtlas(named: "Enemy").textureNamed("Enemy_\(typeName)_Pupils")
        //let pupils = SKSpriteNode(texture: pupilsTexture)
        pupils.name = "Pupils"
        pupils.zPosition = 4.2
        
        enemyNode.addChild(pupils)
        
        // 1
        enemyNode.physicsBody = SKPhysicsBody(circleOfRadius: enemyNode.size.width / 2)
        // 2
        enemyNode.physicsBody?.dynamic = true
        // 3
        enemyNode.physicsBody?.allowsRotation = false
        // 4
        enemyNode.physicsBody?.restitution = 1.0
        enemyNode.physicsBody?.friction = 0.0
        enemyNode.physicsBody?.angularDamping = 0.0
        enemyNode.physicsBody?.linearDamping = 0.0
        enemyNode.physicsBody?.usesPreciseCollisionDetection = true
        enemyNode.physicsBody?.collisionBitMask = BodyType.player1.rawValue | BodyType.ground.rawValue | BodyType.enemy1.rawValue
        
        // assign collision type
        enemyNode.physicsBody?.categoryBitMask = BodyType.enemy1.rawValue
        enemyNode.physicsBody?.fieldBitMask = BodyType.gravity.rawValue
        // listen for these collisions
        enemyNode.physicsBody?.contactTestBitMask = BodyType.ground.rawValue | BodyType.player1.rawValue | BodyType.platforms.rawValue
        enemyNode.physicsBody?.velocity = direction
        
        // add Projectiles
        if ofType == 5 {
            let wait = SKAction.waitForDuration(NSTimeInterval(2.00))
            let shoot = SKAction.runBlock {
                if self.player.position.x < enemyNode.position.x {
                    self.addProjectile(CGPoint(x: enemyNode.position.x + 5, y: enemyNode.position.y), direction: -500)
                } else {
                    self.addProjectile(CGPoint(x: enemyNode.position.x + 5, y: enemyNode.position.y), direction: 500)
                }
            }
            enemyNode.runAction(SKAction.repeatActionForever(SKAction.sequence([wait, shoot])))
            
        }
        
        return enemyNode
    }
    
    func animateEnemy(velocity: CGFloat, enemy: EnemyNode) {
        let eyes = enemy.childNodeWithName("Eyes")
        let pupil = enemy.childNodeWithName("Pupils")
        if velocity <= 0 {
            eyes?.runAction(SKAction.moveToX(-2, duration: 0.25))
            pupil?.runAction(SKAction.moveToX(-4, duration: 0.25))
        } else {
            eyes?.runAction(SKAction.moveToX(2, duration: 0.25))
            pupil?.runAction(SKAction.moveToX(4, duration: 0.25))
        }
    }
    
    // Projectiles
    
    func addProjectile(position: CGPoint, direction: Int) -> SKSpriteNode {
        
        let projectileNode = SKSpriteNode(imageNamed: "Projectile 1")
        projectileNode.position = position
        projectileNode.zPosition = 4
        projectileNode.physicsBody = SKPhysicsBody(rectangleOfSize: projectileNode.size)
        projectileNode.physicsBody?.dynamic = true
        projectileNode.physicsBody?.allowsRotation = false
        projectileNode.physicsBody?.affectedByGravity = false
        projectileNode.physicsBody?.restitution = 1.0
        projectileNode.physicsBody?.friction = 0.0
        projectileNode.physicsBody?.angularDamping = 0.0
        projectileNode.physicsBody?.linearDamping = 0.0
        
        projectileNode.physicsBody?.categoryBitMask = BodyType.projectiles.rawValue
        projectileNode.physicsBody?.collisionBitMask = 0
        projectileNode.physicsBody?.contactTestBitMask = BodyType.player1.rawValue
        projectileNode.physicsBody?.fieldBitMask = BodyType.nogravity.rawValue
        projectileNode.physicsBody?.velocity.dy = 0
        projectileNode.physicsBody?.velocity.dx = CGFloat(direction)
        foregroundNode.addChild(projectileNode)
        return projectileNode
    }
    
    // Bonus
    
    func addBonus(position: CGPoint, direction:CGVector, ofType: Int) -> BonusNode {
        let typeDict = bonusTypes[ofType] as NSDictionary
        let typeName = typeDict["Type"] as! String
        
        let bonusNode = BonusNode(imageNamed: "Bonus \(typeName)")
    
        bonusNode.name = "bonus\(ofType)_\(enemyNumber)"
        
        bonusNumber += 1
        
        bonusNode.position = position
        bonusNode.zPosition = 4
        bonusNode.bonusType = ofType
        
        //enemyNode.setValue(1, forKey: "test")
        
        // 1
        bonusNode.physicsBody = SKPhysicsBody(circleOfRadius: bonusNode.size.width / 2)
        // 2
        bonusNode.physicsBody?.dynamic = true
        // 3
        bonusNode.physicsBody?.allowsRotation = false
        // 4
        bonusNode.physicsBody?.restitution = 1.0
        bonusNode.physicsBody?.friction = 0.0
        bonusNode.physicsBody?.angularDamping = 0.0
        bonusNode.physicsBody?.linearDamping = 0.0
        bonusNode.physicsBody?.usesPreciseCollisionDetection = true
        bonusNode.physicsBody?.collisionBitMask = BodyType.ground.rawValue | BodyType.platforms.rawValue
        
        // assign collision type
        bonusNode.physicsBody?.categoryBitMask = BodyType.bonuses.rawValue
        bonusNode.physicsBody?.fieldBitMask = BodyType.gravity.rawValue
        // listen for these collisions
        bonusNode.physicsBody?.contactTestBitMask = BodyType.ground.rawValue | BodyType.player1.rawValue | BodyType.platforms.rawValue
        bonusNode.physicsBody?.velocity = direction
        
        
        return bonusNode
    }
    
    func addCoin(position: CGPoint, direction: CGVector) -> SKSpriteNode {
        
        let firstFrame = coinAnimationFrames[0]
        let coinNode = SKSpriteNode(texture: firstFrame)
        
        coinNode.name = "coin\(coinNumber)"
        
        coinNumber += 1
        
        coinNode.position = position
        coinNode.zPosition = 4
        
        
        // 1
        coinNode.physicsBody = SKPhysicsBody(circleOfRadius: coinNode.size.width / 2)
        // 2
        coinNode.physicsBody?.dynamic = true
        // 3
        coinNode.physicsBody?.allowsRotation = false
        // 4
        coinNode.physicsBody?.restitution = 1.0
        coinNode.physicsBody?.friction = 0.0
        coinNode.physicsBody?.angularDamping = 0.0
        coinNode.physicsBody?.linearDamping = 0.0
        coinNode.physicsBody?.usesPreciseCollisionDetection = true
        coinNode.physicsBody?.collisionBitMask = BodyType.ground.rawValue | BodyType.platforms.rawValue
        
        // assign collision type
        coinNode.physicsBody?.categoryBitMask = BodyType.bonuses.rawValue
        coinNode.physicsBody?.fieldBitMask = BodyType.gravity.rawValue
        // listen for these collisions
        coinNode.physicsBody?.contactTestBitMask = BodyType.ground.rawValue | BodyType.player1.rawValue | BodyType.platforms.rawValue
        coinNode.physicsBody?.velocity = direction
        
        coinNode.runAction(SKAction.repeatActionForever(
            SKAction.animateWithTextures(coinAnimationFrames,
                timePerFrame: 1/30,
                resize: false,
                restore: true)),
            withKey:"coinAnimation")
        
        return coinNode
    }
    

    
    func createWall(position: CGPoint, height: Int, width: Int, ofType type: String) -> WallNode {
        let wallNode = WallNode()
        wallNode.position = CGPoint(x: position.x + CGFloat(width/2), y: position.y - CGFloat(height/2))
        wallNode.wallType = type
        if type == "wallAngledLeft" {
            wallNode.physicsBody = SKPhysicsBody(edgeFromPoint: CGPoint(x: -width / 2, y: height / 2), toPoint: CGPoint(x: width / 2, y: -height / 2))
        } else if type == "wallAngledRight" {
            wallNode.physicsBody = SKPhysicsBody(edgeFromPoint: CGPoint(x: -width / 2, y: -height / 2), toPoint: CGPoint(x: width / 2, y: height / 2))
        } else {
            wallNode.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: width, height: height))
        }
            // 2
        wallNode.physicsBody?.dynamic = false
        // 3
        wallNode.physicsBody?.allowsRotation = false
        // 4
        
        wallNode.physicsBody?.collisionBitMask = 0
        // assign collision type
        wallNode.physicsBody?.categoryBitMask = BodyType.ground.rawValue
        
        return wallNode
    }
    
    
    
    func createTileAtPosition(position: CGPoint, height: Int, width: Int, ofType type: Int) -> TileNode {
        let tileNode = TileNode(texture: self.atlasArray[type - 1])
        tileNode.position = position
        tileNode.zPosition = 0
        
        return tileNode
    }
    
    func createPlatformAtPosition(position: CGPoint, height: Int, width: Int, ofType type: String) -> PlatformNode {
        let platformNode = PlatformNode()
        let platformPosition = CGPoint(x: position.x + CGFloat(width / 2), y: position.y - CGFloat(height / 2))
        platformNode.position = platformPosition
        platformNode.platformType = type
        platformNode.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: width, height: height))
        platformNode.physicsBody?.dynamic = false
        platformNode.physicsBody?.categoryBitMask = BodyType.platforms.rawValue
        platformNode.physicsBody?.collisionBitMask = 0
        return platformNode
    }
    
    func createPlatformActivateAtPosition(position: CGPoint, height: Int, width: Int, ofType type: String) -> PlatformNode {
        let platformActivateNode = PlatformNode()
        let platformActivatePosition = CGPoint(x: position.x + CGFloat(width/2), y: position.y - CGFloat(height / 2) + CGFloat(height))
        platformActivateNode.position = platformActivatePosition
        platformActivateNode.platformType = "activate"
        platformActivateNode.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: width, height: height))
        platformActivateNode.physicsBody?.dynamic = false
        platformActivateNode.physicsBody?.categoryBitMask = BodyType.platformActivate.rawValue
        platformActivateNode.physicsBody?.collisionBitMask = 0
        return platformActivateNode
    }
    
    func createPlayerEdgeAtPosition(position: CGPoint, height: Int, width: Int, ofType type: String) -> PlayerEdgeNode {
        let playerEdgeNode = PlayerEdgeNode()
        let playerEdgePosition = CGPoint(x: position.x + CGFloat(width/2), y: position.y - CGFloat(height/2))
        playerEdgeNode.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: width, height: height))
        playerEdgeNode.position = playerEdgePosition
        //playerEdgeNode.platformType = "activate"
        playerEdgeNode.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: width, height: height))
        playerEdgeNode.physicsBody?.dynamic = false
        playerEdgeNode.physicsBody?.categoryBitMask = BodyType.playerEdge.rawValue
        playerEdgeNode.physicsBody?.collisionBitMask = 0
        return playerEdgeNode
    }

    
    override func didMoveToView(view: SKView) {
        
        
        physicsWorld.contactDelegate = self

        setSceneValues()
        
        createSceneContents()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "pauseMenu", name: "pauseGame", object: nil)
        
        
        startMonitoringAcceleration()
        
    }
    
    
    
    // Physics & Collisions
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        // Ground & Player
        
        if (contact.bodyA.categoryBitMask == BodyType.ground.rawValue && contact.bodyB.categoryBitMask == BodyType.player1.rawValue )  {
            
            if let wall = contact.bodyA.node as? WallNode {
                let wallType = wall.wallType
                if wallType == "wallTop" {
                    
                    let bounceHeight = 600 + attributeBounce * 30 as CGFloat
                    
                    if player.physicsBody?.velocity.dy < bounceHeight {
                        player.physicsBody?.velocity.dy = bounceHeight
                    } else if player.physicsBody?.velocity.dy > bounceHeight * 2.5 {
                        player.physicsBody?.velocity.dy = bounceHeight * 1.6667
                    } else {
                        let impactVelocity = player.physicsBody?.velocity.dy
                        player.physicsBody?.velocity.dy = bounceHeight + ((impactVelocity!) - bounceHeight) / 2
                    }

                } else if wallType == "wallBooster" {
                    
                    player.physicsBody?.velocity.dy = 1500
                    
                } else if wallType == "wallVertical" {
                    if player.physicsBody?.velocity.dx < 500 && player.physicsBody?.velocity.dx > 0 {
                        player.physicsBody?.velocity.dx = 500
                    } else if player.physicsBody?.velocity.dx > -500 && player.physicsBody?.velocity.dx < 0 {
                        player.physicsBody?.velocity.dx = -500
                    }
                    
                    if player.physicsBody?.velocity.dy > 0 && player.physicsBody?.velocity.dy < 500 {
                        player.physicsBody?.velocity.dy = 500
                    }
                } else if wallType == "mapEdge" {
                    self.playerOneHealth = 0
                } else if wallType == "spikes" {
                    self.playerOneHealth = 0
                }
                
                
            }
            
            // Adjust Score
            
            if scoreRunning > 0 {
                let score = Int(Double(scoreRunning) * Double(scoreMultiplier) * bonusMultiplier)
                if score > achievComboScore {
                    achievComboScore = score
                    checkAchievement("achievComboScore", subType: 0, amount: Double(achievComboScore))
                }
                if scoreMultiplier > achievComboMultiplier {
                    achievComboMultiplier = scoreMultiplier
                    checkAchievement("achievComboMultiplier", subType: 0, amount: Double(achievComboMultiplier))
                }
                adjustScore(score)
            }
            
            // Check if the round is over
            
            if survivalRoundOver == true {
                let enemiesLeft = foregroundNode.childNodeWithName("enemy*")
                if enemiesLeft == nil {
                    survivalRoundOver = false
                    roundComplete(self.survivalRound)
                    
                }
                
            }
            
            playerOneEnemyPass = [""]
            playerOneJump = true
            scoreMultiplier = 0
            scoreRunning = 0
            
            
        } else if (contact.bodyA.categoryBitMask == BodyType.player1.rawValue && contact.bodyB.categoryBitMask == BodyType.ground.rawValue )  {
            
            //reset player1 velocity when hitting a platform
            if let wall = contact.bodyB.node as? WallNode {
                let wallType = wall.wallType
                if wallType == "wallTop" {
                    
                    let bounceHeight = 600 + attributeBounce * 30 as CGFloat
                    if player.physicsBody?.velocity.dy < bounceHeight {
                        player.physicsBody?.velocity.dy = bounceHeight
                    } else if player.physicsBody?.velocity.dy > bounceHeight * 2.5 {
                        player.physicsBody?.velocity.dy = bounceHeight * 1.66667
                    } else {
                        let impactVelocity = player.physicsBody?.velocity.dy
                        player.physicsBody?.velocity.dy = bounceHeight + ((impactVelocity!) - bounceHeight) / 2
                    }
                    
                } else if wallType == "wallBooster" {
                    
                    player.physicsBody?.velocity.dy = 1500
                    
                } else if wallType == "wallVertical" {
                    if player.physicsBody?.velocity.dx < 300 && player.physicsBody?.velocity.dx > 0 {
                        player.physicsBody?.velocity.dx = 300
                    } else if player.physicsBody?.velocity.dx > -300 && player.physicsBody?.velocity.dx < 0 {
                        player.physicsBody?.velocity.dx = -300
                    }
                    
                    if player.physicsBody?.velocity.dy > 0 && player.physicsBody?.velocity.dy < 500 {
                        player.physicsBody?.velocity.dy = 500
                    }
                } else if wallType == "mapEdge" {
                    self.playerOneHealth = 0
                } else if wallType == "spikes" {
                    self.playerOneHealth = 0
                }
                
                if survivalRoundOver == true {
                    let enemiesLeft = foregroundNode.childNodeWithName("enemy*")
                    if enemiesLeft == nil {
                        survivalRoundOver = false
                        roundComplete(self.survivalRound)
                        
                    }
                    
                }
            
            }

            //let scaleStretch = SKAction.scaleXTo(1.25, y: 00.75, duration: 0.1)
            //player.runAction(scaleStretch)
            
            if scoreRunning > 0 {
                let score = Int(Double(scoreRunning) * Double(scoreMultiplier) * bonusMultiplier)
                if score > achievComboScore {
                    achievComboScore = score
                    checkAchievement("achievComboScore", subType: 0, amount: Double(achievComboScore))
                }
                if scoreMultiplier > achievComboMultiplier {
                    achievComboMultiplier = scoreMultiplier
                    checkAchievement("achievComboMultiplier", subType: 0, amount: Double(achievComboMultiplier))
                }
                adjustScore(score)
            }
            
            //Check if the Round is over
            
            if survivalRoundOver == true {
                let enemiesLeft = foregroundNode.childNodeWithName("enemy*")
                if enemiesLeft == nil {
                    survivalRoundOver = false
                    roundComplete(self.survivalRound)
                    
                }
                
            }
            
            playerOneEnemyPass = [""]
            playerOneJump = true
            scoreMultiplier = 0
            scoreRunning = 0
            
        // Enemy & Ground Contact
            
        } else if (contact.bodyA.categoryBitMask == BodyType.enemy1.rawValue && contact.bodyB.categoryBitMask == BodyType.ground.rawValue )  {
            
            if let wall = contact.bodyB.node as? WallNode {
                let wallType = wall.wallType
                if wallType == "mapEdge" {
                    contact.bodyA.node?.removeFromParent()
                }
            }
            
            if let enemy = contact.bodyA.node as? EnemyNode {
                
                animateEnemy(contact.bodyA.velocity.dx, enemy: enemy)
                
                let enemyType = enemy.enemyType
                
                let enemyDictionary = enemyTypes[enemyType]
                let enemyVelocity = enemyDictionary["Velocity"] as! Int
                
                if enemyType == 4 {
                    let random = arc4random_uniform(UInt32(700))
                    contact.bodyA.velocity.dy = CGFloat(Int(enemyVelocity) + Int(random))
                } else {
                    
                    if contact.bodyA.velocity.dy < CGFloat(enemyVelocity) {
                        contact.bodyA.velocity.dy = CGFloat(enemyVelocity)
                    } else if contact.bodyA.velocity.dy > CGFloat(enemyVelocity * 3) {
                        contact.bodyA.velocity.dy = CGFloat(enemyVelocity * 2)
                    } else {
                        let impactVelocity = contact.bodyA.velocity.dy
                        contact.bodyA.velocity.dy = CGFloat(enemyVelocity) + ((impactVelocity) - CGFloat(enemyVelocity)) / 2
                    }
                }
            }
            
        } else if (contact.bodyA.categoryBitMask == BodyType.ground.rawValue && contact.bodyB.categoryBitMask == BodyType.enemy1.rawValue )  {
            
            if let wall = contact.bodyA.node as? WallNode {
                let wallType = wall.wallType
                if wallType == "mapEdge" {
                    contact.bodyB.node?.removeFromParent()
                }
            }
            
            if let enemy = contact.bodyB.node as? EnemyNode {
                
                animateEnemy(contact.bodyB.velocity.dx, enemy: enemy)
                
                let enemyType = enemy.enemyType
                let enemyDictionary = enemyTypes[enemyType]
                let enemyVelocity = enemyDictionary["Velocity"] as! Int
                
                if enemyType == 4 {
                    let random = arc4random_uniform(UInt32(700))
                    contact.bodyB.velocity.dy = CGFloat(Int(enemyVelocity) + Int(random))
                } else {
                    
                    
                    if contact.bodyB.velocity.dy < CGFloat(enemyVelocity) {
                        contact.bodyB.velocity.dy = CGFloat(enemyVelocity)
                    } else if contact.bodyB.velocity.dy > CGFloat(enemyVelocity * 3) {
                        contact.bodyB.velocity.dy = CGFloat(enemyVelocity * 2)
                    } else {
                        let impactVelocity = contact.bodyB.velocity.dy
                        contact.bodyB.velocity.dy = CGFloat(enemyVelocity) + ((impactVelocity) - CGFloat(enemyVelocity)) / 2
                    }
                }
            }
            
        // Enemy & Player Contact
            
        } else if (contact.bodyA.categoryBitMask == BodyType.enemy1.rawValue && contact.bodyB.categoryBitMask == BodyType.player1.rawValue)  {
            
            let enemy = contact.bodyA.node as! EnemyNode
            let enemyType = enemy.enemyType
            
            let enemyDictionary = enemyTypes[enemyType]
            let enemyAttack = enemyDictionary["Attack"] as! Int
            let enemyPoints = enemyDictionary["Points"] as! Int
            
            
            if playerOneInstaKill == false {
                if contact.bodyB.node!.position.y < contact.bodyA.node!.position.y + 5 {
                    if playerOneInvincible == false {
                        adjustHealth(-enemyAttack)
                    }
                    
                    animateEnemy(contact.bodyB.velocity.dx, enemy: enemy)
                    
                } else {
                    
                    if enemy.enemyHealth >= 2 {
                        
                        enemy.enemyHealth--
                        enemy.color = UIColor.redColor()
                        enemy.colorBlendFactor = 0.5
                        enemy.runAction(SKAction.colorizeWithColorBlendFactor(0.0, duration: 0.4))
                        player.physicsBody?.velocity.dy = 500 + attributeBounce * 15
                        playerOneJump = true;
                        animateEnemy(contact.bodyA.velocity.dx, enemy: enemy)
                        
                    } else {
                        if playerOneSpecialActivated == true {
                            achievSpecialKills++
                            checkAchievement("achievSpecialKills", subType: 0, amount: Double(achievSpecialKills))
                        }
                        achievKillsTotal++
                        achievKillsRound++
                        checkAchievement("achievKillsTotal", subType: 0, amount: Double(achievKillsTotal))
                        checkAchievement("achievKillRound", subType: 0, amount: Double(achievKillsRound))
                        if enemyType == 6 {
                            print("Created Babies")
                            let newEnemyOne = addEnemy(contact.bodyA.node!.position, direction: CGVector.init(dx: -150, dy: contact.bodyA.velocity.dy), ofType: 2)
                            let newEnemyTwo = addEnemy(contact.bodyA.node!.position, direction: CGVector.init(dx: 150, dy: contact.bodyA.velocity.dy), ofType: 2)
                            foregroundNode.addChild(newEnemyOne)
                            foregroundNode.addChild(newEnemyTwo)
                        }
                        contact.bodyA.node!.removeFromParent()
                        scoreMultiplier = scoreMultiplier + 1
                        incrementMultiplierScore(+enemyPoints)
                        adjustSpecial(1)
                        addScorePopUp(enemyPoints, multiplier: scoreMultiplier, position: contact.bodyA.node!.position)
                        playerOneJump = true;
                        player.physicsBody?.velocity.dy = 500 + attributeBounce * 15
                        GameState.sharedInstance.enemies += 1
                        
                    }
                }
            } else {
                if playerOneSpecialActivated == true {
                    achievSpecialKills++
                    checkAchievement("achievSpecialKills", subType: 0, amount: Double(achievSpecialKills))
                }
                achievKillsTotal++
                achievKillsRound++
                checkAchievement("achievKillsTotal", subType: 0, amount: Double(achievKillsTotal))
                checkAchievement("achievKillRound", subType: 0, amount: Double(achievKillsRound))
                contact.bodyA.node!.removeFromParent()
                scoreMultiplier = scoreMultiplier + 1
                incrementMultiplierScore(+enemyPoints)
                adjustSpecial(1)
                addScorePopUp(enemyPoints, multiplier: scoreMultiplier, position: contact.bodyA.node!.position)
                playerOneJump = true;
                GameState.sharedInstance.enemies += 1
            }
            
            
            
        } else if (contact.bodyA.categoryBitMask == BodyType.player1.rawValue && contact.bodyB.categoryBitMask == BodyType.enemy1.rawValue)  {
            
            let enemy = contact.bodyB.node as! EnemyNode
            let enemyType = enemy.enemyType
            let enemyDictionary = enemyTypes[enemyType]
            let enemyAttack = enemyDictionary["Attack"] as! Int
            let enemyPoints = enemyDictionary["Points"] as! Int
            
            if playerOneInstaKill == false {
                
                if contact.bodyA.node!.position.y < contact.bodyB.node!.position.y + 5 {
                    if playerOneInvincible == false {
                        adjustHealth(-enemyAttack)
                    }
                    animateEnemy(contact.bodyB.velocity.dx, enemy: enemy)
                    
                } else {
                    if enemy.enemyHealth >= 2 {
                        
                        enemy.enemyHealth--
                        enemy.color = UIColor.redColor()
                        enemy.colorBlendFactor = 0.5
                        enemy.runAction(SKAction.colorizeWithColorBlendFactor(0.0, duration: 0.4))
                        player.physicsBody?.velocity.dy = 500 + attributeBounce * 15
                        playerOneJump = true;
                        animateEnemy(contact.bodyB.velocity.dx, enemy: enemy)
                        
                    } else {
                        if playerOneSpecialActivated == true {
                            achievSpecialKills++
                            checkAchievement("achievSpecialKills", subType: 0, amount: Double(achievSpecialKills))
                        }
                        achievKillsTotal++
                        achievKillsRound++
                        checkAchievement("achievKillsTotal", subType: 0, amount: Double(achievKillsTotal))
                        checkAchievement("achievKillsRound", subType: 0, amount: Double(achievKillsRound))
                        if enemyType == 6 {
                            let newEnemyOne = addEnemy(contact.bodyB.node!.position, direction: CGVector.init(dx: -150, dy: contact.bodyB.velocity.dy), ofType: 2)
                            let newEnemyTwo = addEnemy(contact.bodyB.node!.position, direction: CGVector.init(dx: 150, dy: contact.bodyB.velocity.dy), ofType: 2)
                            foregroundNode.addChild(newEnemyOne)
                            foregroundNode.addChild(newEnemyTwo)
                        }
                        contact.bodyB.node!.removeFromParent()
                        scoreMultiplier = scoreMultiplier + 1
                        incrementMultiplierScore(+enemyPoints)
                        adjustSpecial(1)
                        addScorePopUp(enemyPoints, multiplier: scoreMultiplier, position: contact.bodyB.node!.position)
                        playerOneJump = true;
                        player.physicsBody?.velocity.dy = 500 + attributeBounce * 15
                        GameState.sharedInstance.enemies += 1
                    }
                    
                }
                
            } else {
                
                if playerOneSpecialActivated == true {
                    achievSpecialKills++
                    checkAchievement("achievSpecialKills", subType: 0, amount: Double(achievSpecialKills))
                }
                
                achievKillsTotal++
                achievKillsRound++
                checkAchievement("achievKillsTotal", subType: 0, amount: Double(achievKillsTotal))
                checkAchievement("achievKillRound", subType: 0, amount: Double(achievKillsRound))
                contact.bodyB.node!.removeFromParent()
                scoreMultiplier = scoreMultiplier + 1
                incrementMultiplierScore(+enemyPoints)
                adjustSpecial(1)
                addScorePopUp(enemyPoints, multiplier: scoreMultiplier, position: contact.bodyB.node!.position)
                playerOneJump = true;
                GameState.sharedInstance.enemies += 1
            }
            
        // Bonuses & Player Contact
            
        } else if (contact.bodyA.categoryBitMask == BodyType.bonuses.rawValue && contact.bodyB.categoryBitMask == BodyType.player1.rawValue)  {
            
            if let bonus = contact.bodyA.node as? BonusNode {
                bonus.removeFromParent()
                
                bonusGained = true
            } else {
                contact.bodyA.node?.removeFromParent()
                print("Coin Gained")
                incrementCoins(1)
            }
            
            
            
            
        } else if (contact.bodyA.categoryBitMask == BodyType.player1.rawValue && contact.bodyB.categoryBitMask == BodyType.bonuses.rawValue)  {
            
            if let bonus = contact.bodyB.node as? BonusNode {
                bonus.removeFromParent()
                
                bonusGained = true
            } else {
                contact.bodyB.node?.removeFromParent()
                print("Coin Gained")
                incrementCoins(1)
            }
            
        // Bonuses & Ground Contact
            
        } else if (contact.bodyA.categoryBitMask == BodyType.bonuses.rawValue && contact.bodyB.categoryBitMask == BodyType.ground.rawValue )  {
            
            if let wall = contact.bodyB.node as? WallNode {
                let wallType = wall.wallType
                if wallType == "mapEdge" {
                    contact.bodyA.node?.removeFromParent()
                }
            }
            
        } else if (contact.bodyA.categoryBitMask == BodyType.ground.rawValue && contact.bodyB.categoryBitMask == BodyType.bonuses.rawValue )  {
            
            if let wall = contact.bodyA.node as? WallNode {
                let wallType = wall.wallType
                if wallType == "mapEdge" {
                    contact.bodyB.node?.removeFromParent()
                }
            }
            
        // Platforms & Player
            
        } else if (contact.bodyA.categoryBitMask == BodyType.platforms.rawValue && contact.bodyB.categoryBitMask == BodyType.player1.rawValue )  {
            
            if (contact.bodyB.node?.valueForKey("platformActivate"))! as! NSObject == false {
                contact.bodyB.node?.setValue(true, forKey: "platformContact")

            } else {
                if player.physicsBody?.velocity.dy < 400 {
                    player.physicsBody?.velocity.dy = 400
                } else if player.physicsBody?.velocity.dy > 2100 {
                    player.physicsBody?.velocity.dy = 1400
                } else {
                    let impactVelocity = player.physicsBody?.velocity.dy
                    player.physicsBody?.velocity.dy = 700 + ((impactVelocity!) - 700) / 2
                }
                if scoreRunning > 0 {
                    adjustScore(scoreRunning * scoreMultiplier)
                }
                playerOneJump = true
                scoreMultiplier = 0
                scoreRunning = 0
            }
            
            
        } else if (contact.bodyA.categoryBitMask == BodyType.player1.rawValue && contact.bodyB.categoryBitMask == BodyType.platforms.rawValue )  {
            
            if (contact.bodyA.node?.valueForKey("platformActivate"))! as! NSObject == false {
                contact.bodyA.node?.setValue(true, forKey: "platformContact")

                
            } else {
                if player.physicsBody?.velocity.dy < 400 {
                    player.physicsBody?.velocity.dy = 400
                } else if player.physicsBody?.velocity.dy > 2100 {
                    player.physicsBody?.velocity.dy = 1400
                } else {
                    let impactVelocity = player.physicsBody?.velocity.dy
                    player.physicsBody?.velocity.dy = 700 + ((impactVelocity!) - 700) / 2
                }
                if scoreRunning > 0 {
                    adjustScore(scoreRunning * scoreMultiplier)
                }
                playerOneJump = true
                scoreMultiplier = 0
                scoreRunning = 0
            }
            
        // Platform Activaters & Player
            
        } else if (contact.bodyA.categoryBitMask == BodyType.platformActivate.rawValue && contact.bodyB.categoryBitMask == BodyType.player1.rawValue )  {
            contact.bodyB.node?.setValue(true, forKey: "platformActivate")
            if (contact.bodyB.node?.valueForKey("platformContact"))! as! NSObject == false {
                if self.playerOneInstaKill == true {
                    contact.bodyB.node?.physicsBody?.collisionBitMask = BodyType.ground.rawValue | BodyType.platforms.rawValue | BodyType.playerEdge.rawValue
                } else {
                    contact.bodyB.node?.physicsBody?.collisionBitMask = BodyType.ground.rawValue | BodyType.platforms.rawValue | BodyType.enemy1.rawValue | BodyType.playerEdge.rawValue
                }
            }
            
            
            
        } else if (contact.bodyA.categoryBitMask == BodyType.player1.rawValue && contact.bodyB.categoryBitMask == BodyType.platformActivate.rawValue )  {
            contact.bodyA.node?.setValue(true, forKey: "platformActivate")
            
            if (contact.bodyA.node?.valueForKey("platformContact"))! as! NSObject == false {
                if self.playerOneInstaKill == true {
                    contact.bodyA.node?.physicsBody?.collisionBitMask = BodyType.ground.rawValue | BodyType.platforms.rawValue | BodyType.playerEdge.rawValue
                } else {
                    contact.bodyA.node?.physicsBody?.collisionBitMask = BodyType.ground.rawValue | BodyType.platforms.rawValue | BodyType.enemy1.rawValue | BodyType.playerEdge.rawValue
                }
            }
            
        // Enemy and Platforms
            
        } else if (contact.bodyA.categoryBitMask == BodyType.enemy1.rawValue && contact.bodyB.categoryBitMask == BodyType.platforms.rawValue )  {
            
            if let enemy = contact.bodyA.node as? EnemyNode {
                let enemyType = enemy.enemyType
                
                let enemyDictionary = enemyTypes[enemyType]
                let enemyVelocity = enemyDictionary["Velocity"] as! Int
                
                if enemyType == 4 {
                    let random = arc4random_uniform(UInt32(800))
                    contact.bodyA.velocity.dy = CGFloat(Int(enemyVelocity) + Int(random))
                } else {
                    
                    if contact.bodyA.velocity.dy < CGFloat(enemyVelocity / 2) {
                        contact.bodyA.velocity.dy = CGFloat(enemyVelocity / 2)
                    } else if contact.bodyA.velocity.dy > CGFloat(enemyVelocity * 3) {
                        contact.bodyA.velocity.dy = CGFloat(enemyVelocity * 2)
                    } else {
                        let impactVelocity = contact.bodyA.velocity.dy
                        contact.bodyA.velocity.dy = CGFloat(enemyVelocity) + ((impactVelocity) - CGFloat(enemyVelocity)) / 2
                    }
                }
            }
        
        } else if (contact.bodyA.categoryBitMask == BodyType.platforms.rawValue && contact.bodyB.categoryBitMask == BodyType.enemy1.rawValue )  {
            
            if let enemy = contact.bodyB.node as? EnemyNode {
                let enemyType = enemy.enemyType
                let enemyDictionary = enemyTypes[enemyType]
                let enemyVelocity = enemyDictionary["Velocity"] as! Int
                
                if enemyType == 4 {
                    let random = arc4random_uniform(UInt32(800))
                    contact.bodyB.velocity.dy = CGFloat(Int(enemyVelocity) + Int(random))
                } else {
                    
                    
                    if contact.bodyB.velocity.dy < CGFloat(enemyVelocity / 2) {
                        contact.bodyB.velocity.dy = CGFloat(enemyVelocity / 2)
                    } else if contact.bodyB.velocity.dy > CGFloat(enemyVelocity * 3) {
                        contact.bodyB.velocity.dy = CGFloat(enemyVelocity * 2)
                    } else {
                        let impactVelocity = contact.bodyB.velocity.dy
                        contact.bodyB.velocity.dy = CGFloat(enemyVelocity) + ((impactVelocity) - CGFloat(enemyVelocity)) / 2
                    }
                }
            }
        // Enemy & Enemy
        } else if (contact.bodyA.categoryBitMask == BodyType.enemy1.rawValue && contact.bodyB.categoryBitMask == BodyType.enemy1.rawValue )  {
            
            if let enemyA = contact.bodyA.node as? EnemyNode {
                animateEnemy(contact.bodyA.velocity.dx, enemy: enemyA)
            }
            
            if let enemyB = contact.bodyB.node as? EnemyNode {
                animateEnemy(contact.bodyB.velocity.dx, enemy: enemyB)
            }
            
            
        // Player & Projectiles
            
        } else if (contact.bodyA.categoryBitMask == BodyType.player1.rawValue && contact.bodyB.categoryBitMask == BodyType.projectiles.rawValue )  {
            if playerOneInvincible == false {
                contact.bodyB.node?.removeFromParent()
                adjustHealth(-1)
            }
        } else if (contact.bodyA.categoryBitMask == BodyType.projectiles.rawValue && contact.bodyB.categoryBitMask == BodyType.player1.rawValue )  {
            if playerOneInvincible == false {
                contact.bodyA.node?.removeFromParent()
                adjustHealth(-1)
            }
            
        // Player & Map Edge
        } else if (contact.bodyA.categoryBitMask == BodyType.player1.rawValue && contact.bodyB.categoryBitMask == BodyType.playerEdge.rawValue )  {
            
        } else if (contact.bodyA.categoryBitMask == BodyType.playerEdge.rawValue && contact.bodyB.categoryBitMask == BodyType.player1.rawValue )  {

        }
    
    
    
    
    
    }

    func didEndContact(contact: SKPhysicsContact) {
        
        if (contact.bodyA.categoryBitMask == BodyType.platforms.rawValue && contact.bodyB.categoryBitMask == BodyType.player1.rawValue )  {
            
            
            contact.bodyB.node?.setValue(false, forKey: "platformContact")
            
        } else if (contact.bodyA.categoryBitMask == BodyType.player1.rawValue && contact.bodyB.categoryBitMask == BodyType.platforms.rawValue )  {
            

            contact.bodyA.node?.setValue(false, forKey: "platformContact")
            
        } else if (contact.bodyA.categoryBitMask == BodyType.player1.rawValue && contact.bodyB.categoryBitMask == BodyType.platformActivate.rawValue ) {
            contact.bodyA.node?.setValue(false, forKey: "platformActivate")
            if playerOneInstaKill == true {
                contact.bodyA.node?.physicsBody?.collisionBitMask = BodyType.ground.rawValue | BodyType.playerEdge.rawValue
            } else {
                contact.bodyA.node?.physicsBody?.collisionBitMask = BodyType.ground.rawValue | BodyType.enemy1.rawValue | BodyType.playerEdge.rawValue
            }
       
            
        } else if (contact.bodyA.categoryBitMask == BodyType.platformActivate.rawValue && contact.bodyB.categoryBitMask == BodyType.player1.rawValue ) {
            contact.bodyB.node?.setValue(false, forKey: "platformActivate")
            if playerOneInstaKill == true {
                contact.bodyB.node?.physicsBody?.collisionBitMask = BodyType.ground.rawValue | BodyType.playerEdge.rawValue
            } else {
                contact.bodyB.node?.physicsBody?.collisionBitMask = BodyType.ground.rawValue | BodyType.enemy1.rawValue | BodyType.playerEdge.rawValue
            }
        }
        
    }
    
    
    
    // Add Score indicator when collisions with enemy occur
    
    func addScorePopUp(score: Int, multiplier: Int, position: CGPoint) {
        
        let scoreLabel = SKLabelNode(fontNamed: "EncodeSansNarrow-Regular")
        scoreLabel.zPosition = 7
        
        if let popUp = hudNode.childNodeWithName("ScorePopUp") as! SKLabelNode? {
            if self.bonusMultiplier > 1 {
                popUp.text = String("+\(self.scoreRunning) x \(self.scoreMultiplier) x \(self.bonusMultiplier)")
            } else {
                
                if self.scoreMultiplier > 1 {
                    popUp.text = String("+\(self.scoreRunning) x \(self.scoreMultiplier)")
                } else {
                    popUp.text = String("+\(self.scoreRunning)")
                }
            }
            
        } else {
            scoreLabel.fontSize = 12;
            scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
            scoreLabel.fontColor = SKColor.blackColor()
            scoreLabel.name = "ScorePopUp"
            scoreLabel.position = CGPoint(x: frame.size.width / 2 - 20, y: size.height / 2 - (50 + scoreLabel.frame.size.height/2))
            
            
            if self.bonusMultiplier > 1 {
                scoreLabel.text = String("+\(self.scoreRunning) x \(self.scoreMultiplier) x \(self.bonusMultiplier)")
            } else {
                
                if self.scoreMultiplier > 1 {
                    scoreLabel.text = String("+\(self.scoreRunning) x \(self.scoreMultiplier)")
                } else {
                    scoreLabel.text = String("+\(self.scoreRunning)")
                }
            }
            hudNode.addChild(scoreLabel)
        }
        
        
    }
    
    class PlayerNode: SKSpriteNode {
        var platformContact = false
        var platformActivate = false
    }
    
    class PlatformNode: SKNode {
        var platformType = String()
    }
    
    class PlayerEdgeNode: SKNode {
        var playerEdgeType = String()
    }
    
    class WallNode: SKNode {
        var wallType = String()
    }
    
    class TileNode: SKSpriteNode {
        var tileType = Int()
    }
    
    class EnemyNode: SKSpriteNode {
        var enemyType = Int()
        var enemyHealth = Int()
    }
    
    class BonusNode: SKSpriteNode {
        var bonusType = Int()
    }
    
    
    
    // Setup HUD
    
    func setupHud() {
        
        // add Score info
        hudView = UIView()
        let skScene = self.view!
        skScene.ignoresSiblingOrder = true
        self.hudView.userInteractionEnabled = true
        self.hudView.frame = skScene.frame
        
        self.view!.addSubview(hudView)
        
        let scoreLabel = SKLabelNode(fontNamed: ".SFUIText-Medium")
        scoreLabel.name = kScoreHudName
        scoreLabel.fontSize = 20
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        scoreLabel.fontColor = SKColor.blackColor()
        scoreLabel.text = String(playerOneScore)
        scoreLabel.zPosition = 7
        scoreLabel.position = CGPoint(x: frame.size.width / 2 - spacing, y: size.height / 2 - (spacing + scoreLabel.frame.size.height/2))
        
        hudNode.addChild(scoreLabel)
        
        
        if skillSpecialType != "" {
            let specialButton = createSpecialButton(skillSpecialType, duration: skillSpecialDuration, activation: skillSpecialActivation, skill: true)
            hudNode.addChild(specialButton)
        }
        
        
        // add Health Bar
        
        createHealthBar()
        
        let pauseButtonImage = UIImage(named: "Pause Button")! as UIImage
        let pauseButton = UIButton(frame: CGRectMake(0, 0, 40, 40))
        pauseButton.backgroundColor = UIColor.clearColor()
        pauseButton.setImage(pauseButtonImage, forState: .Normal)
        pauseButton.center = CGPoint(x: pauseButton.frame.width/2, y: self.view!.frame.height - pauseButton.frame.height/2)
        pauseButton.addTarget(self, action: "pauseButton:", forControlEvents: UIControlEvents.TouchUpInside)
        pauseButton.userInteractionEnabled = true
        
        lblCoins = SKLabelNode(fontNamed: ".SFUIText-Medium")
        lblCoins.fontSize = 20
        lblCoins.text = "\(GameState.sharedInstance.coins)"
        lblCoins.position = CGPoint(x: frame.size.width / 4, y: size.height / 2 - (spacing + lblCoins.frame.size.height/2))
        lblCoins.fontColor = yellow
        lblCoins.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        lblCoins.zPosition = 7
        lblCoins.alpha = 0.0
        
        hudNode.addChild(lblCoins)
        
        self.hudView.addSubview(pauseButton)
        
        skScene.addSubview(self.hudView)
        
    }
    
    func createHealthBar() {
        for var index = 0; index < attributeHealth; ++index {
            let width = spacing * 1.25
            let height = spacing * 0.25
            let xOffset = (spacing / 3 + width) * CGFloat(index)
            let healthBar = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
            healthBar.backgroundColor = white
            healthBar.layer.cornerRadius = healthBar.frame.height / 2
            healthBar.center = CGPoint(x: spacing + width/2 + xOffset, y: spacing + height / 2)
            addGlow(healthBar, color: white, size: 0.5)
            playerOneHealthArray.append(healthBar)
            hudView.addSubview(playerOneHealthArray[index])
        }
    }
    
    func adjustHealthBar(index: Int, amount: Int) {
        if amount < 0 {
            let healthBar = playerOneHealthArray[index]
            
            let red = SKAction.runBlock {
                healthBar.backgroundColor = UIColor.redColor()
                healthBar.layer.shadowColor = UIColor.redColor().CGColor
            }
            
            let white = SKAction.runBlock {
                healthBar.backgroundColor = UIColor.whiteColor()
                healthBar.layer.shadowColor = UIColor.whiteColor().CGColor
            }
            
            let black = SKAction.runBlock {
                healthBar.backgroundColor = UIColor.blackColor()
                healthBar.alpha = 0.25
                healthBar.layer.shadowOpacity = 0.0
                healthBar.layer.shadowRadius = 0
            }
            
            let wait = SKAction.waitForDuration(0.1)
            
            self.runAction(SKAction.sequence([red, wait, white, wait, black]))
            
        } else {
            let healthBar = playerOneHealthArray[index]
            healthBar.alpha = 1.0
            healthBar.backgroundColor = green
            addGlow(healthBar, color: green, size: 0.5)
            
            let wait = SKAction.waitForDuration(0.1)
            
            let white = SKAction.runBlock {
                healthBar.backgroundColor = UIColor.whiteColor()
                healthBar.layer.shadowColor = UIColor.whiteColor().CGColor
            }
            self.runAction(SKAction.sequence([wait, white]))
            
        }
    }
    func createSpecialButton(type: String, duration: CGFloat, activation: Int, skill: Bool) -> SKSpriteNode {
        
        //Create Button
        
        specialButton = SKSpriteNode(texture: SKTexture(imageNamed: "\(type) Icon"), color: white, size: CGSize(width: 40, height: 40))
        
        specialButton.position = CGPoint(x: -specialButton.frame.width / 2 - self.frame.width / 2, y: 0)
        specialButton.name = "\(type)_\(duration)_\(activation)_\(skill)"
        specialButton.zPosition = 7
        
        

        //Create Special Progress Bar
        specialProgressBar = SKSpriteNode(color: yellow, size: CGSize(width: specialButton.frame.width, height: specialButton.frame.height))
        
        if activation == 0 {
            
            specialProgressBar.position = CGPoint(x: 0, y: 0)
            pulseSpecial()
            
        } else {

            specialProgressBar.position = CGPoint(x: 0, y: -specialProgressBar.frame.height / 2)
            specialProgressBar.yScale = 0
            
        }
        
        
        specialProgressBar.zPosition = -1
        specialProgressBar.userInteractionEnabled = false
        specialButton.addChild(specialProgressBar)
        
        let specialButtonBackground = SKSpriteNode(color: black, size: CGSize(width: 40, height: 40))
        specialButtonBackground.zPosition = -2
        specialButtonBackground.alpha = 0.25
        specialButton.addChild(specialButtonBackground)
        
        
        specialButton.runAction(SKAction.moveToX(spacing + specialButton.frame.width / 2 - self.frame.width / 2, duration: 0.5))
        return specialButton
    }
    
    
    
    func adjustHealth(healthAdjustment: Int) {
        
        
        if playerOneHealth + healthAdjustment > attributeHealth {
            
            self.playerOneHealth = attributeHealth
            
        } else {
            if healthAdjustment < 0 && playerOneInvincible == false {
                

                self.playerOneHealth = playerOneHealth + healthAdjustment
                
                // Update HUD
                adjustHealthBar(self.playerOneHealth, amount: healthAdjustment)
                
                // Damage Red Screen indicator
                let fade = SKAction.fadeOutWithDuration(0.5)
                let remove = SKAction.removeFromParent()
                let redBoxSize = CGSize(width: frame.size.width, height: frame.size.height)
                
                let boxOne = SKSpriteNode.init(color: SKColor(red: 1.0, green: 0.0, blue: 0.1, alpha: 0.5), size: redBoxSize)
                boxOne.position = CGPoint(x:0, y:0)
                boxOne.zPosition = 7
                boxOne.runAction(SKAction.sequence([fade,remove]))
                hudNode.addChild(boxOne)
                
                // If Damage Bubble is on, activate sheild
                
                if skillDamageBubble > 0 {
                    activateShield(Double(skillDamageBubble))
                }
            }
            
            if healthAdjustment > 0 {
                self.playerOneHealth = playerOneHealth + healthAdjustment
                adjustHealthBar(self.playerOneHealth - 1, amount: healthAdjustment)
            }
            
            
        }
        
        
        if healthAdjustment < 0 && playerOneInvincible == false {
            player.color = UIColor.redColor()
            player.colorBlendFactor = 0.5
            player.runAction(SKAction.colorizeWithColorBlendFactor(0.0, duration: 0.4))
            
            if levelType == "survival" {
                self.survivalRoundHealthBonus = false
            }
        } else {
            player.color = UIColor.greenColor()
            player.colorBlendFactor = 0.5
            player.runAction(SKAction.colorizeWithColorBlendFactor(0.0, duration: 0.4))
        }
        
        if playerOneHealth <= 0 {
            endGame()
        }

    }
    
    func adjustScore(scoreAdjustment: Int) {
        
        let score = hudNode.childNodeWithName(kScoreHudName) as! SKLabelNode
        let grow = SKAction.scaleTo(1.25, duration: 0.1)
        let shrink = SKAction.scaleTo(1, duration: 0.5)
        score.runAction(SKAction.sequence([grow, shrink]))
        self.playerOneScore = playerOneScore + scoreAdjustment
        
        if levelType == "survival" {
            let newScore = Double(survivalRoundScore + scoreAdjustment)
            self.survivalRoundScore = Int(newScore)
            checkAchievement("achievScoreTotal", subType: 0, amount: Double(self.playerOneScore))
            checkAchievement("achievScoreRound", subType: 0, amount: Double(self.survivalRoundScore))
        }
        GameState.sharedInstance.score += scoreAdjustment
        score.text = String(playerOneScore)
        
        if let popUp = hudNode.childNodeWithName("ScorePopUp") as! SKLabelNode? {
            popUp.text = "+\(scoreAdjustment)"
            let fade = SKAction.fadeOutWithDuration(0.5)
            let moveUp = SKAction.moveToY(popUp.position.y + 10, duration: 0.5)
            //let wait = SKAction.waitForDuration(0.25)
            let animateOut = SKAction.group([fade, moveUp])
            let remove = SKAction.removeFromParent()
            popUp.runAction(SKAction.sequence([animateOut, remove]))
        }
        
    }
    
    func incrementMultiplierScore(scoreAdjustment: Int) {
        scoreRunning += scoreAdjustment
    }
    
    func adjustSpecial(specialAdjustment: Int) {
        if skillSpecialType == "" {
            
        } else {
            
            
            let specialButtonArray = specialButton.name!.componentsSeparatedByString("_")
            let activationNS = NSNumberFormatter().numberFromString(specialButtonArray[2])
            let activation = Int(activationNS!)
            
            
            if playerOneSpecial < activation && playerOneSpecialActivated == false {
                
                playerOneSpecial += specialAdjustment
                if playerOneSpecial == activation {
                    pulseSpecial()
                }
                let j = CGFloat(playerOneSpecial)/CGFloat(activation)
                specialProgressBar.yScale = j
                specialProgressBar.position = CGPoint(x: 0, y: specialProgressBar.frame.width * j / 2 - specialProgressBar.frame.width / 2)
                
            } else {
                
            }
        }
    }
    
    func pulseSpecial() {
        
        let fadeUp = SKAction.fadeAlphaTo(1.0, duration: 0.5)
        let fadeDown = SKAction.fadeAlphaTo(0.5, duration: 0.5)
        let scaleUp = SKAction.scaleTo(1.1, duration: 0.75)
        let scaleDown = SKAction.scaleTo(0.9, duration: 0.75)
        specialProgressBar.runAction(SKAction.repeatActionForever(SKAction.sequence([fadeDown, fadeUp])))
        specialButton.runAction(SKAction.repeatActionForever(SKAction.sequence([scaleUp, scaleDown])))
        
    }
    
    
    func specialDeactivation(duration: Double, skill: Bool) {
        
        specialButton.removeAllActions()
        specialButton.setScale(1.0)
        
        specialProgressBar.removeAllActions()
        specialProgressBar.alpha = 1.0
        
        specialProgressBar.runAction(SKAction.scaleYTo(0.0, duration: duration))
        specialProgressBar.runAction(SKAction.moveToY(-specialProgressBar.frame.width / 2, duration: duration))
        let wait = SKAction.waitForDuration(duration)
        let run = SKAction.runBlock({
            self.playerOneSpecialActivated = false
            self.playerOneInstaKill = false
            self.playerOneInvincible = false
            // if skill bool is false, run swap, else leave it on screen
            if skill == true && self.specialQueue.count == 0 {
                
            } else {
                self.removeSpecial()
            }
        })
        specialProgressBar.runAction(SKAction.sequence([wait, run]))
        
    }
    
    func removeSpecial() {
        
        
        let moveOffScreen = SKAction.moveToX(-self.frame.width / 2 - specialButton.frame.width / 2, duration: 0.5)
        let removeButton = SKAction.runBlock({
            
            // Remove Previous Special Button
            self.specialButton.name = ""
            self.specialButton.removeAllChildren()
            self.specialButton.removeAllActions()
            self.specialButton.removeFromParent()
            self.playerOneSpecial = 0
            
            if self.specialQueue.count > 0 {
                
                // Get next special button info from the queue
                
                let specialButtonArray = self.specialQueue[0].componentsSeparatedByString("_")
                let type = specialButtonArray[0] as String
                let durationNS = NSNumberFormatter().numberFromString(specialButtonArray[1])
                let duration = CGFloat(durationNS!)
                let activationNS = NSNumberFormatter().numberFromString(specialButtonArray[2])
                let activation = Int(activationNS!)
                
                // Create next Special button
                
                let specialButton = self.createSpecialButton(type, duration: duration, activation: activation, skill: false)
                self.hudNode.addChild(specialButton)
                
                // remove from the queue
                self.specialQueue.removeAtIndex(0)
                
            } else if self.skillSpecialType != "" {
                
                // Create Skill Special
                
                let specialButton = self.createSpecialButton(self.skillSpecialType, duration: self.skillSpecialDuration, activation: self.skillSpecialActivation, skill: true)
                self.hudNode.addChild(specialButton)
                
                
            }
        })
        
        specialButton.runAction(SKAction.sequence([moveOffScreen, removeButton]))
        
        if specialButton.name == nil {
            // Get next special button info from the queue
            
            let specialButtonArray = self.specialQueue[0].componentsSeparatedByString("_")
            let type = specialButtonArray[0] as String
            let durationNS = NSNumberFormatter().numberFromString(specialButtonArray[1])
            let duration = CGFloat(durationNS!)
            let activationNS = NSNumberFormatter().numberFromString(specialButtonArray[2])
            let activation = Int(activationNS!)
            
            // Create next Special button
            
            let specialButton = self.createSpecialButton(type, duration: duration, activation: activation, skill: false)
            self.hudNode.addChild(specialButton)
            
            // remove from the queue
            self.specialQueue.removeAtIndex(0)
        }
    }
    
    
    
    func addShieldButton() {
        
    }
    
    func activateShield(duration: Double) {
        playerOneInvincible = true
        // Create Sheild
        
        print("added Shield")
        
        let shield = SKShapeNode(circleOfRadius: player.frame.width / 2 + spacing / 3)
        shield.fillColor = blue
        shield.strokeColor = UIColor.clearColor()
        shield.name = "shield"
        shield.alpha = 0.4
        shield.zPosition = 4.5
        player.addChild(shield)
        
        
        let fadeUp = SKAction.fadeAlphaTo(0.6, duration: 0.5)
        let fadeDown = SKAction.fadeAlphaTo(0.2, duration: 0.5)
        shield.runAction(SKAction.repeatActionForever(SKAction.sequence([fadeUp, fadeDown])))
        
        let wait = SKAction.waitForDuration(duration)
        let shieldOff = SKAction.runBlock {
            self.playerOneInvincible = false
        }
        let remove = SKAction.removeFromParent()
        shield.runAction(SKAction.sequence([wait, shieldOff, remove]))

    }
    
    func activateSpecial(type: String, duration: Double) {
        
        let specialButtonArray = specialButton.name!.componentsSeparatedByString("_")
        let type = specialButtonArray[0] as String
        let activationNS = NSNumberFormatter().numberFromString(specialButtonArray[2])
        let activation = Int(activationNS!)
        let skillBoolString = specialButtonArray[3]
        
        var skillBool = false
        if skillBoolString == "true" {
            skillBool = true
        }
        
        if playerOneSpecial >= activation {
            
            playerOneSpecial = 0
            
            achievSpecialActivations++
            
            playerOneSpecialActivated = true
            
            checkAchievement("achievSpecialActivations", subType: 0, amount: Double(achievSpecialActivations))

            // Reset Special Bar
            
            if type == "Shield" {
                
                specialDeactivation(duration, skill: skillBool)
                if let shield = player.childNodeWithName("shield") {
                    shield.removeAllActions()
                    shield.removeFromParent()
                }
                activateShield(duration)
                
            } else if type == "Gravity Well" {
                
                specialDeactivation(duration, skill: skillBool)
                playerOneInvincible = true
                playerOneInstaKill = true
                
                //Add Glowing Trail
                let emitter = SKEmitterNode(fileNamed: "Special1.sks")
                emitter!.targetNode = foregroundNode
                emitter!.name = "specialTrail"
                player.addChild(emitter!)
                
                // Add particles
                let circle = SKSpriteNode(imageNamed: "Special Pulse")
                circle.name = "specialEffect"
                let shrink = SKAction.scaleTo(0.0, duration: 0.75)
                let grow = SKAction.scaleTo(1.0, duration: 0.0001)
                circle.runAction(SKAction.repeatActionForever(SKAction.sequence([shrink, grow])))
                player.addChild(circle)
                
                // Create Gravity Well
                let gravityNode = SKFieldNode.radialGravityField()
                gravityNode.categoryBitMask = BodyType.gravity.rawValue
                gravityNode.strength = 8
                gravityNode.region = SKRegion(radius: 600)
                gravityNode.falloff = 4
                gravityNode.runAction(SKAction.sequence([SKAction.waitForDuration(duration), SKAction.removeFromParent()]))
                player.addChild(gravityNode)
                
                player.physicsBody?.collisionBitMask = BodyType.ground.rawValue | BodyType.playerEdge.rawValue
                foregroundNode.enumerateChildNodesWithName("enemy*", usingBlock: {
                    node, stop in
                    node.physicsBody?.collisionBitMask = BodyType.ground.rawValue | BodyType.enemy1.rawValue | BodyType.playerEdge.rawValue
                })
                
                //Activate Special Countdown
                
                let wait = SKAction.waitForDuration(NSTimeInterval(duration))
                let run = SKAction.runBlock {
                    let specialEffect = self.player.childNodeWithName("specialEffect")
                    specialEffect?.removeFromParent()
                    let specialTrail = self.player.childNodeWithName("specialTrail")
                    specialTrail?.removeFromParent()
                    self.playerOneSpecialActivated = false
                    self.playerOneInstaKill = false
                    self.playerOneInvincible = false
                    self.player.color = UIColor.whiteColor()
                    self.player.colorBlendFactor = 1.0
                    self.player.physicsBody?.collisionBitMask = BodyType.enemy1.rawValue | BodyType.ground.rawValue | BodyType.playerEdge.rawValue
                    self.foregroundNode.enumerateChildNodesWithName("enemy*", usingBlock: {
                        node, stop in
                        node.physicsBody?.collisionBitMask = BodyType.player1.rawValue | BodyType.ground.rawValue | BodyType.enemy1.rawValue
                    })
                }
                player.runAction(SKAction.sequence([wait, run]))
            }
            
        }
    }
    
    
    
    // Provide list of possible enemies to spawn
    
    func generateEnemyList() -> NSMutableArray {
        let weightedList: NSMutableArray = [Int()]
        var index = 0
        
        for enemyType in enemyTypes {
            
            let prob = Int((enemyType["Spawn Probability"] as! Double) * 100)
            let spawnTime = enemyType["Spawn Start Time"] as! Int
            
            if levelType == "survival" {
                if spawnTime <= survivalRound {
                    for (var j = 0; j < prob; j++) {
                        weightedList.addObject(index)
                    }
                }
            } else {
                if spawnTime < Int(CACurrentMediaTime() - gameStartTime) {
                    for (var j = 0; j < prob; j++) {
                        weightedList.addObject(index)
                    }
                }
            }
            index++
            
        }
        return weightedList
    }
    
    // Provide list of possible Bonuses to choose from
    
    func generateBonusList() -> NSMutableArray {
        let weightedList: NSMutableArray = [Int()]
        var index = 0
        
        for bonusType in bonusTypes {
            
            //let type = bonusType["Type"] as? String
            let prob = Int((bonusType["Spawn Probability"] as! Double) * 100)
            let spawnTime = bonusType["Spawn Start Time"] as! Int
            if spawnTime < survivalRound {
                for (var j = 0; j < prob; j++) {
                    weightedList.addObject(index)
                }
            }
            index++
            
        }
        return weightedList
    }
    
    func roundComplete(roundNumber: Int) {

        // reset Round Multiplier
        
        
        
        
        
        let lblRound = UILabel()
        lblRound.font = UIFont(name: ".SFUIText-Bold", size: 25)
        lblRound.textColor = UIColor.blackColor()
        lblRound.textAlignment = NSTextAlignment.Center
        lblRound.text = "Round \(self.survivalRound) Cleared"
        lblRound.sizeToFit()
        lblRound.center = CGPointMake(self.view!.frame.width / 2, lblRound.frame.height / 2)
        hudView.addSubview(lblRound)
        
        let yPos = lblRound.frame.height / 2 + 10
        
        UIView.animateWithDuration(0.9, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: [], animations: {
            lblRound.center.y = yPos
            }, completion: { finished in
                UIView.animateWithDuration(0.3, delay: 1.5, options: [.CurveEaseInOut], animations: {
                    lblRound.center.y = -yPos
                    }, completion: { finished in
                        if self.bonusGained == true  {
                            self.roundBonus()
                        } else {
                            self.startNextRound()
                        }

                        lblRound.removeFromSuperview()
                        
                })
        })
        
        
        let roundBonus = Int(Double(survivalRoundScore) * survivalRoundMultiplier - Double(survivalRoundScore))
        
        let lblRoundScore = UILabel()
        lblRoundScore.font = UIFont(name: ".SFUIText-Light", size: 12)
        lblRoundScore.alpha = 0.0
        lblRoundScore.textColor = UIColor.blackColor()
        lblRoundScore.textAlignment = NSTextAlignment.Right
        lblRoundScore.text = "Round Bonus: +\(roundBonus)"
        lblRoundScore.sizeToFit()
        lblRoundScore.center = CGPointMake(self.view!.frame.width - 20 - lblRoundScore.frame.width / 2, 40)
        hudView.addSubview(lblRoundScore)
        
        
        UIView.animateWithDuration(0.4, delay: 0.25, options: [.CurveEaseInOut], animations: {
            lblRoundScore.alpha = 1.0
            }, completion: { finished in
                UIView.animateWithDuration(0.4, delay: 1.5, options: [.CurveEaseOut], animations: {
                    lblRoundScore.center.y = lblRoundScore.center.y - lblRoundScore.frame.height
                    lblRoundScore.alpha = 0.0
                    }, completion: { finished in
                        
                        lblRoundScore.removeFromSuperview()
                        self.adjustScore(roundBonus)
                })
        })
        
        
        
        if self.survivalRoundHealthBonus == true {
            let lblHealthBonus = UILabel()
            lblHealthBonus.font = UIFont(name: ".SFUIText-Light", size: 12)
            lblHealthBonus.textColor = UIColor.blackColor()
            lblHealthBonus.alpha = 0.0
            lblHealthBonus.textAlignment = NSTextAlignment.Right
            lblHealthBonus.text = "Perfect Round: +1000"
            lblHealthBonus.sizeToFit()
            lblHealthBonus.center = CGPointMake(self.view!.frame.width - 20 - lblHealthBonus.frame.width / 2, 55)
            
            hudView.addSubview(lblHealthBonus)
            achievPerfectRound++
            checkAchievement("achievPerfectRound", subType: 0, amount: Double(achievPerfectRound))
            
            UIView.animateWithDuration(0.4, delay: 0.35, options: [.CurveEaseOut], animations: {
                lblHealthBonus.alpha = 1.0
                }, completion: { finished in
                    UIView.animateWithDuration(0.4, delay: 1.5, options: [.CurveEaseInOut], animations: {
                        lblHealthBonus.center.y = lblHealthBonus.center.y - lblHealthBonus.frame.height
                        lblHealthBonus.alpha = 0.0
                        }, completion: { finished in
                            
                            lblHealthBonus.removeFromSuperview()
                            self.adjustScore(1000)
                            
                    })
            })
        }
        
        if achievKillsRound >= enemyCountRound {
            
            var yPos = 55 as CGFloat
            var delay = 0.35
            
            if self.survivalRoundHealthBonus == true {
                yPos = 70
                delay = 0.45
            } else {
                yPos = 55
                delay = 0.35
            }
            
            let lblEnemiesCleared = UILabel()
            lblEnemiesCleared.font = UIFont(name: ".SFUIText-Light", size: 12)
            lblEnemiesCleared.textColor = UIColor.blackColor()
            lblEnemiesCleared.alpha = 0.0
            lblEnemiesCleared.textAlignment = NSTextAlignment.Right
            lblEnemiesCleared.text = "All Enemies Cleared: +2000"
            lblEnemiesCleared.sizeToFit()
            lblEnemiesCleared.center = CGPointMake(self.view!.frame.width - 20 - lblEnemiesCleared.frame.width / 2, yPos)
            
            hudView.addSubview(lblEnemiesCleared)
            achievAllEnemiesCleared++
            checkAchievement("achievAllEnemiesCleared", subType: 0, amount: Double(achievAllEnemiesCleared))
            
            UIView.animateWithDuration(0.4, delay: delay, options: [.CurveEaseOut], animations: {
                lblEnemiesCleared.alpha = 1.0
                }, completion: { finished in
                    UIView.animateWithDuration(0.4, delay: 1.5, options: [.CurveEaseInOut], animations: {
                        lblEnemiesCleared.center.y = lblEnemiesCleared.center.y - lblEnemiesCleared.frame.height
                        lblEnemiesCleared.alpha = 0.0
                        }, completion: { finished in
                            
                            lblEnemiesCleared.removeFromSuperview()
                            self.adjustScore(1000)
                            
                    })
            })
            
        }
        
        

        
        // Reset Round Variables
        
        bonusMultiplier = 1
        achievKillsRound = 0
        
        survivalRoundScore = 0
        survivalRoundMultiplier += 0.1
        survivalRoundEnemyTypes = []
        survivalRoundHealthBonus = true
    }
    
    func roundTitle(roundNumber: Int, enemyCount: Int) {
        
        let lblRound = UILabel()
        lblRound.font = UIFont(name: ".SFUIText-Bold", size: 25)
        lblRound.textColor = UIColor.blackColor()
        lblRound.textAlignment = NSTextAlignment.Center
        lblRound.text = "Round \(roundNumber)"
        lblRound.sizeToFit()
        lblRound.center = CGPointMake(self.view!.frame.width / 2, lblRound.frame.height / 2)
        hudView.addSubview(lblRound)
        
        let yPosRound = lblRound.frame.height / 2 + 10
        
        
        
        UIView.animateWithDuration(0.9, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: [], animations: {
            lblRound.center.y = yPosRound
            }, completion: { finished in
                UIView.animateWithDuration(0.3, delay: 2.0, options: [.CurveEaseInOut], animations: {
                    lblRound.center.y = -yPosRound
                    }, completion: { finished in
                        
                        lblRound.removeFromSuperview()
                        
                })
        })
        
        let lblEnemyCount = UILabel()
        lblEnemyCount.font = UIFont(name: ".SFUIText-Light", size: 15)
        lblEnemyCount.textColor = UIColor.blackColor()
        lblEnemyCount.textAlignment = NSTextAlignment.Center
        lblEnemyCount.text = "\(enemyCount) Enemies"
        lblEnemyCount.sizeToFit()
        lblEnemyCount.center = CGPointMake(self.view!.frame.width / 2, lblEnemyCount.center.y)
        lblEnemyCount.alpha = 0.0
        hudView.addSubview(lblEnemyCount)
        
        let yPosEnemyCount = yPosRound + lblEnemyCount.frame.height / 2 + 15
        
        UIView.animateWithDuration(0.9, delay: 0.1, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: [], animations: {
            lblEnemyCount.center.y = yPosEnemyCount
            lblEnemyCount.alpha = 1.0
            }, completion: { finished in
                UIView.animateWithDuration(0.3, delay: 2.0, options: [.CurveEaseInOut], animations: {
                    lblEnemyCount.center.y = -yPosEnemyCount
                    lblEnemyCount.alpha = 0.0
                    }, completion: { finished in
                        
                        lblEnemyCount.removeFromSuperview()
                        
                })
        })
        
        
        let lblEnemyTypes = SKLabelNode(fontNamed: ".SFUIText-Light")
        lblEnemyTypes.fontSize = 20
        lblEnemyTypes.fontColor = SKColor.whiteColor()
        lblEnemyTypes.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        lblEnemyTypes.text = String("")
        lblEnemyTypes.position = CGPoint(x: 0, y: -10)
        lblEnemyTypes.zPosition = 7
        lblEnemyTypes.alpha = 0.0
        
        for (var j = 0; j < survivalRoundEnemyTypes.count; j++) {
            let typeDict = enemyTypes[survivalRoundEnemyTypes[j]] as NSDictionary
            let typeName = typeDict["Type"] as! String
            let enemyIcon = UIImage(named: "Enemy_\(typeName)_Icon")! as UIImage
            let enemyNode = UIView(frame: CGRect(x: 0, y: 0, width: enemyIcon.size.width, height: enemyIcon.size.height))
            enemyNode.backgroundColor = UIColor(patternImage: enemyIcon)
            enemyNode.center = CGPoint(x: CGFloat(j*40 - 40) + self.view!.frame.width / 2, y: 80)
            enemyNode.alpha = 0.0
            
            hudView.addSubview(enemyNode)
            
            UIView.animateWithDuration(0.9, delay: 0.2 + Double(j)*0.1, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: [], animations: {
                enemyNode.alpha = 1.0
                }, completion: { finished in
                    UIView.animateWithDuration(0.3, delay: 2.0, options: [.CurveEaseInOut], animations: {
                        enemyNode.alpha = 0.0
                        }, completion: { finished in
                            
                            enemyNode.removeFromSuperview()
                            
                    })
            })
        }
        
        

        
    }
    
    func roundBonus() {
        
        let fadeIn = SKAction.fadeInWithDuration(0.25)
        let fadeOut = SKAction.fadeOutWithDuration(1.0)
        let wait = SKAction.waitForDuration(3.0)
        let remove = SKAction.removeFromParent()
        let startNext = SKAction.runBlock {
            self.startNextRound()
        }
        
        bonusChooseView.frame = self.view!.frame
        bonusChooseView.center = CGPoint(x: self.view!.frame.width / 2, y: self.view!.frame.size.height / 2)
        hudView.addSubview(bonusChooseView)
        /*
        UIView.animateWithDuration(0.7, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: [], animations: {
            self.bonusChooseView.center.y = self.view!.frame.size.height / 2
            }, completion: nil)
        */
        // Get bonuses
        let list = self.generateBonusList()

        let bonusesPerRound = 3
        
        for (var j = 0; j < bonusesPerRound; j++) {
            var type = Int()
            repeat {
                let randomBonusType = arc4random_uniform(UInt32(list.count))
                type = list[Int(randomBonusType)] as! Int
                
            } while survivalRoundBonusTypes.contains(type)
            
            let bonus = self.bonusTypes[type]
            let bonusType = bonus["Type"]
            self.survivalRoundBonusTypes.append(type)
            
            
        }
        // Bonus Title
        
        
        let lblTitle = UILabel(frame: CGRectMake(0, 0, 300, 100))
        lblTitle.font = UIFont(name: ".SFUIText-Bold", size: 24)
        lblTitle.textColor = UIColor.whiteColor()
        lblTitle.center = CGPointMake(hudView.frame.width / 2, hudView.frame.height / 2 - 100)
        lblTitle.textAlignment = NSTextAlignment.Center
        lblTitle.text = "Choose a Bonus"
        bonusChooseView.addSubview(lblTitle)
        
        // Bonus Choice boxes
        
        let boxWidth = frame.size.width/5
        let boxHeight = frame.size.height/3
        let choiceBox = CGSize.init(width: boxWidth, height: boxHeight)
        
        
        func createBonusButtons(optionNumber: Int) {
            
            
            let choiceInfo = survivalRoundBonusTypes[optionNumber] as Int
            let bonus = bonusTypes[choiceInfo]
            let bonusTitle = bonus["Title"] as! String
            let bonusSubTitle = bonus["Subtitle"] as! String
            
            let bonusButton = UIButton(frame: CGRectMake(0, 0, choiceBox.width, choiceBox.height))
            bonusButton.backgroundColor = UIColor(white: 0.0, alpha: 0.6)
            bonusButton.center = CGPoint(x: self.view!.frame.width / 2 + (CGFloat(optionNumber) - 1) * 150, y: self.view!.frame.height / 2)
            bonusButton.addTarget(self, action: "executeBonus:", forControlEvents: UIControlEvents.TouchUpInside)
            bonusButton.tag = optionNumber
            bonusChooseView.addSubview(bonusButton)
            
            let lblBonusTitle = UILabel(frame: CGRectMake(0, 0, 500, 100))
            lblBonusTitle.font = UIFont(name: ".SFUIText-Bold", size: 12)
            lblBonusTitle.textColor = UIColor.whiteColor()
            lblBonusTitle.center = CGPointMake(bonusButton.frame.width / 2, bonusButton.frame.height / 2 - 10)
            lblBonusTitle.textAlignment = NSTextAlignment.Center
            lblBonusTitle.text = "\(bonusTitle)"
            
            bonusButton.addSubview(lblBonusTitle)
            
            let lblBonusSubTitle = UILabel(frame: CGRectMake(0, 0, 100, 50))
            lblBonusSubTitle.font = UIFont(name: ".SFUIText-light", size: 10)
            lblBonusSubTitle.textColor = UIColor.whiteColor()
            lblBonusSubTitle.center = CGPointMake(bonusButton.frame.width / 2, bonusButton.frame.height / 2 + 10)
            lblBonusSubTitle.textAlignment = NSTextAlignment.Center
            lblBonusSubTitle.text = "\(bonusSubTitle)"
            
            bonusButton.addSubview(lblBonusSubTitle)
            
        }
        
        createBonusButtons(0)
        createBonusButtons(1)
        createBonusButtons(2)
        
    }
    
    func achievementOverlay() {
        if GameState.sharedInstance.achievements == [1, 1, 1] {
            GameState.sharedInstance.levelUp()
        }
        
        let extraLength = 8 as CGFloat
        let rank = GameState.sharedInstance.level
        let lblIconImage = UIImage(named: "Rank Icon")! as UIImage
        
        let blackBG = UIView(frame: self.view!.frame)
        blackBG.backgroundColor = UIColor(colorLiteralRed: 0.137, green: 0.215, blue: 0.415, alpha: 0.5)
        hudView.addSubview(blackBG)
        
        let lblRank = UILabel()
        lblRank.font = UIFont(name: ".SFUIText-Bold", size: 24)
        lblRank.textColor = UIColor.whiteColor()
        lblRank.textAlignment = NSTextAlignment.Center
        lblRank.text = "Rank \(rank + 1)"
        lblRank.alpha = 0.0
        lblRank.sizeToFit()
        lblRank.center = CGPoint(x: self.view!.frame.width / 2 + 10, y: self.view!.frame.height / 2 - 60)
        hudView.addSubview(lblRank)
        
        let lblIconView = UIImageView(image: lblIconImage)
        lblIconView.center = CGPoint(x: lblRank.center.x - lblRank.frame.width / 2 - 20, y: lblRank.center.y)
        lblIconView.alpha = 0.0
        lblIconView.tintColor = UIColor.whiteColor()
        hudView.addSubview(lblIconView)
        
        let achievementOne = achievObjectives[0]
        let achievementOneText = achievementOne["Description"] as! String
        let lblAchieveOne = UILabel()
        lblAchieveOne.alpha = 0.0
        lblAchieveOne.font = UIFont(name: ".SFUIText-Normal", size: 18)
        lblAchieveOne.textColor = UIColor.whiteColor()
        lblAchieveOne.textAlignment = NSTextAlignment.Center
        lblAchieveOne.text = achievementOneText
        lblAchieveOne.sizeToFit()
        lblAchieveOne.center = CGPoint(x: self.view!.frame.width / 2, y: lblRank.center.y + 40)
        
        if GameState.sharedInstance.achievements[0] == 1 {
            let slash = UIView(frame: CGRect(x: 0, y: 0, width: lblAchieveOne.frame.width + extraLength, height: 2))
            slash.backgroundColor = UIColor.whiteColor()
            slash.center = CGPoint(x: slash.frame.width / 2 - extraLength / 2, y: lblAchieveOne.frame.height / 2)
            lblAchieveOne.addSubview(slash)
        }
        
        hudView.addSubview(lblAchieveOne)
        
        let achievementTwo = achievObjectives[1]
        let achievementTwoText = achievementTwo["Description"] as! String
        let lblAchieveTwo = UILabel()
        lblAchieveTwo.alpha = 0.0
        lblAchieveTwo.font = UIFont(name: ".SFUIText-Normal", size: 18)
        lblAchieveTwo.textColor = UIColor.whiteColor()
        lblAchieveTwo.textAlignment = NSTextAlignment.Center
        lblAchieveTwo.text = achievementTwoText
        lblAchieveTwo.textAlignment = NSTextAlignment.Center
        lblAchieveTwo.sizeToFit()
        lblAchieveTwo.center = CGPoint(x: self.view!.frame.width / 2, y: lblRank.center.y + 70)
        hudView.addSubview(lblAchieveTwo)
        
        if GameState.sharedInstance.achievements[1] == 1 {

            let slash = UIView(frame: CGRect(x: 0, y: 0, width: lblAchieveTwo.frame.width + extraLength, height: 2))
            slash.backgroundColor = UIColor.whiteColor()
            slash.center = CGPoint(x: slash.frame.width / 2 - extraLength / 2, y: lblAchieveTwo.frame.height / 2)
            lblAchieveTwo.addSubview(slash)
        }
        
        let achievementThree = achievObjectives[2]
        let achievementThreeText = achievementThree["Description"] as! String
        let lblAchieveThree = UILabel()
        lblAchieveThree.alpha = 0.0
        lblAchieveThree.font = UIFont(name: ".SFUIText-Normal", size: 18)
        lblAchieveThree.textColor = UIColor.whiteColor()
        lblAchieveThree.textAlignment = NSTextAlignment.Center
        lblAchieveThree.text = achievementThreeText
        lblAchieveThree.sizeToFit()
        lblAchieveThree.center = CGPoint(x: self.view!.frame.width / 2, y: lblRank.center.y + 100)
        hudView.addSubview(lblAchieveThree)
        
        if GameState.sharedInstance.achievements[2] == 1 {

            let slash = UIView(frame: CGRect(x: 0, y: 0, width: lblAchieveThree.frame.width + extraLength, height: 2))
            slash.backgroundColor = UIColor.whiteColor()
            slash.center = CGPoint(x: slash.frame.width / 2 - extraLength / 2, y: lblAchieveThree.frame.height / 2)
            lblAchieveThree.addSubview(slash)
        }
        
        
        UIView.animateWithDuration(0.9, delay: 0.0,  options: [.CurveEaseOut], animations: {
            
            lblRank.alpha = 1.0
            lblRank.center.y = lblRank.center.y - 20
            lblIconView.alpha = 1.0
            lblIconView.center.y = lblIconView.center.y - 20
            
            }, completion: { finished in
                UIView.animateWithDuration(0.3, delay: 3, options: [.CurveEaseIn], animations: {
                    
                    lblRank.alpha = 0.0
                    lblRank.center.y = lblRank.center.y - 20
                    lblIconView.alpha = 0.0
                    lblIconView.center.y = lblIconView.center.y - 20
                    
                    }, completion: { finished in
                        
                        lblRank.removeFromSuperview()
                        lblIconView.removeFromSuperview()
                        
                })
        })
        
        UIView.animateWithDuration(0.9, delay: 0.2,  options: [.CurveEaseOut], animations: {
            
            lblAchieveOne.alpha = 1.0
            lblAchieveOne.center.y = lblAchieveOne.center.y - 20
            
            }, completion: { finished in
                UIView.animateWithDuration(0.3, delay: 3, options: [.CurveEaseIn], animations: {
                    
                    lblAchieveOne.alpha = 0.0
                    lblAchieveOne.center.y = lblAchieveOne.center.y - 20
                    
                    }, completion: { finished in
                        
                        lblAchieveOne.removeFromSuperview()
                        
                })
        })
        
        UIView.animateWithDuration(0.9, delay: 0.3,  options: [.CurveEaseOut], animations: {
            
            lblAchieveTwo.alpha = 1.0
            lblAchieveTwo.center.y = lblAchieveTwo.center.y - 20
            
            }, completion: { finished in
                UIView.animateWithDuration(0.3, delay: 3, options: [.CurveEaseIn], animations: {
                    
                    lblAchieveTwo.alpha = 0.0
                    lblAchieveTwo.center.y = lblAchieveTwo.center.y - 20
                    
                    }, completion: { finished in
                        
                        lblAchieveTwo.removeFromSuperview()
                        
                })
        })
        
        UIView.animateWithDuration(0.9, delay: 0.4,  options: [.CurveEaseOut], animations: {
            
            lblAchieveThree.alpha = 1.0
            lblAchieveThree.center.y = lblAchieveThree.center.y - 20
            
            }, completion: { finished in
                UIView.animateWithDuration(0.3, delay: 3, options: [.CurveEaseIn], animations: {
                    
                    lblAchieveThree.alpha = 0.0
                    lblAchieveThree.center.y = lblAchieveThree.center.y - 20
                    blackBG.alpha = 0.0
                    
                    }, completion: { finished in
                        
                        lblAchieveThree.removeFromSuperview()
                        blackBG.removeFromSuperview()
                        self.startNextRound()
                })
        })
        
        
    }
    
    func executeBonus(sender: UIButton) {
        
        print("Execute Bonus")
        // remove view
        for view in self.bonusChooseView.subviews {
            
            view.removeFromSuperview()
            
        }
        bonusChooseView.removeFromSuperview()
        
            
        let bonusChoice = survivalRoundBonusTypes[sender.tag]
        
        let bonusInfo = bonusTypes[bonusChoice]
        
        let bonusType = bonusInfo["Type"] as! String
        
        let bonusAmount = bonusInfo["Amount"] as! Double
        print(bonusType)
        
        if bonusType == "Health" {
            
            adjustHealth(Int(bonusAmount))
            
        } else if bonusType == "Points" {
            
            adjustScore(Int(bonusAmount))
            
        } else if bonusType == "Special" {
            
            playerOneSpecialDuration = playerOneSpecialDuration * (1 + bonusAmount/100)
            
        } else if bonusType == "Multiplier" {
            
            bonusMultiplier = bonusAmount
            
        } else if bonusType == "Shield" {
            print("Ran create bonus special function")
            let specialString = "Shield_\(bonusAmount)_0_false"
            specialQueue.append(specialString)
            
            if playerOneSpecialActivated == false {
                removeSpecial()
            }
            
            
        }
       
        
        
        // Start Next Round
        self.survivalRoundBonusTypes = []
        self.startNextRound()
        
    }
    
    func startNextRound() {
        survivalRound++
        
        self.bonusSpawned = false
        self.bonusGained = false
        
        checkAchievement("achievReachRound", subType: 0, amount: Double(survivalRound))
        self.enemyCountRound = (survivalRound-1)*2 + 10
        
        let spawnAction = SKAction.runBlock {
            // bonus stuff here
            
            
            let randomSpawnPoint = Int(arc4random_uniform(UInt32(self.enemySpawnPoints.count)))
            let spawnPoint = self.enemySpawnPoints[randomSpawnPoint]
            let spawnPointX = spawnPoint["positionX"] as! Int
            let spawnPointY = spawnPoint["positionY"] as! Int
            let velocityX = spawnPoint["velocityX"] as! Int
            let enemyDirection = CGVectorMake(CGFloat(velocityX), 0)
            
            let list = self.survivalRoundEnemyTypes
            let randomEnemyType = arc4random_uniform(UInt32(list.count))
            
            let type = list[Int(randomEnemyType)]
            
            
            
            let spawnPointPosition = CGPoint(x: spawnPointX, y: -spawnPointY)
            let enemyNode = self.addEnemy(spawnPointPosition, direction: enemyDirection, ofType: type)
            self.foregroundNode.addChild(enemyNode)
            
            // Spawn Bonuses
            
            if self.bonusSpawned == false {
                let randomNumber = Int(arc4random_uniform(UInt32(100)))
                if randomNumber < 25 {
                    self.bonusSpawned = true
                    let bonus = self.addBonus(CGPoint(x: spawnPointX, y: -spawnPointY + 20), direction: CGVectorMake(CGFloat(velocityX) * 1.3, 0), ofType: 0)
                    self.foregroundNode.addChild(bonus)
                }
                
            }
            // Spawn Coins
            
            let randomNumber = Int(arc4random_uniform(UInt32(100)))
            if randomNumber < 25 {
                let coin = self.addCoin(CGPoint(x: spawnPointX, y: -spawnPointY + 20), direction: CGVectorMake(CGFloat(velocityX) * 1.2, 0))
                self.foregroundNode.addChild(coin)
            }
            
            
        }
        
        let wait = SKAction.waitForDuration(2.0 - Double(survivalRound) * 0.05)
        
        let roundEnemySpawn = SKAction.repeatAction(SKAction.sequence([spawnAction, wait]), count: self.enemyCountRound)
        
        let roundStartActions = SKAction.runBlock {
            
            // Pick the Rounds Enemies
            
            let list = self.generateEnemyList()
            let enemiesPerRound = 3
            for (var j = 0; j < enemiesPerRound; j++) {
                let randomEnemyType = arc4random_uniform(UInt32(list.count))
                let type = list[Int(randomEnemyType)] as! Int
                self.survivalRoundEnemyTypes.append(type)
            }
            
            // Display Round Information
            self.roundTitle(self.survivalRound, enemyCount: self.enemyCountRound)
            
        }
        
        let roundComplete = SKAction.runBlock {
            self.survivalRoundOver = true
            
        }
        
        self.runAction(SKAction.sequence([roundStartActions, wait, roundEnemySpawn, roundComplete]), withKey: "enemySpawn")

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let touch = touches.first {
            
            let location = touch.locationInNode(self)
            touchLocation = location
            
            touchedNode = self.nodeAtPoint(location)
            
            if touchedNode == specialButton {
                print("Special Button pressed")
                let specialButtonArray = specialButton.name!.componentsSeparatedByString("_")
                let type = specialButtonArray[0] as String
                let durationNS = NSNumberFormatter().numberFromString(specialButtonArray[1])
                let duration = Double(durationNS!)
                print("Type: \(type), Duration: \(duration)")
                activateSpecial(type, duration: duration)
            }
            
            print(touchedNode)
            
            touchTime = CACurrentMediaTime()
            
        }
    }

    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        
        
        let TouchTimeThreshold: CFTimeInterval = 0.3
        let TouchDistanceThreshold: CGFloat = 4
        let jumpFactor : CGFloat = 40;
        
        if CACurrentMediaTime() - touchTime < TouchTimeThreshold {
            
            if let touch = touches.first {
                
                let location = touch.locationInNode(self)
                let swipe = CGVector(dx: location.x - touchLocation.x, dy: location.y - touchLocation.y)
                let swipeLength = sqrt(swipe.dx * swipe.dx + swipe.dy * swipe.dy)
                if swipeLength > TouchDistanceThreshold {
                    
                    let angle = atan2(swipe.dy , swipe.dx)
                    var xFactor = CGFloat()
                    var yFactor = CGFloat()
                    if angle > 0 {
                        yFactor = 1
                    } else {
                        yFactor = -1
                    }
                    
                    if angle <= 1.5 && angle >= -1.5 {
                        xFactor = 1
                    } else {
                        xFactor = -1
                    }
                    let newX = sqrt((swipe.dx * swipe.dx)/(swipeLength * swipeLength))
                    let newY = sqrt((swipe.dy * swipe.dy)/(swipeLength * swipeLength))
                    
                    if playerOneJump == true {
                        flickVelocity = CGVector(dx: (newX * xFactor * jumpFactor), dy: newY * yFactor * jumpFactor*0.75)
                        flickActivated = true
                        
                        playerOneJump = false;
                        
                        
                    } else {
                        
                    }
                    
                }
            }
        } else {

        }
        
    }
    
    
    
    func startMonitoringAcceleration() {
        
        if motionManager.accelerometerAvailable {
            motionManager.startAccelerometerUpdates()
            print("accelerometer updates on...")
        }
    }
    
    func stopMonitoringAcceleration() {
        
        if motionManager.accelerometerAvailable && motionManager.accelerometerActive {
            motionManager.stopAccelerometerUpdates()
            print("accelerometer updates off...")
        }
    }
    
    func didPlayerPassOverEnemy() {
        let contact = scene?.physicsWorld.bodyAlongRayStart(CGPoint(x: player.position.x + foregroundNode.position.x, y: player.position.y + foregroundNode.position.y), end: CGPoint(x: player.position.x + foregroundNode.position.x, y: player.position.y - 1000 + foregroundNode.position.y))
        if contact?.categoryBitMask == BodyType.enemy1.rawValue {
            if playerOneEnemyPass.contains((contact?.node?.name)!) {
                
            } else {
                playerOneEnemyPass.append((contact?.node!.name)!)
                adjustScore(10)
                addScorePopUp(10, multiplier: 0, position: CGPoint(x: player.position.x, y: player.position.y - (player.position.y - (contact?.node?.position.y)!) / 2))
            }
        }
        
    }
    
    func didPlayerPassUnderEnemy() {
        
        
        
        let contact = scene?.physicsWorld.bodyAlongRayStart(CGPoint(x: player.position.x + foregroundNode.position.x, y: player.position.y + foregroundNode.position.y), end: CGPoint(x: player.position.x + foregroundNode.position.x, y: player.position.y + 1000 + foregroundNode.position.y))
        if contact?.categoryBitMask == BodyType.enemy1.rawValue {
            if playerOneEnemyPass.contains((contact?.node?.name)!) {
                
            } else {
                achievEnemyJumpUnder++
                print("PassedUnderEnemy")
                checkAchievement("achievEnemyJumpUnder", subType: 0, amount: Double(achievEnemyJumpUnder))
                if player.physicsBody?.velocity.dy < 0 {
                playerOneEnemyPass.append((contact?.node!.name)!)
                //incrementMultiplierScore(+50)
                //addScorePopUp(50, multiplier: 0, position: CGPoint(x: player.position.x, y: player.position.y - (player.position.y - (contact?.node?.position.y)!) / 2))
                }
            }
        }
        
    }
    
    func checkAchievement(type: String, subType: Double, amount: Double) {
        if type == "levelStart" {
            
            // get current level achievements and load into an array of dictionaries.
            let currentLevel = achievLevel
            let levelPlist = NSBundle.mainBundle().pathForResource("GameInfo", ofType: "plist")
            let levelData = NSDictionary(contentsOfFile: levelPlist!)!
            let achievementsList = levelData["Achievements"] as! NSArray
            let levelAchievements = achievementsList[currentLevel] as! [NSDictionary]
            achievObjectives = levelAchievements
            
        } else if type == "levelEnd" {
            
            // Check if anything has been completed
            // If all three have been completed, move to next level and display new objectives
            
        } else if type == "achievScoreTotal" || type == "achievScoreRound" || type == "achievReachRound" || type == "achievSpecialActivations" || type == "achievSpecialKills" || type == "achievComboScore" || type == "achievComboMultiplier" || type == "achievKillsTotal" || type == "achievKillsRound" || type == "achievPerfectRound" || type == "achievEnemyJumpUnder" || type == "achievCoins" {
            
            for var index = 0; index < 3; ++index {
                if GameState.sharedInstance.achievements[index] == 0 {
                    let objective = achievObjectives[index]
                    let objectiveType = objective["Type"] as! String
                    let objectiveAmount = objective["Amount"] as! Int
                    //let completed = objective["Completed"] as? Bool
                    if objectiveType == type && Int(amount) >= objectiveAmount {
                        
                        achievementNotificationQueue.addObject(index)
                        
                        if achievementNotificationQueue.count == 1 {
                            let arrayIndex = achievementNotificationQueue[0] as! Int
                            achievementComplete(arrayIndex)
                        }
                    }
                    
                }
            }
        }
    }
    
    func achievementProgress(type: String, amount: Double) -> Double {
        var progress = 0 as Double
        if type == "achievScoreTotal" {
            progress = (Double(playerOneScore) / amount) * 100
            //print("\(playerOneScore) / \(amount) = \(progress)")
        } else if type == "achievScoreRound" {
            progress = (Double(achievScoreRound) / amount) * 100
        } else if type == "achievReachRound" {
            progress = (Double(achievReachRound) / amount) * 100
        } else if type == "achievSpecialActivations" {
            progress = (Double(achievSpecialActivations) / amount) * 100
        } else if type == "achievSpecialKills" {
            progress = (Double(achievSpecialKills) / amount) * 100
        } else if type == "achievKillsTotal" {
            progress = (Double(achievKillsTotal) / amount) * 100
        } else if type == "achievKillsRound" {
            progress = (Double(achievKillsRound) / amount) * 100
        } else if type == "achievPerfectRound" {
            progress = (Double(achievPerfectRound) / amount) * 100
        } else if type == "achievCoins" {
            progress = (Double(achievCoins) / amount) * 100
        }
        
        return progress
    }
    
    
    func achievementComplete(index: Int) {
        GameState.updateAchievements(index)
        
        
        
    
        
        if achievPopUp == true {
            //add info to array queue
        } else {
            achievPopUp = true
        }
        
        let achievement = achievObjectives[index]
        
        
        let lblCompletedAchievement = UILabel()
        lblCompletedAchievement.text = achievement["Description"] as? String
        lblCompletedAchievement.font = UIFont(name: ".SFUIText-Light", size: 16)
        lblCompletedAchievement.textColor = UIColor.whiteColor()
        lblCompletedAchievement.textAlignment = NSTextAlignment.Center
        lblCompletedAchievement.sizeToFit()
        lblCompletedAchievement.center = CGPoint(x: self.view!.frame.width / 2, y: self.view!.frame.height + lblCompletedAchievement.frame.height)
        
        hudView.addSubview(lblCompletedAchievement)
        
        let slash = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1.5))
        slash.backgroundColor = UIColor.whiteColor()
        slash.center = CGPoint(x: -3, y: lblCompletedAchievement.frame.height / 2)
        lblCompletedAchievement.addSubview(slash)
        
        UIView.animateWithDuration(0.9, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: [], animations: {
            lblCompletedAchievement.center.y = self.view!.frame.height - lblCompletedAchievement.frame.height - 10
            }, completion: { finished in
                UIView.animateWithDuration(0.5, delay: 0.0, options: [.CurveEaseInOut], animations: {
                    slash.frame = CGRect(x:  -3, y: slash.center.y, width: lblCompletedAchievement.frame.width + 6, height: slash.frame.height)
                    }, completion: { finished in
                        UIView.animateWithDuration(0.5, delay: 2.0, options: [.CurveEaseInOut], animations: {
                            lblCompletedAchievement.center.y = self.view!.frame.height + lblCompletedAchievement.frame.height
                            }, completion: { finished in
                                lblCompletedAchievement.removeFromSuperview()
                                
                                self.achievementNotificationQueue.removeObjectAtIndex(0)
                                
                                if self.achievementNotificationQueue.count > 0 {
                                    let newIndex = self.achievementNotificationQueue[0] as! Int
                                    self.achievementComplete(newIndex)
                                }
                                
                                
                        })
                })
        })

        
        
        
        
    }
    
    func pauseButton(sender: UIButton) {

        if scaleNode.scene?.paused == false {
                createPauseMenu()
    
        } else {
            
            hudView.alpha = 1.0
            hudNode.alpha = 1.0
            
            scaleNode.scene?.paused = false
            hudView.layer.speed = 1.0
            
            for view in pauseMenu.subviews {
                
                view.removeFromSuperview()
                
            }
            
            pauseMenu.removeFromSuperview()
            
        }
    }
    
    func createGameOverMenu() {
        
        hudView.alpha = 0.0
        hudNode.alpha = 0.0
        
        gameOverView = UIView(frame: self.view!.frame)
        gameOverView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        
        if scaleNode.scene?.paused == false {
            
            self.pauseGame()
            
        }
        
        
        let bottomBar = UIView(frame: CGRect(x: 0, y: 0, width: self.view!.frame.width, height: 50))
        bottomBar.backgroundColor = UIColor(white: 0.0, alpha: 0.75)
        bottomBar.center = CGPoint(x: self.view!.frame.width / 2, y: self.view!.frame.height - bottomBar.frame.height / 2)
        gameOverView.addSubview(bottomBar)
        
        
        let restartButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: bottomBar.frame.height - 10))
        restartButton.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
        restartButton.center = CGPoint(x: bottomBar.frame.width - restartButton.frame.width / 2 - 5, y: bottomBar.frame.height / 2)
        restartButton.addTarget(self, action: "restartGame:", forControlEvents: UIControlEvents.TouchUpInside)
        bottomBar.addSubview(restartButton)
        
        let lblRestart = UILabel()
        lblRestart.font = UIFont(name: ".SFUIText-Light", size: 14)
        lblRestart.textColor = UIColor.whiteColor()
        lblRestart.textAlignment = NSTextAlignment.Left
        lblRestart.text = "Retry"
        lblRestart.sizeToFit()
        lblRestart.center = CGPoint(x: restartButton.frame.width / 2, y: restartButton.frame.height / 2)
        restartButton.addSubview(lblRestart)
        
        let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: bottomBar.frame.height - 10))
        menuButton.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
        menuButton.center = CGPoint(x: restartButton.frame.width / 2 + 5, y: bottomBar.frame.height / 2)
        menuButton.addTarget(self, action: "returnHome:", forControlEvents: UIControlEvents.TouchUpInside)
        bottomBar.addSubview(menuButton)
        
        let lblMenu = UILabel()
        lblMenu.font = UIFont(name: ".SFUIText-Light", size: 14)
        lblMenu.textColor = UIColor.whiteColor()
        lblMenu.textAlignment = NSTextAlignment.Left
        lblMenu.text = "Home"
        lblMenu.sizeToFit()
        lblMenu.center = CGPoint(x: restartButton.frame.width / 2, y: restartButton.frame.height / 2)
        menuButton.addSubview(lblMenu)
        
        let statsTable = createStatsTable()
        statsTable.center = CGPoint(x: self.view!.frame.width / 2, y: 100)
        gameOverView.addSubview(statsTable)
        
        self.view!.addSubview(gameOverView)
        
    }
    
    
    func createPauseMenu() {
        hudView.alpha = 0.0
        hudNode.alpha = 0.0
        pauseMenu = UIView(frame: self.view!.frame)
        pauseMenu.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        
        let achievementView = createAchievementView()
        
        pauseMenu.addSubview(achievementView)
        
        if scaleNode.scene?.paused == false {
            
            self.pauseGame()

        }
        
        let bottomBar = UIView(frame: CGRect(x: 0, y: 0, width: self.view!.frame.width, height: 50))
        bottomBar.backgroundColor = UIColor(white: 0.0, alpha: 0.75)
        bottomBar.center = CGPoint(x: self.view!.frame.width / 2, y: self.view!.frame.height - bottomBar.frame.height / 2)
        pauseMenu.addSubview(bottomBar)
        
        let resumeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: bottomBar.frame.height - 10))
        resumeButton.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
        resumeButton.center = CGPoint(x: bottomBar.frame.width - resumeButton.frame.width / 2 - 5, y: bottomBar.frame.height / 2)
        resumeButton.addTarget(self, action: "pauseButton:", forControlEvents: UIControlEvents.TouchUpInside)
        bottomBar.addSubview(resumeButton)
        
        let lblResume = UILabel()
        lblResume.font = UIFont(name: ".SFUIText-Light", size: 14)
        lblResume.textColor = UIColor.whiteColor()
        lblResume.textAlignment = NSTextAlignment.Left
        lblResume.text = "Resume"
        lblResume.sizeToFit()
        lblResume.center = CGPoint(x: resumeButton.frame.width / 2, y: resumeButton.frame.height / 2)
        resumeButton.addSubview(lblResume)
        
        let restartButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: bottomBar.frame.height - 10))
        restartButton.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
        restartButton.center = CGPoint(x: resumeButton.center.x - restartButton.frame.width - 5, y: bottomBar.frame.height / 2)
        restartButton.addTarget(self, action: "restartGame:", forControlEvents: UIControlEvents.TouchUpInside)
        bottomBar.addSubview(restartButton)
        
        let lblRestart = UILabel()
        lblRestart.font = UIFont(name: ".SFUIText-Light", size: 14)
        lblRestart.textColor = UIColor.whiteColor()
        lblRestart.textAlignment = NSTextAlignment.Left
        lblRestart.text = "Restart"
        lblRestart.sizeToFit()
        lblRestart.center = CGPoint(x: restartButton.frame.width / 2, y: restartButton.frame.height / 2)
        restartButton.addSubview(lblRestart)
        
        let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: bottomBar.frame.height - 10))
        menuButton.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
        menuButton.center = CGPoint(x: restartButton.frame.width / 2 + 5, y: bottomBar.frame.height / 2)
        menuButton.addTarget(self, action: "returnHome:", forControlEvents: UIControlEvents.TouchUpInside)
        bottomBar.addSubview(menuButton)
        
        let lblMenu = UILabel()
        lblMenu.font = UIFont(name: ".SFUIText-Light", size: 14)
        lblMenu.textColor = UIColor.whiteColor()
        lblMenu.textAlignment = NSTextAlignment.Left
        lblMenu.text = "Home"
        lblMenu.sizeToFit()
        lblMenu.center = CGPoint(x: restartButton.frame.width / 2, y: restartButton.frame.height / 2)
        menuButton.addSubview(lblMenu)
        
        self.view!.addSubview(pauseMenu)
        
        
        
    }
    
    func pauseGame() {
        scaleNode.scene?.paused = true
        hudView.layer.speed = 0
        //scene!.view?.paused = true
    }
    
    func restartGame(sender: UIButton) {
        
        // Level Up if neccesary
        
        if GameState.sharedInstance.achievements == [1, 1, 1] {
            GameState.sharedInstance.levelUp()
        }
        
        // Resume Game
        
        scaleNode.scene?.paused = false
        hudView.layer.speed = 1.0
        
        // Remove scene
        
        scaleNode.removeAllChildren()
        
        hudNode.removeAllChildren()
        
        specialButton.removeFromParent()
        
        
        for view in hudView.subviews {
            
            view.removeFromSuperview()
            
        }
        
        hudView.removeFromSuperview()
        
        for view in pauseMenu.subviews {
            
            view.removeFromSuperview()
            
        }
        
        pauseMenu.removeFromSuperview()
        
        for view in gameOverView.subviews {
            
            view.removeFromSuperview()
            
        }
        
        gameOverView.removeFromSuperview()
        
        for view in self.view!.subviews {
            view.removeFromSuperview()
        }
        
        
        setSceneValues()
        createSceneContents()
    }
    
    func createStatsTable() -> UIView {
        
        let statsTable = UIView()
        let cellHeight = 30 as CGFloat
        let cellWidth = 400 as CGFloat
        let padding = 15 as CGFloat
        
        let titles = ["Highest Round", "Enemies Destroyed", "Coins Collected", "Max Combo", "Best Combo Score", "Total Score"]
        
        var results = [survivalRound, achievKillsTotal, achievCoins, achievComboMultiplier, achievComboScore, playerOneScore]

        var index = 0
        
        for title in titles {
            
            let cellBackground = UIView(frame: CGRect(x: 0, y: 0, width: cellWidth, height: cellHeight))
            cellBackground.center = CGPoint(x: 0, y: CGFloat(index) * cellHeight)
            
            if index % 2 == 0 {
                cellBackground.backgroundColor = UIColor(white: 0.0, alpha: 0.65)
            } else {
                cellBackground.backgroundColor = UIColor(white: 0.0, alpha: 0.45)
            }
            
            
            let titleText = title as String
            let resultsText = results[index] as Int
            
            let lblTitle = UILabel()
            lblTitle.font = UIFont(name: ".SFUIText-Normal", size: 12)
            lblTitle.textColor = UIColor.whiteColor()
            lblTitle.textAlignment = NSTextAlignment.Left
            lblTitle.text = titleText
            lblTitle.sizeToFit()
            lblTitle.center = CGPoint(x: padding + lblTitle.frame.width / 2, y: cellBackground.frame.height / 2)
            cellBackground.addSubview(lblTitle)
            
            let lblResults = UILabel()
            lblResults.font = UIFont(name: ".SFUIText-Light", size: 12)
            lblResults.textColor = UIColor.whiteColor()
            lblResults.textAlignment = NSTextAlignment.Right
            lblResults.text = String(resultsText)
            lblResults.sizeToFit()
            lblResults.center = CGPoint(x: cellBackground.frame.width - padding - lblResults.frame.width / 2, y: cellBackground.frame.height / 2)
            cellBackground.addSubview(lblResults)
            
            statsTable.addSubview(cellBackground)
            index++
            
            
        }
        
        
        return statsTable
        
        
        
    }
    
    func createAchievementView() -> UIView {
        let extraLength = 8 as CGFloat
        let rank = GameState.sharedInstance.level
        let lblIconImage = UIImage(named: "Rank Icon")! as UIImage
        
        let achievementView = UIView()
    
        let lblRank = UILabel()
        lblRank.font = UIFont(name: ".SFUIText-Bold", size: 24)
        lblRank.textColor = UIColor.whiteColor()
        lblRank.textAlignment = NSTextAlignment.Center
        lblRank.text = "Rank \(rank + 1)"
        lblRank.sizeToFit()
        lblRank.center = CGPoint(x: self.view!.frame.width / 2 + 10, y: self.view!.frame.height / 2 - 60)
        achievementView.addSubview(lblRank)
        
        let lblIconView = UIImageView(image: lblIconImage)
        lblIconView.center = CGPoint(x: lblRank.center.x - lblRank.frame.width / 2 - 20, y: lblRank.center.y)
        lblIconView.tintColor = UIColor.whiteColor()
        achievementView.addSubview(lblIconView)
        
        for index in 0...2 {
            let achievementOne = achievObjectives[index]
            
            let achievementOneText = achievementOne["Description"] as! String
            let achievementType = achievementOne["Type"] as! String
            let achievementAmount = achievementOne["Amount"] as! Double
            
            
            
            let lblAchieveOne = UILabel()
            lblAchieveOne.font = UIFont(name: ".SFUIText-Normal", size: 18)
            lblAchieveOne.textColor = UIColor.whiteColor()
            lblAchieveOne.textAlignment = NSTextAlignment.Center
            lblAchieveOne.text = achievementOneText
            
            
            let progress = achievementProgress(achievementType, amount: achievementAmount)
            
            if GameState.sharedInstance.achievements[index] == 0 && progress != 0 {
                
                lblAchieveOne.text = "\(achievementOneText) (\(Int(progress))%)"
            }
            
            lblAchieveOne.sizeToFit()
            lblAchieveOne.center = CGPoint(x: self.view!.frame.width / 2, y: lblRank.center.y + 40 + CGFloat(index) * 30)
            
            if GameState.sharedInstance.achievements[index] == 1 {
                let slash = UIView(frame: CGRect(x: 0, y: 0, width: lblAchieveOne.frame.width + extraLength, height: 2))
                slash.backgroundColor = UIColor.whiteColor()
                slash.center = CGPoint(x: slash.frame.width / 2 - extraLength / 2, y: lblAchieveOne.frame.height / 2)
                lblAchieveOne.addSubview(slash)
            }
            achievementView.sizeToFit()
            achievementView.addSubview(lblAchieveOne)
        }
        
        
        return achievementView
        
    }
    
    // Update - Stuff that happens 60 times a second
    
    override func update(currentTime: CFTimeInterval) {
        if gameOver {
            return
        }
        skipFrames++

        
        
        //update Player movement
        // to compute velocities we need delta time to multiply by points per second
        // SpriteKit returns the currentTime, delta is computed as last called time - currentTime
        
        let deltaTime = max(1.0/30, currentTime - lastUpdateTime)
        lastUpdateTime = currentTime
        
        updatePlayer(deltaTime)
        // Player Animation
        
        if skipFrames >= 10 {
            skipFrames = 0
            playerAnimation()
            homingEnemies()
            
        }
        
        
        cameraMovement()
        
        
    }
    
    func cameraMovement() {
        
        let mapLeft = 3390 as CGFloat
        let mapRight = 5040 as CGFloat
        let playerStartX = mapLeft + (mapRight - mapLeft) / 2 as CGFloat
        
        let offset = (player.position.x - playerStartX) / (((mapRight - mapLeft) / 2) / (self.view!.frame.width/2))
        //print(player.position.x - playerStartX)
        //print(((mapRight - mapLeft) / 2) / (self.view!.frame.width/2))
        //print(offset)
        
        foregroundNode.position.x = -player.position.x + offset
        midgroundNode.position.x = -player.position.x * 0.25 + playerStartX * 0.25 + offset * 0.25
        midgroundTwoNode.position.x = -player.position.x * 0.5 + playerStartX * 0.5 + offset * 0.5
        midgroundThreeNode.position.x = -player.position.x * 0.75 + playerStartX * 0.75 + offset * 0.75
    }
    
    override func didSimulatePhysics() {
        //didPlayerPassOverEnemy()
        //didPlayerPassUnderEnemy()
        
    }
    
    
    deinit {
        stopMonitoringAcceleration()
    }
    
    
    
    func updatePlayer(dt: CFTimeInterval) {
        
        if let acceleration = motionManager.accelerometerData?.acceleration {
            
            let FilterFactor = 0.75
            var accelerationY = Double()
            if acceleration.y < -0.25{
                accelerationY = -0.25
            } else if acceleration.y > 0.25 {
                accelerationY = 0.25
            } else {
                accelerationY = acceleration.y
            }
            accelerometerX = accelerationY * FilterFactor + accelerometerX * (1 - FilterFactor)
            
            playerAcceleration.dx = CGFloat(accelerometerX)
        }
        
        //Mulitply Acceleromater output by 1000
        let acceleration = playerAcceleration.dx * 3500
        
        if flickActivated == true {
            

            player.physicsBody?.velocity.dx = flickVelocity.dx * 14 + attributeJump * 1.5
            player.physicsBody?.velocity.dy = flickVelocity.dy * 14 + attributeJump * 1.5
            
            flickActivated = false
            
        } else {
            
            
            if UIDevice.currentDevice().orientation.rawValue == 3 {
                player.physicsBody?.velocity.dx = 0.95 * (player.physicsBody?.velocity.dx)! - (0.01 + attributeSpeed/100 * 0.7) * acceleration
            } else {
                player.physicsBody?.velocity.dx = 0.95 * (player.physicsBody?.velocity.dx)! - (0.01 + attributeSpeed/100 * 0.7) * -acceleration
            }
                
        }

        
    }
    
    
    
    func playerAnimation() {
        
        let eyes = player.childNodeWithName("eyes")
        let crop = player.childNodeWithName("crop")
        let bottom = crop!.childNodeWithName("bottom")
        let hair = crop!.childNodeWithName("hair")
        let pupils = player.childNodeWithName("pupils")
        if self.player.physicsBody?.velocity.dx < 0 {
            
            let moveRightEyes = SKAction.moveToX(-4, duration: 0.2)
            let moveRightPupils = SKAction.moveToX(-5, duration: 0.15)
            let moveRightHair = SKAction.moveToX(-2, duration: 0.25)
            let moveRightBottom = SKAction.moveToX(-2, duration: 0.25)
            eyes?.runAction(moveRightEyes)
            
            pupils?.runAction(moveRightPupils)
            
            hair?.runAction(moveRightHair)
            
            bottom?.runAction(moveRightBottom)
            
        } else {
            
            let moveLeftEyes = SKAction.moveToX(4, duration: 0.2)
            let moveLeftPupils = SKAction.moveToX(5, duration: 0.15)
            let moveLeftHair = SKAction.moveToX(2, duration: 0.25)
            let moveLeftBottom = SKAction.moveToX(2, duration: 0.25)
            eyes?.runAction(moveLeftEyes)
            pupils?.runAction(moveLeftPupils)
            hair?.runAction(moveLeftHair)
            bottom?.runAction(moveLeftBottom)
            
        }
        
        if self.player.physicsBody?.velocity.dy < 0 {
            let moveUpEyes = SKAction.moveToY(-4, duration: 0.35)
            let moveUpPupils = SKAction.moveToY(-5, duration: 0.3)
            let moveUpHair = SKAction.moveToY(6, duration: 0.4)
            let moveUpBottom = SKAction.moveToY(-22, duration: 0.4)
            let wait = SKAction.waitForDuration(0.2)
            eyes?.runAction(SKAction.sequence([wait, moveUpEyes]))
            pupils?.runAction(SKAction.sequence([wait, moveUpPupils]))
            hair?.runAction(SKAction.sequence([wait, moveUpHair]))
            bottom?.runAction(SKAction.sequence([wait, moveUpBottom]))
            
        } else {
            let moveDownEyes = SKAction.moveToY(4, duration: 0.35)
            let moveDownPupils = SKAction.moveToY(3, duration: 0.3)
            let moveDownHair = SKAction.moveToY(11, duration: 0.4)
            let moveDownBottom = SKAction.moveToY(-18, duration: 0.4)
            let wait = SKAction.waitForDuration(0.2)
            eyes?.runAction(SKAction.sequence([wait, moveDownEyes]))
            pupils?.runAction(SKAction.sequence([wait, moveDownPupils]))
            hair?.runAction(SKAction.sequence([wait, moveDownHair]))
            bottom?.runAction(SKAction.sequence([wait, moveDownBottom]))
            
        }
    }
    
    
    
    func homingEnemies() {
        foregroundNode.enumerateChildNodesWithName("enemy3*", usingBlock: {
            node, stop in
            if node.position.x < self.player.position.x {
                node.physicsBody?.velocity.dx = (node.physicsBody?.velocity.dx)! + (600 - (node.physicsBody?.velocity.dx)!) / 10
            } else {
                node.physicsBody?.velocity.dx = (node.physicsBody?.velocity.dx)! + (-600 - (node.physicsBody?.velocity.dx)!) / 10
            }
            
        })
    }
    
    func incrementCoins(amount: Int) {
        achievCoins++
        checkAchievement("achievCoins", subType: 0, amount: Double(achievCoins))
        
        GameState.updateCoins(amount)
        lblCoins.text = "\(GameState.sharedInstance.coins)"
        let fadeIn = SKAction.fadeInWithDuration(0.2)
        let wait = SKAction.waitForDuration(1.0)
        let fadeOut = SKAction.fadeOutWithDuration(1.0)
        lblCoins.runAction(SKAction.sequence([fadeIn, wait, fadeOut]))
        
        
    }
    
    func returnHome(sender: UIButton) {
        
        // 1
        if GameState.sharedInstance.achievements == [1, 1, 1] {
            GameState.sharedInstance.levelUp()
        }
        
        // Resume Game
        
        scaleNode.scene?.paused = false
        hudView.layer.speed = 1.0
        
        // Remove scene
        
        scaleNode.removeAllChildren()
        
        hudNode.removeAllChildren()
        
        specialButton.removeFromParent()
        
        
        
        for view in hudView.subviews {
            
            view.removeFromSuperview()
            
        }
        
        hudView.removeFromSuperview()
        
        for view in pauseMenu.subviews {
            
            view.removeFromSuperview()
            
        }
        
        pauseMenu.removeFromSuperview()
        
        for view in gameOverView.subviews {
            
            view.removeFromSuperview()
            
        }
        
        gameOverView.removeFromSuperview()
        
        
        
        NSNotificationCenter.defaultCenter().postNotificationName("returnHome", object: self)
    }
    
    func endGame() {
        // 1
        gameOver = true
        if GameState.sharedInstance.achievements == [1, 1, 1] {
            GameState.sharedInstance.levelUp()
        }
        // 2
        // Save stars and high score
        GameState.sharedInstance.saveState()
        
        // 3
        createGameOverMenu()
    }
    
    func addGlow(view: UIView, color: UIColor, size: CGFloat) {
        view.layer.shadowColor = color.CGColor
        view.layer.shadowRadius = view.frame.height * size
        view.layer.shadowOpacity = 0.9
        view.layer.shadowOffset = CGSizeZero
        view.layer.masksToBounds = false
        view.layer.shouldRasterize = false
    }
    
}



