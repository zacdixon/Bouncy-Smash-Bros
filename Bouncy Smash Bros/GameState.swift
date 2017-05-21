//
//  GameState.swift
//  Bouncy Smash Bros
//
//  Created by Zachary Dixon on 9/18/15.
//  Copyright © 2015 Zac Dixon. All rights reserved.
//

import Foundation
import SpriteKit


class GameState {
    var score: Int
    var highScore: Int
    var enemies: Int
    var level: Int
    var coins: Int
    var characterSelected: Int
    var achievements: Array <Int>
    var abilities: Array <Int>
    var activeAbilities: Array <Int>
    
    
    
    class var sharedInstance: GameState {
        struct Singleton {
            static let instance = GameState()
        }
        
        return Singleton.instance
    }
    
    init() {
        
        let levelPlist = NSBundle.mainBundle().pathForResource("GameInfo", ofType: "plist")
        let levelData = NSDictionary(contentsOfFile: levelPlist!)!
        let abilityList = levelData["Skills"] as! NSArray
        
        
        // Init
        score = 0
        highScore = 0
        enemies = 0
        level = 0
        coins = 0
        achievements = [0,0,0]
        characterSelected = 0
        
        abilities = []
        activeAbilities = []
        for _ in abilityList {
            abilities.append(0)
        }
        
        activeAbilities = [100,100,100]
        

        // Load game state
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        highScore = defaults.integerForKey("highScore")
        enemies = defaults.integerForKey("enemies")
        level = defaults.integerForKey("level")
        characterSelected = defaults.integerForKey("characterSelected")
        coins = defaults.integerForKey("coins")
        
        if defaults.objectForKey("achievements") != nil {
            achievements = defaults.objectForKey("achievements") as! Array <Int>
        }
        
        
        
        
        
        if defaults.objectForKey("abilities") != nil {
            abilities = defaults.objectForKey("abilities") as! Array <Int>
        }

        if defaults.objectForKey("activeAbilities") != nil {
            activeAbilities = defaults.objectForKey("activeAbilities") as! Array <Int>
        }
        
        
    }
    
    func saveState() {
        // Update highScore if the current score is greater
        highScore = max(score, highScore)
        
        // Store in user defaults
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(highScore, forKey: "highScore")
        defaults.setInteger(enemies, forKey: "enemies")
        
        
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func updateAchievements(achievement: Int) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        GameState.sharedInstance.achievements[achievement] = 1
        print(GameState.sharedInstance.achievements)
        defaults.setObject(GameState.sharedInstance.achievements, forKey: "achievements")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func updateCoins(coin: Int) {
        let defaults = NSUserDefaults.standardUserDefaults()
        GameState.sharedInstance.coins++
        print(GameState.sharedInstance.coins)
        defaults.setObject(GameState.sharedInstance.coins, forKey: "coins")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func chooseCharacter(character: Int) {
        let defaults = NSUserDefaults.standardUserDefaults()
        GameState.sharedInstance.characterSelected = character
        defaults.setObject(GameState.sharedInstance.characterSelected, forKey: "characterSelected")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func levelUp() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        level++
        print("Leveled up to level \(level)")
        let resetAchievements = [0,0,0]
        GameState.sharedInstance.achievements = resetAchievements
        defaults.setObject(GameState.sharedInstance.achievements, forKey: "achievements")
        defaults.setInteger(level, forKey: "level")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func saveActiveAbilities(index: Int, ability: Int) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        GameState.sharedInstance.activeAbilities[index] = ability
        print("Active Abilities \(GameState.sharedInstance.activeAbilities)")
        
        defaults.setObject(GameState.sharedInstance.activeAbilities, forKey: "activeAbilities")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func upgradeAbility(index: Int) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        GameState.sharedInstance.abilities[index] = GameState.sharedInstance.abilities[index] + 1
        
        defaults.setObject(GameState.sharedInstance.abilities, forKey: "abilities")
        NSUserDefaults.standardUserDefaults().synchronize()
        print("Abilities Purchases \(GameState.sharedInstance.abilities)")
    }
    
    func createHexagonPath(size: CGFloat) -> CGPath {
        
        let curPath = CGPathCreateMutable()
        let center = CGPoint(x: 0, y: 0)
        let point1 = CGPoint(x: center.x - sqrt(3)/2 * size, y: center.y - size/2.0)
        let point2 = CGPoint(x: center.x, y: center.y - size)
        let point3 = CGPoint(x: center.x + sqrt(3)/2*size, y: center.y - size/2)
        let point4 = CGPoint(x: center.x + sqrt(3)/2*size, y: center.y + size/2)
        let point5 = CGPoint(x: center.x, y: center.y + size)
        let point6 = CGPoint(x: center.x - sqrt(3)/2*size, y: center.y + size/2)
        CGPathMoveToPoint(curPath, nil, point1.x, point1.y)
        CGPathAddLineToPoint(curPath, nil, point2.x, point2.y)
        CGPathAddLineToPoint(curPath, nil, point3.x, point3.y)
        CGPathAddLineToPoint(curPath, nil, point4.x, point4.y)
        CGPathAddLineToPoint(curPath, nil, point5.x, point5.y)
        CGPathAddLineToPoint(curPath, nil, point6.x, point6.y)
        CGPathAddLineToPoint(curPath, nil, point1.x, point1.y)
        return curPath
    }
    
    func createArrowPath(height:CGFloat, left: Bool ) -> CGPath {
        let curPath = CGPathCreateMutable()
        let center = CGPoint(x: 0, y: 0)
        let point1 = CGPoint(x: center.x, y: center.y + height / 2)
        var point2 = CGPoint(x: center.x - height / 3, y: center.y)
        if left == false {
            point2 = CGPoint(x: center.x + height / 3, y: center.y)
        }
        let point3 = CGPoint(x: center.x, y: center.y - height / 2)
        CGPathMoveToPoint(curPath, nil, point1.x, point1.y)
        CGPathAddLineToPoint(curPath, nil, point2.x, point2.y)
        CGPathAddLineToPoint(curPath, nil, point3.x, point3.y)
        return curPath
    }
    
    func createTrianglePath(width:CGFloat) -> CGPath {
        let curPath = CGPathCreateMutable()
        let center = CGPoint(x: 0, y: 0)
        let point1 = CGPoint(x: center.x - width / 2, y: 0)
        let point2 = CGPoint(x: 0, y: -width / 2)
        let point3 = CGPoint(x: center.x + width / 2, y: 0)
        let point4 = CGPoint(x: center.x - width / 2, y: 0)
        CGPathMoveToPoint(curPath, nil, point1.x, point1.y)
        CGPathAddLineToPoint(curPath, nil, point2.x, point2.y)
        CGPathAddLineToPoint(curPath, nil, point3.x, point3.y)
        CGPathAddLineToPoint(curPath, nil, point4.x, point4.y)
        return curPath
    }
    
    
}

