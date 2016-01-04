//
//  GameViewController.swift
//  Bouncy Smash Bros
//
//  Created by Zachary Dixon on 9/12/15.
//  Copyright (c) 2015 Zac Dixon. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit
import Parse
import FBSDKCoreKit
import ParseFacebookUtilsV4
import Foundation
import QuartzCore

let white = UIColor(colorLiteralRed: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
let whiteAlpha = UIColor(colorLiteralRed: 1.0, green: 1.0, blue: 1.0, alpha: 0.25)
let black = UIColor(colorLiteralRed: 5/215, green: 31/255, blue: 77/255, alpha: 1.0)
let grey = UIColor(colorLiteralRed: 198/255, green: 216/255, blue: 223/255, alpha: 1.0)
let lightBlack = UIColor(colorLiteralRed: 20/215, green: 56/255, blue: 108/255, alpha: 1.0)
let darkBlue = UIColor(colorLiteralRed: 0/255, green: 88/255, blue: 149/255, alpha: 1.0)
let darkBlueAlpha = UIColor(colorLiteralRed: 0/255, green: 88/255, blue: 149/255, alpha: 0.25)
let blue = UIColor(colorLiteralRed: 0.2431, green: 0.7686, blue: 1.0, alpha: 1.0)
let blueDeep = UIColor(colorLiteralRed: 0/255, green: 133/255, blue: 213/255, alpha: 1.0)
let yellow = UIColor(colorLiteralRed: 0.988, green: 0.8784, blue: 0.2196, alpha: 1.0)
let red = UIColor(colorLiteralRed: 233/255, green: 74/255, blue: 81/255, alpha: 1.0)
let orange = UIColor(colorLiteralRed: 249/255, green: 136/255, blue: 81/255, alpha: 1.0)
let green = UIColor(colorLiteralRed: 59/255, green: 210/255, blue: 81/255, alpha: 1.0)
let purple = UIColor(colorLiteralRed: 167/255, green: 80/255, blue: 210/255, alpha: 1.0)
let pink = UIColor(colorLiteralRed: 254/255, green: 92/255, blue: 210/255, alpha: 1.0)
var spacing = 15 as CGFloat

let cornerRadius = 5 as CGFloat

class GameViewController: UIViewController, UIScrollViewDelegate {
    
    let splashScreen = UIView()
    let mainMenu = UIView()
    var mainMenuGradient = CALayer()
    var bottomBar = UIView()
    let bottomMenu = UIView()
    var blackFadeButton = UIButton()
    let levelScrollView = UIScrollView()
    var levelSelection = UIView()
    var levelButtonArray: Array<UIView> = []
    var characterButtonArray: Array<UIButton> = []
    var levelScrollViewIsScrolling = false
    let arrowLeft = CAShapeLayer()
    let arrowRight = CAShapeLayer()
    var backButton = UIButton()
    var playerButton = UIButton()
    var playerIconView = UIImageView()
    let playerSelectionView = UIView()
    var abilityButton = UIButton()
    var abilitySelectionView = UIView()
    var abilitySelectionScrollView = UIScrollView()
    var abilitySelectionUIView = UIView()
    var abilityDetailView = UIView()
    var abilityButtonArray: Array<UIButton> = []
    var abilityActiveButtonsArray: Array<UIButton> = []
    var abilityEquipButton = UIButton()
    var abilityFullDarkBG = UIButton()
    var fbButton = UIButton()
    var popUpView = UIView()
    let edgeSpace = 10 as CGFloat
    
    var blur = UIVisualEffectView()
    var popUpWidth = CGFloat()
    var popUpHeight = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skScene = self.view as! SKView
        
        skScene.showsFPS = true
        skScene.showsNodeCount = true
        skScene.showsDrawCount = true
        
        popUpWidth = self.view.frame.width / 2
        popUpHeight = self.view.frame.height - self.view.frame.height / 4
        spacing = 0.0225 * self.view.frame.width as CGFloat
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "createMenu", name: "returnHome", object: nil)
        
        createSplashScreen()
        
    }
    
    func createSplashScreen() {
        
        
        splashScreen.userInteractionEnabled = true
        splashScreen.frame = view.frame
        splashScreen.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(splashScreen)
        
        /*
        let lblHighScore = UILabel(frame: CGRectMake(0, 0, 500, 100))
        lblHighScore.font = UIFont(name: ".SFUIText-Bold", size: 50)
        lblHighScore.textColor = black
        lblHighScore.center = CGPointMake(self.view.frame.width / 2, self.view.frame.height / 2 - 50)
        lblHighScore.textAlignment = NSTextAlignment.Center
        //lblHighScore.text = "Bouncy Smash"
        */
        
        let testLabel = textColorAnimation("Bouncy Smash", fontName: ".SFUIText-Bold", width: self.view.frame.width * 0.75, height: self.view.frame.height * 0.2, colorOne: black, colorTwo: red, colorThree: blue)
        testLabel.center = CGPointMake(self.view.frame.width / 2, self.view.frame.height / 2 - 20)
        splashScreen.addSubview(testLabel)
        
        let buttonPlay = UIButton(frame: CGRectMake(0, 0, 200, 100))
        buttonPlay.backgroundColor = UIColor.clearColor()
        buttonPlay.center = CGPointMake(self.view.frame.width / 2, self.view.frame.height / 2 + 20)
        buttonPlay.setTitle("Tap to Play", forState: UIControlState.Normal)
        buttonPlay.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        buttonPlay.addTarget(self, action: "removeSplashScreen:", forControlEvents: UIControlEvents.TouchUpInside)
        splashScreen.addSubview(buttonPlay)
        
    }
    
    func removeSplashScreen(sender:UIButton!) {
        
        for view in splashScreen.subviews {
            view.removeFromSuperview()
        }
        splashScreen.removeFromSuperview()
        
        createMenu()
    }
    
    func createMenu() {
        
        resetMainMenu()
        
        self.view.addSubview(mainMenu)
        mainMenu.frame = view.frame
        mainMenu.backgroundColor = UIColor.clearColor()
        mainMenuGradient.removeFromSuperlayer()
        mainMenu.layer.insertSublayer(mainMenuGradient, atIndex: 0)
        
        bottomBar = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height * 0.15))
        bottomBar.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height - bottomBar.frame.height / 2)
        bottomBar.backgroundColor = UIColor.clearColor()
        mainMenu.addSubview(bottomBar)
        
        // Create Back Button
        
        
        backButton = UIButton(frame: CGRectMake(0, 0, bottomBar.frame.height * 0.6, bottomBar.frame.height * 0.6))
        backButton.backgroundColor = UIColor.clearColor()
        backButton.setBackgroundImage(UIImage.imageWithColor(whiteAlpha), forState: .Normal)
        backButton.setBackgroundImage(UIImage.imageWithColor(darkBlue), forState: .Highlighted)
        backButton.center = CGPointMake(spacing + backButton.frame.width / 2, bottomBar.frame.height / 2)
        backButton.addTarget(self, action: "backToSplash:", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.layer.cornerRadius = cornerRadius
        backButton.userInteractionEnabled = true
        backButton.clipsToBounds = true
        
        bottomBar.addSubview(backButton)
        
        let backIconImage = UIImage(named: "Back Icon")! as UIImage
        let backIconView = UIImageView(image: backIconImage)
        backIconView.center = CGPoint(x: backButton.frame.width / 2, y: backButton.frame.height / 2)
        backButton.addSubview(backIconView)
        
        // Create Settings Button
        
        
        let settingsButton = UIButton(frame: CGRectMake(0, 0, bottomBar.frame.height * 0.6, bottomBar.frame.height * 0.6))
        settingsButton.backgroundColor = UIColor.clearColor()
        settingsButton.setBackgroundImage(UIImage.imageWithColor(whiteAlpha), forState: .Normal)
        settingsButton.setBackgroundImage(UIImage.imageWithColor(darkBlue), forState: .Highlighted)
        settingsButton.center = CGPointMake(bottomBar.frame.width - settingsButton.frame.width / 2 - spacing, bottomBar.frame.height / 2)
        settingsButton.addTarget(self, action: "backToSplash:", forControlEvents: UIControlEvents.TouchUpInside)
        settingsButton.userInteractionEnabled = true
        settingsButton.layer.cornerRadius = cornerRadius
        settingsButton.clipsToBounds = true
        bottomBar.addSubview(settingsButton)
        
        let settingsIconImage = UIImage(named: "Settings Icon")! as UIImage
        let settingsIconView = UIImageView(image: settingsIconImage)
        settingsIconView.center = CGPoint(x: settingsButton.frame.width / 2, y: settingsButton.frame.height / 2)
        settingsButton.addSubview(settingsIconView)
        
        // Create Stats Button
        let statsButton = UIButton(frame: CGRectMake(0, 0, bottomBar.frame.height * 0.6, bottomBar.frame.height * 0.6))
        statsButton.backgroundColor = UIColor.clearColor()
        statsButton.setBackgroundImage(UIImage.imageWithColor(whiteAlpha), forState: .Normal)
        statsButton.setBackgroundImage(UIImage.imageWithColor(darkBlue), forState: .Highlighted)
        statsButton.center = CGPointMake(settingsButton.center.x - statsButton.frame.width - spacing, bottomBar.frame.height / 2)
        statsButton.addTarget(self, action: "backToSplash:", forControlEvents: UIControlEvents.TouchUpInside)
        statsButton.userInteractionEnabled = true
        statsButton.layer.cornerRadius = cornerRadius
        statsButton.clipsToBounds = true
        bottomBar.addSubview(statsButton)
        
        let statsIconImage = UIImage(named: "Stats Icon")! as UIImage
        let statsIconView = UIImageView(image: statsIconImage)
        statsIconView.center = CGPoint(x: statsButton.frame.width / 2, y: statsButton.frame.height / 2)
        statsButton.addSubview(statsIconView)
        
        // Create Bottom Bar Background
        
        let bottomBarBG = UIView(frame: self.view.frame)
        bottomBarBG.backgroundColor = darkBlue
        bottomBarBG.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2 + bottomBar.frame.height)
        bottomBar.addSubview(bottomBarBG)
        
        
        // Create Ability Tab
        
        let tabOffset = 4 as CGFloat
        let numberOfButtons = 2 as CGFloat
        let activeAbilitiesArray = GameState.sharedInstance.activeAbilities
        let abilityTabButtonWidth = spacing * CGFloat(activeAbilitiesArray.count) + spacing * 2 * CGFloat(activeAbilitiesArray.count)
        
        
        
        abilityButton = UIButton(frame: CGRectMake(0, 0, abilityTabButtonWidth, bottomBar.frame.height + tabOffset))
        abilityButton.backgroundColor = whiteAlpha
        abilityButton.center = CGPoint(x:bottomBar.frame.width / 2 + bottomBar.frame.height / 2 + spacing * 0.5, y: self.view.frame.height - bottomBar.frame.height / 2 + tabOffset / 2)
        abilityButton.addTarget(self, action: "revealBottomMenu:", forControlEvents: UIControlEvents.TouchUpInside)
        abilityButton.tag = 2
        abilityButton.userInteractionEnabled = true
        abilityButton.layer.cornerRadius = cornerRadius
        mainMenu.addSubview(abilityButton)
        
        
        let levelPlist = NSBundle.mainBundle().pathForResource("GameInfo", ofType: "plist")
        let levelData = NSDictionary(contentsOfFile: levelPlist!)!
        let abilityList = levelData["Skills"] as! NSArray
        let levelList = levelData["Levels"] as! NSArray
        
        
        var activeAbilityIndex = 0 as CGFloat
        
        
        for ability in activeAbilitiesArray{
            if ability == 100 {
                
                let abilityCircle = createEmptyAbilityButton()
                abilityCircle.center = CGPoint(x: spacing * (activeAbilityIndex + 1) + (activeAbilityIndex + 1) * abilityCircle.frame.height / 2 + spacing * activeAbilityIndex / 2, y: abilityButton.frame.height / 2)
                abilityCircle.userInteractionEnabled = false
                
                abilityActiveButtonsArray.append(abilityCircle)
                
                abilityButton.addSubview(abilityActiveButtonsArray[Int(activeAbilityIndex)])
            } else {
                
                let abilityDict = abilityList[ability] as! NSDictionary
                let abilityTitle = abilityDict["Title"] as! String
                let abilityColor = abilityDict["Color"] as! String
                
                let iconBG = UIButton(frame: CGRect(x: 0, y: 0, width: spacing * 2, height: spacing * 2))
                iconBG.backgroundColor = getColor(abilityColor)
                iconBG.layer.cornerRadius = spacing
                iconBG.tag = ability
                iconBG.center = CGPoint(x: spacing * (activeAbilityIndex + 1) + (activeAbilityIndex + 1) * iconBG.frame.height / 2 + spacing * activeAbilityIndex / 2, y: abilityButton.frame.height / 2)
                iconBG.userInteractionEnabled = false
                
                if let iconImage = UIImage(named: "\(abilityTitle) Icon") {
                    let iconImageView = UIImageView(image: iconImage)
                    iconImageView.userInteractionEnabled = false
                    iconImageView.center = CGPoint(x: iconBG.bounds.width / 2, y: iconBG.bounds.height / 2)
                    iconBG.addSubview(iconImageView)
                    
                }
                
                abilityActiveButtonsArray.append(iconBG)
                
                abilityButton.addSubview(abilityActiveButtonsArray[Int(activeAbilityIndex)])
                
            }
            
            activeAbilityIndex++
        }
        
        
        
        // Create Player Tab
        
        playerButton = UIButton(frame: CGRectMake(0, 0, bottomBar.frame.height, bottomBar.frame.height + tabOffset))
        playerButton.backgroundColor = whiteAlpha
        playerButton.center = CGPointMake(bottomBar.frame.width / 2 - abilityButton.frame.width / 2 - spacing * 0.5, bottomBar.frame.height / 2 + tabOffset / 2)
        playerButton.addTarget(self, action: "revealBottomMenu:", forControlEvents: UIControlEvents.TouchUpInside)
        playerButton.tag = 1
        playerButton.userInteractionEnabled = true
        playerButton.layer.cornerRadius = cornerRadius
        bottomBar.addSubview(playerButton)
        
        let playerIconImage = UIImage(named: "Character \(GameState.sharedInstance.characterSelected + 1) Icon")! as UIImage
        playerIconView = UIImageView(image: playerIconImage)
        playerIconView.center = CGPoint(x: playerButton.frame.width / 2, y: playerButton.frame.height / 2 - tabOffset / 2)
        playerButton.addSubview(playerIconView)
        
        let buttonWidth = self.view.frame.width * 0.75
        let buttonHeight = self.view.frame.height * 0.64
        
        
        // Create Coin Label
        
        let coinImage = UIImage(named: "Coin Icon")! as UIImage
        
        let coins = GameState.sharedInstance.coins
        
        
        let lblCoins = UILabel(frame: CGRect(x: 0, y: 0, width: spacing * 5, height: spacing * 1.5))
        
        lblCoins.text = "\(coins)"
        
        lblCoins.font = optimisedfindAdaptiveFontWithName("EncodeSansNarrow-Regular", label: lblCoins, minSize: 5, maxSize: 50)
        lblCoins.textAlignment = .Left
        lblCoins.textColor = darkBlue
        lblCoins.sizeToFit()
        
        let coinImageView = UIImageView(image: coinImage)
        addGlow(coinImageView, size: 0.1)
        
        let coinsViewMiddle = (abilityButton.center.x + abilityButton.frame.width / 2 + statsButton.center.x - statsButton.frame.width / 2) / 2
        
        let coinsView = centerViews(coinImageView, viewTwo: lblCoins, spacing: spacing / 2)
        coinsView.center = CGPoint(x: coinsViewMiddle, y: bottomBar.frame.height / 2)
        bottomBar.addSubview(coinsView)
        
        
        //coinImageView.center = CGPoint(x: coinImageView.frame.width / 2, y: coinsView.frame.height / 2)
        //lblCoins.center = CGPoint(x: coinImageView.center.x + coinImageView.frame.width / 2 + lblCoins.frame.width / 2, y: coinImageView.center.y)
        
        // Create Rank Label
        
        let rankImage = UIImage(named: "Rank Icon")! as UIImage
        
        let rank = GameState.sharedInstance.level
        
        let rankView = UIView()
        
        
        let lblRank = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: spacing * 1.5))
        lblRank.text = "Rank \(rank + 1)"
        lblRank.font = optimisedfindAdaptiveFontWithName("EncodeSansNarrow-Regular", label: lblRank, minSize: 5, maxSize: 50)
        lblRank.textAlignment = .Left
        lblRank.textColor = darkBlue
        lblRank.sizeToFit()
        rankView.addSubview(lblRank)
        
        let iconImageView = UIImageView(image: rankImage)
        
        iconImageView.backgroundColor = darkBlue
        iconImageView.layer.cornerRadius = iconImageView.frame.width / 2
        rankView.addSubview(iconImageView)
        
        let rankViewMiddle = (backButton.center.x + backButton.frame.width / 2 + playerButton.center.x - playerButton.frame.width / 2) / 2
        
        rankView.frame = CGRect(x: 0, y: 0, width: iconImageView.frame.width + lblRank.frame.width + spacing / 2, height: bottomBar.frame.height * 0.6)
        rankView.center = CGPoint(x: rankViewMiddle, y: bottomBar.frame.height / 2)
        bottomBar.addSubview(rankView)
        
        
        iconImageView.center = CGPoint(x: iconImageView.frame.width / 2, y: rankView.frame.height / 2)
        lblRank.center = CGPoint(x: iconImageView.center.x + iconImageView.frame.width / 2 + spacing / 2 + lblRank.frame.width / 2, y: iconImageView.center.y)

        
        // Create Levels Button
        
        levelSelection = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: buttonHeight))
        levelSelection.center = CGPoint(x: self.view.frame.width / 2, y: (self.view.frame.height - bottomBar.frame.height) / 2)
        mainMenu.addSubview(levelSelection)
        
        
        
        
        // Create Scroll Buttons
        
        let scrollLevelLeftButton = UIButton()
        scrollLevelLeftButton.frame = CGRect(x: 0, y: 0, width: (self.view.frame.width - buttonWidth) / 2, height: buttonHeight)
        scrollLevelLeftButton.center = CGPoint(x: scrollLevelLeftButton.frame.width / 2, y: levelSelection.frame.height / 2)
        scrollLevelLeftButton.tag = 1
        scrollLevelLeftButton.addTarget(self, action: "levelSelectorNextPage:", forControlEvents: UIControlEvents.TouchUpInside)
        levelSelection.addSubview(scrollLevelLeftButton)
        
        let scrollLevelRightButton = UIButton()
        scrollLevelRightButton.frame = CGRect(x: 0, y: 0, width: (self.view.frame.width - buttonWidth) / 2, height: buttonHeight)
        scrollLevelRightButton.center = CGPoint(x: levelSelection.frame.width - scrollLevelLeftButton.frame.width / 2, y: levelSelection.frame.height / 2)
        scrollLevelRightButton.tag = 2
        scrollLevelRightButton.addTarget(self, action: "levelSelectorNextPage:", forControlEvents: UIControlEvents.TouchUpInside)
        levelSelection.addSubview(scrollLevelRightButton)
        
        // Create Arrows
        
        let leftArrowPath = GameState.sharedInstance.createArrowPath(spacing, left: true)
        arrowLeft.path = leftArrowPath
        arrowLeft.lineCap = "round"
        arrowLeft.fillColor = UIColor.clearColor().CGColor
        arrowLeft.position = CGPoint(x: levelSelection.frame.width / 2 - buttonWidth / 2 - spacing * 2, y: levelSelection.frame.height / 2)
        arrowLeft.strokeColor = UIColor.redColor().CGColor
        arrowLeft.lineWidth = 3
        levelSelection.layer.addSublayer(arrowLeft)
        
        let rightArrowPath = GameState.sharedInstance.createArrowPath(spacing, left: false)
        arrowRight.path = rightArrowPath
        arrowRight.lineCap = "round"
        arrowRight.fillColor = UIColor.clearColor().CGColor
        arrowRight.position = CGPoint(x: levelSelection.frame.width / 2 + buttonWidth / 2 + spacing * 2, y: levelSelection.frame.height / 2)
        arrowRight.strokeColor = UIColor.redColor().CGColor
        arrowRight.lineWidth = 3
        levelSelection.layer.addSublayer(arrowRight)
        
        levelScrollView.pagingEnabled = true
        levelScrollView.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
        levelScrollView.clipsToBounds = false
        levelScrollView.center = CGPoint(x: levelSelection.frame.width / 2, y: levelSelection.frame.height / 2)
        levelScrollView.showsHorizontalScrollIndicator = false
        levelScrollView.contentSize = CGSize(width: buttonWidth * CGFloat(levelList.count), height: buttonHeight)
        levelScrollView.delegate = self
        levelSelection.addSubview(levelScrollView)
        
        
        let levelScrollUIView = UIView()
        levelScrollUIView.frame = CGRect(x: 0, y: 0, width: buttonWidth * CGFloat(levelList.count), height: buttonHeight)
        levelScrollUIView.center = CGPoint(x: levelScrollUIView.frame.width / 2, y: levelScrollView.frame.height / 2)
        levelScrollUIView.backgroundColor = UIColor.clearColor()
        levelScrollView.addSubview(levelScrollUIView)
        
        
        //Create Level Buttons
        
        for var index = 0; index < levelList.count; ++index {
            
            
            let xPosition = buttonWidth * CGFloat(index) + buttonWidth / 2
            
            let levelButton = createLevelButton(CGPoint(x: xPosition, y: levelScrollUIView.frame.height / 2), width: buttonWidth, height: buttonHeight, levelNumber: index) as UIView
            
            if index == 0 {
                
            } else {
                levelButton.transform = CGAffineTransformMakeScale(0.75, 0.75)
            }
            
    
            levelButtonArray.append(levelButton)
            
            levelScrollUIView.addSubview(levelButtonArray[index])
            
        }
        // Make sure the buttons are the correct size
        
        setLevelScrollValues()
        
        
        // Create Player Selection View
        
        playerSelectionView.frame = self.view.frame
        playerSelectionView.backgroundColor = darkBlue
        playerSelectionView.center = CGPoint(x: self.view.frame.width / 2, y: playerSelectionView.frame.height + playerSelectionView.frame.height / 2)
        mainMenu.addSubview(playerSelectionView)
        
        let characterList = levelData["Characters"] as! NSArray
        var characterButtonWidth = self.view.frame.width / 4 as CGFloat
        if characterButtonWidth < 160 {
            characterButtonWidth = 160
        }
        let characterButtonHeight = playerSelectionView.frame.height - bottomBar.frame.height - spacing * 3
        
        // Create Player Scroll View
        
        let playerSelectionScrollView = UIScrollView()
        playerSelectionScrollView.frame = CGRect(x: 0, y: 0, width: playerSelectionView.frame.width, height: playerSelectionView.frame.height - bottomBar.frame.height - spacing)
        playerSelectionScrollView.center = CGPoint(x: playerSelectionScrollView.frame.width / 2, y: playerSelectionScrollView.frame.height / 2)
        playerSelectionScrollView.contentSize = CGSize(width: characterButtonWidth * CGFloat(characterList.count) + spacing * (CGFloat(characterList.count) + 1), height: playerSelectionScrollView.frame.height)
        playerSelectionView.addSubview(playerSelectionScrollView)
        
        
        // Create UIView inside of the Scroll View to contain the Player Option buttons
        
        let playerSelectionUIView = UIView()
        playerSelectionUIView.frame = CGRect(x: 0, y: 0, width: characterButtonWidth * CGFloat(characterList.count) + spacing * (CGFloat(characterList.count) + 1), height: playerSelectionScrollView.frame.height)
        playerSelectionScrollView.addSubview(playerSelectionUIView)
        
        // Create Character Buttons
        
        for var index = 0; index < characterList.count; ++index {
            let xPosition = characterButtonWidth * CGFloat(index) + spacing * CGFloat(index) + characterButtonWidth / 2 + spacing
            let characterButton = createCharacterOptionButton(CGPoint(x: xPosition, y: playerSelectionScrollView.frame.height / 2), width: characterButtonWidth, height: characterButtonHeight, index: index)
            
            characterButtonArray.append(characterButton)
            
            playerSelectionUIView.addSubview(characterButtonArray[index])
        }
        
        // Create Ability Selection View
        abilitySelectionView.removeFromSuperview()
        abilitySelectionView.frame = self.view.frame
        abilitySelectionView.center = CGPoint(x: self.view.frame.width / 2, y: abilitySelectionView.frame.height + abilitySelectionView.frame.height / 2)
        mainMenu.addSubview(abilitySelectionView)
        
        
        let abilityButtonHeight = self.view.frame.height * 0.32
        let abilityButtonWidth = self.view.frame.width * 0.2
        let abilityCount = CGFloat(abilityList.count)
        let abilityScrollContentWidth = abilityButtonWidth * abilityCount + spacing / 2 * (abilityCount + 1)
        
        
        // Create Player Scroll View
        abilitySelectionScrollView.removeFromSuperview()
        abilitySelectionScrollView = UIScrollView()
        abilitySelectionScrollView.frame = CGRect(x: 0, y: 0, width: abilitySelectionView.frame.width, height: abilityButtonHeight + spacing)
        abilitySelectionScrollView.center = CGPoint(x: abilitySelectionScrollView.frame.width / 2, y: self.view.frame.height - abilitySelectionScrollView.frame.height)
        abilitySelectionScrollView.contentSize = CGSize(width: abilityScrollContentWidth, height: abilityButtonHeight + spacing)
        abilitySelectionView.addSubview(abilitySelectionScrollView)
        //abilitySelectionScrollView.backgroundColor = yellow
        
        // Create UIView inside of the Scroll View to contain the Ability Option buttons
        
        
        abilitySelectionUIView.frame = CGRect(x: 0, y: 0, width: abilityScrollContentWidth, height: abilityButtonHeight + spacing)
        abilitySelectionScrollView.addSubview(abilitySelectionUIView)
        
        
        // Create Ability Buttons
        
        for var index = 0; index < abilityList.count; ++index {
            let abilityButton = createAbilityButton(index)
            abilityButtonArray.append(abilityButton)
            
            abilitySelectionUIView.addSubview(abilityButtonArray[index])
        }
        
        // Create Selected Ability View
        
        let selectedAbilityIndex = GameState.sharedInstance.activeAbilities.minElement()
        
        if selectedAbilityIndex == 100 {
            abilityDetailView = createSelectedAbilityView(0)
            
            abilitySelectionView.addSubview(abilityDetailView)
            
            let button = abilityButtonArray[0]
            
            button.layer.borderColor = yellow.CGColor
            button.layer.borderWidth = 3
            
        } else {
            abilityDetailView = createSelectedAbilityView(selectedAbilityIndex!)
            abilitySelectionView.addSubview(abilityDetailView)
            
            let button = abilityButtonArray[selectedAbilityIndex!]
            
            button.layer.borderColor = yellow.CGColor
            button.layer.borderWidth = 3
        }
        
        
        
        
    }
    
    func backToSplash(sender:UIButton!) {
        
        resetMainMenu()
        
        createSplashScreen()
    }
    
    func resetMainMenu() {
        
        playerIconView = UIImageView()
        for view in mainMenu.subviews {
            view.removeFromSuperview()
        }
        mainMenu.removeFromSuperview()
        mainMenuGradient.removeFromSuperlayer()
        
        for view in levelScrollView.subviews {
            view.removeFromSuperview()
        }
        levelScrollView.removeFromSuperview()
        
        for view in levelSelection.subviews {
            view.removeFromSuperview()
        }
        levelSelection.removeFromSuperview()
        
        for view in playerSelectionView.subviews {
            view.removeFromSuperview()
        }
        playerSelectionView.removeFromSuperview()
        
        for view in abilitySelectionView.subviews {
            view.removeFromSuperview()
        }
        abilitySelectionView.removeFromSuperview()
        
        levelScrollViewIsScrolling = false
        
        levelButtonArray = []
        characterButtonArray = []
        
        
        
        for abilityButton in abilityButtonArray {
            for view in abilityButton.subviews {
                view.removeFromSuperview()
            }
            abilityButton.removeFromSuperview()
        }
        
        abilityButtonArray = []

        
        abilityActiveButtonsArray = []
        
        
    }
    
    func revealBottomMenu(sender: UIButton) {
        
        if sender.tag == 1 {
            self.playerSelectionView.center.x = self.view.frame.width / 2
            self.abilitySelectionView.center.x = self.abilitySelectionView.frame.width * 1.5
            
            self.playerButton.backgroundColor = darkBlue
            
            self.playerButton.removeTarget(self, action: "revealBottomMenu:", forControlEvents: UIControlEvents.TouchUpInside)
            self.playerButton.addTarget(self, action: "removeBottomMenu:", forControlEvents: UIControlEvents.TouchUpInside)
            
            self.abilityButton.removeTarget(self, action: "revealBottomMenu:", forControlEvents: UIControlEvents.TouchUpInside)
            self.abilityButton.addTarget(self, action: "switchBottomMenu:", forControlEvents: UIControlEvents.TouchUpInside)
            
        } else if sender.tag == 2 {
            self.playerSelectionView.center.x = -self.levelScrollView.frame.width
            self.abilitySelectionView.center.x = self.view.frame.width / 2
            
            self.abilityButton.backgroundColor = darkBlue
            
            self.abilityButton.removeTarget(self, action: "revealBottomMenu:", forControlEvents: UIControlEvents.TouchUpInside)
            self.abilityButton.addTarget(self, action: "removeBottomMenu:", forControlEvents: UIControlEvents.TouchUpInside)
            
            self.playerButton.removeTarget(self, action: "revealBottomMenu:", forControlEvents: UIControlEvents.TouchUpInside)
            self.playerButton.addTarget(self, action: "switchBottomMenu:", forControlEvents: UIControlEvents.TouchUpInside)
        }
        
        self.backButton.removeTarget(self, action: "backToSplash:", forControlEvents: UIControlEvents.TouchUpInside)
        self.backButton.addTarget(self, action: "removeBottomMenu:", forControlEvents: UIControlEvents.TouchUpInside)
        
        UIView.animateWithDuration(0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [.CurveEaseInOut], animations: {
            self.bottomBar.center.y = self.bottomBar.frame.height / 2 + spacing
            self.levelSelection.center.y = -self.levelScrollView.frame.height
            self.playerSelectionView.center.y = self.bottomBar.frame.height + spacing + self.playerSelectionView.frame.height / 2
            self.abilitySelectionView.center.y = self.bottomBar.frame.height + spacing + self.abilitySelectionView.frame.height / 2
            self.abilityButton.center.y = self.bottomBar.frame.height / 2 + spacing
            
            }, completion: nil)
        
        UIView.animateWithDuration(0.7, delay: 0.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [.CurveEaseInOut], animations: {
            self.backButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
            
            }, completion: nil)
        
        
    }
    
    func removeBottomMenu(sender:UIButton) {
        
        self.playerButton.backgroundColor = whiteAlpha
        self.abilityButton.backgroundColor = whiteAlpha
        
        self.backButton.removeTarget(self, action: "removeBottomMenu:", forControlEvents: UIControlEvents.TouchUpInside)
        self.backButton.addTarget(self, action: "backToSplash:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.playerButton.removeTarget(self, action: "removeBottomMenu:", forControlEvents: UIControlEvents.TouchUpInside)
        self.playerButton.addTarget(self, action: "revealBottomMenu:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.abilityButton.removeTarget(self, action: "removeBottomMenu:", forControlEvents: UIControlEvents.TouchUpInside)
        self.abilityButton.addTarget(self, action: "revealBottomMenu:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.playerButton.removeTarget(self, action: "switchBottomMenu:", forControlEvents: UIControlEvents.TouchUpInside)
        self.playerButton.addTarget(self, action: "revealBottomMenu:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.abilityButton.removeTarget(self, action: "switchBottomMenu:", forControlEvents: UIControlEvents.TouchUpInside)
        self.abilityButton.addTarget(self, action: "revealBottomMenu:", forControlEvents: UIControlEvents.TouchUpInside)
        
        UIView.animateWithDuration(0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [.CurveEaseInOut], animations: {
            self.bottomBar.center.y = self.view.frame.height - self.bottomBar.frame.height / 2
            self.levelSelection.center.y = (self.view.frame.height - self.bottomBar.frame.height) / 2
            self.playerSelectionView.center.y = self.playerSelectionView.frame.height + self.playerSelectionView.frame.height / 2
            self.abilitySelectionView.center.y = self.abilitySelectionView.frame.height + self.abilitySelectionView.frame.height / 2
            self.abilityButton.center.y = self.view.frame.height - self.bottomBar.frame.height / 2
            }, completion: nil)
        
        UIView.animateWithDuration(0.7, delay: 0.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [.CurveEaseInOut], animations: {
            self.backButton.transform = CGAffineTransformMakeRotation(CGFloat(0))
            
            }, completion: nil)
    }
    
    
    func switchBottomMenu(sender: UIButton) {
        
        if sender.tag == 1 {
            
            self.playerButton.backgroundColor = darkBlue
            self.abilityButton.backgroundColor = whiteAlpha
            
            self.playerButton.removeTarget(self, action: "switchBottomMenu:", forControlEvents: UIControlEvents.TouchUpInside)
            self.playerButton.addTarget(self, action: "removeBottomMenu:", forControlEvents: UIControlEvents.TouchUpInside)
            
            self.abilityButton.removeTarget(self, action: "removeBottomMenu:", forControlEvents: UIControlEvents.TouchUpInside)
            self.abilityButton.addTarget(self, action: "switchBottomMenu:", forControlEvents: UIControlEvents.TouchUpInside)
            
            UIView.animateWithDuration(0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [.CurveEaseInOut], animations: {
                
                self.playerSelectionView.center.x = self.view.frame.width / 2
                self.abilitySelectionView.center.x = self.abilitySelectionView.frame.width * 1.5
                
                }, completion: nil)
            
        } else if sender.tag == 2 {
            self.playerButton.backgroundColor = whiteAlpha
            self.abilityButton.backgroundColor = darkBlue
            
            self.abilityButton.removeTarget(self, action: "switchBottomMenu:", forControlEvents: UIControlEvents.TouchUpInside)
            self.abilityButton.addTarget(self, action: "removeBottomMenu:", forControlEvents: UIControlEvents.TouchUpInside)
            
            self.playerButton.removeTarget(self, action: "removeBottomMenu:", forControlEvents: UIControlEvents.TouchUpInside)
            self.playerButton.addTarget(self, action: "switchBottomMenu:", forControlEvents: UIControlEvents.TouchUpInside)
            
            UIView.animateWithDuration(0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [.CurveEaseInOut], animations: {
                
                self.playerSelectionView.center.x = -self.playerSelectionView.frame.width / 2
                self.abilitySelectionView.center.x = self.view.frame.width / 2
                
                }, completion: nil)
        }
        
    }
    
    func createCharacterOptionButton(position: CGPoint, width: CGFloat, height: CGFloat, index: Int) -> UIButton {
        
        let levelPlist = NSBundle.mainBundle().pathForResource("GameInfo", ofType: "plist")
        let levelData = NSDictionary(contentsOfFile: levelPlist!)!
        let characterList = levelData["Characters"] as! NSArray
        let characterInfo = characterList[index] as! NSDictionary
        
        
        let characterName = characterInfo["Name"] as! String
        let characterStatHealth = characterInfo["Stat Health"] as! Int
        let characterStatBounce = characterInfo["Stat Bounce"] as! Int
        let characterStatJump = characterInfo["Stat Jump"] as! Int
        let characterStatSpeed = characterInfo["Stat Speed"] as! Int
        let characterRankReq = characterInfo["Level Req"] as! Int
        
        let button = UIButton()
        
        button.frame = CGRect(x: 0, y: 0, width: width, height: height)
        button.backgroundColor = UIColor.clearColor()
        button.setBackgroundImage(UIImage.imageWithColor(black), forState: .Normal)
        button.setBackgroundImage(UIImage.imageWithColor(lightBlack), forState: .Highlighted)
        button.layer.cornerRadius = cornerRadius
        button.clipsToBounds = true
        button.tag = index
        
        if index == GameState.sharedInstance.characterSelected {
            button.layer.borderColor = yellow.CGColor
            button.layer.borderWidth = 3
        }
        
        
        
        button.center = position
        
        if characterRankReq > GameState.sharedInstance.level {
            
            button.backgroundColor = UIColor(colorLiteralRed: 5/215, green: 31/255, blue: 77/255, alpha: 0.25)
            
            let lblName = UILabel(frame: CGRect(x: 0, y: 0, width: width * 0.5, height: height * 0.08))
            lblName.font = UIFont(name: "EncodeSansNarrow-Bold", size: 100)
            lblName.numberOfLines = 0
            lblName.textColor = white
            lblName.textAlignment = NSTextAlignment.Left
            lblName.text = "Rank \(characterRankReq)"
            lblName.adjustsFontSizeToFitWidth = true
            button.addSubview(lblName)
            
            
            let playerIconImage = UIImage(named: "Lock Icon")! as UIImage
            let playerIconView = UIImageView(image: playerIconImage)
            
            lblName.center = CGPoint(x: width * 0.625, y: spacing + lblName.frame.height / 2)
            
            playerIconView.center = CGPoint(x: lblName.center.x - playerIconView.frame.width / 2 - spacing / 2 - lblName.frame.width / 2, y: lblName.center.y)
            
            
            button.addSubview(playerIconView)
            
            // Health Bar
            
            let statBarHeight = button.frame.height * 0.035
            
            let healthBarBG = UIView(frame: CGRect(x: 0, y: 0, width: width / 2, height: statBarHeight))
            healthBarBG.backgroundColor = darkBlue
            healthBarBG.center = CGPoint(x: width - healthBarBG.frame.width / 2 - spacing, y: button.frame.height / 2 + healthBarBG.frame.height)
            button.addSubview(healthBarBG)
            
            let lblStatHealth = UILabel()
            lblStatHealth.font = UIFont(name: "EncodeSansNarrow-Regular", size: 12)
            lblStatHealth.textColor = white
            lblStatHealth.alpha = 0.25
            lblStatHealth.textAlignment = NSTextAlignment.Left
            lblStatHealth.text = "Health"
            lblStatHealth.sizeToFit()
            lblStatHealth.center = CGPoint(x: spacing + lblStatHealth.frame.width / 2, y: healthBarBG.center.y)
            button.addSubview(lblStatHealth)
            
            // Bounce Bar
            
            let bounceBarBG = UIView(frame: CGRect(x: 0, y: 0, width: width / 2, height: statBarHeight))
            bounceBarBG.backgroundColor = darkBlue
            bounceBarBG.center = CGPoint(x: width - bounceBarBG.frame.width / 2 - spacing, y: healthBarBG.center.y + bounceBarBG.frame.height + spacing * 2 / 3)
            button.addSubview(bounceBarBG)
            
            
            let lblStatBounce = UILabel()
            lblStatBounce.font = UIFont(name: "EncodeSansNarrow-Regular", size: 12)
            lblStatBounce.textColor = white
            lblStatBounce.alpha = 0.25
            lblStatBounce.textAlignment = NSTextAlignment.Left
            lblStatBounce.text = "Bounce"
            lblStatBounce.sizeToFit()
            lblStatBounce.center = CGPoint(x: spacing + lblStatBounce.frame.width / 2, y: bounceBarBG.center.y)
            button.addSubview(lblStatBounce)
            
            // Jump Bar
            
            let jumpBarBG = UIView(frame: CGRect(x: 0, y: 0, width: width / 2, height: statBarHeight))
            jumpBarBG.backgroundColor = darkBlue
            jumpBarBG.center = CGPoint(x: width - jumpBarBG.frame.width / 2 - spacing, y: bounceBarBG.center.y + jumpBarBG.frame.height + spacing * 2 / 3)
            button.addSubview(jumpBarBG)
            
            
            let lblStatJump = UILabel()
            lblStatJump.font = UIFont(name: "EncodeSansNarrow-Regular", size: 12)
            lblStatJump.textColor = white
            lblStatJump.alpha = 0.25
            lblStatJump.textAlignment = NSTextAlignment.Left
            lblStatJump.text = "Jump"
            lblStatJump.sizeToFit()
            lblStatJump.center = CGPoint(x: spacing + lblStatJump.frame.width / 2, y: jumpBarBG.center.y)
            //lblStatJump.adjustsFontSizeToFitWidth
            button.addSubview(lblStatJump)
            
            // Speed Bar
            
            let speedBarBG = UIView(frame: CGRect(x: 0, y: 0, width: width / 2, height: statBarHeight))
            speedBarBG.backgroundColor = darkBlue
            speedBarBG.center = CGPoint(x: width - speedBarBG.frame.width / 2 - spacing, y: jumpBarBG.center.y + speedBarBG.frame.height + spacing * 2 / 3)
            button.addSubview(speedBarBG)
            
            
            let lblStatSpeed = UILabel()
            lblStatSpeed.font = UIFont(name: "EncodeSansNarrow-Regular", size: 12)
            lblStatSpeed.textColor = white
            lblStatSpeed.alpha = 0.25
            lblStatSpeed.textAlignment = NSTextAlignment.Left
            lblStatSpeed.text = "Speed"
            lblStatSpeed.sizeToFit()
            lblStatSpeed.center = CGPoint(x: spacing + lblStatSpeed.frame.width / 2, y: speedBarBG.center.y)
            button.addSubview(lblStatSpeed)
            
        } else {
            
            button.addTarget(self, action: "chooseCharacter:", forControlEvents: UIControlEvents.TouchUpInside)
            
            
            let lblName = UILabel(frame: CGRect(x: 0, y: 0, width: width - spacing * 2, height: height * 0.08))
            lblName.font = UIFont(name: ".SFUIText-Bold", size: 100)
            lblName.numberOfLines = 0
            lblName.textColor = yellow
            lblName.textAlignment = NSTextAlignment.Center
            lblName.text = characterName
            lblName.adjustsFontSizeToFitWidth = true
            lblName.center = CGPoint(x: button.frame.width / 2, y: spacing + lblName.frame.height / 2)
            button.addSubview(lblName)
            
            if characterInfo["Special Text"] != nil {
                let characterStatsSpecial = characterInfo["Special Text"] as! String
                let lblSpecialText = UILabel(frame: CGRect(x: 0, y: 0, width: width - spacing * 2, height: spacing * 2))
                lblSpecialText.font = UIFont(name: "EncodeSansNarrow-Bold", size: 12)
                lblSpecialText.textColor = blue
                lblSpecialText.textAlignment = NSTextAlignment.Left
                lblSpecialText.numberOfLines = 0
                lblSpecialText.text = characterStatsSpecial
                lblSpecialText.center = CGPoint(x: lblSpecialText.frame.width / 2 + spacing, y: height - lblSpecialText.frame.height)
                button.addSubview(lblSpecialText)
            }
            
            // Health Bar
            
            let statBarHeight = button.frame.height * 0.035
            
            let healthBarBG = UIView(frame: CGRect(x: 0, y: 0, width: width / 2, height: statBarHeight))
            healthBarBG.backgroundColor = darkBlue
            healthBarBG.userInteractionEnabled = false
            healthBarBG.center = CGPoint(x: width - healthBarBG.frame.width / 2 - spacing, y: button.frame.height / 2 + healthBarBG.frame.height)
            button.addSubview(healthBarBG)
            
            let healthBarFill = UIView(frame: CGRect(x: 0, y: 0, width: healthBarBG.frame.width * CGFloat(characterStatHealth * 10) / 100, height: healthBarBG.frame.height))
            healthBarFill.backgroundColor = white
            healthBarBG.addSubview(healthBarFill)
            
            let lblStatHealth = UILabel()
            lblStatHealth.font = UIFont(name: "EncodeSansNarrow-Regular", size: 12)
            lblStatHealth.textColor = white
            lblStatHealth.textAlignment = NSTextAlignment.Left
            lblStatHealth.userInteractionEnabled = false
            lblStatHealth.text = "Health"
            lblStatHealth.sizeToFit()
            lblStatHealth.center = CGPoint(x: spacing + lblStatHealth.frame.width / 2, y: healthBarBG.center.y)
            button.addSubview(lblStatHealth)
            
            // Bounce Bar
            
            let bounceBarBG = UIView(frame: CGRect(x: 0, y: 0, width: width / 2, height: statBarHeight))
            bounceBarBG.backgroundColor = darkBlue
            bounceBarBG.userInteractionEnabled = false
            bounceBarBG.center = CGPoint(x: width - bounceBarBG.frame.width / 2 - spacing, y: healthBarBG.center.y + bounceBarBG.frame.height + spacing * 2 / 3)
            button.addSubview(bounceBarBG)
            
            let bounceBarFill = UIView(frame: CGRect(x: 0, y: 0, width: bounceBarBG.frame.width * CGFloat(characterStatBounce * 10) / 100, height: bounceBarBG.frame.height))
            bounceBarFill.backgroundColor = white
            bounceBarFill.userInteractionEnabled = false
            bounceBarBG.addSubview(bounceBarFill)
            
            let lblStatBounce = UILabel()
            lblStatBounce.font = UIFont(name: "EncodeSansNarrow-Regular", size: 12)
            lblStatBounce.textColor = white
            lblStatBounce.textAlignment = NSTextAlignment.Left
            lblStatBounce.text = "Bounce"
            lblStatBounce.sizeToFit()
            lblStatBounce.center = CGPoint(x: spacing + lblStatBounce.frame.width / 2, y: bounceBarBG.center.y)
            button.addSubview(lblStatBounce)
            
            // Jump Bar
            
            let jumpBarBG = UIView(frame: CGRect(x: 0, y: 0, width: width / 2, height: statBarHeight))
            jumpBarBG.backgroundColor = darkBlue
            jumpBarBG.userInteractionEnabled = false
            jumpBarBG.center = CGPoint(x: width - jumpBarBG.frame.width / 2 - spacing, y: bounceBarBG.center.y + jumpBarBG.frame.height + spacing * 2 / 3)
            button.addSubview(jumpBarBG)
            
            let jumpBarFill = UIView(frame: CGRect(x: 0, y: 0, width: jumpBarBG.frame.width * CGFloat(characterStatJump * 10) / 100, height: jumpBarBG.frame.height))
            jumpBarFill.backgroundColor = white
            jumpBarFill.userInteractionEnabled = false
            jumpBarBG.addSubview(jumpBarFill)
            
            let lblStatJump = UILabel()
            lblStatJump.font = UIFont(name: "EncodeSansNarrow-Regular", size: 12)
            lblStatJump.textColor = white
            lblStatJump.textAlignment = NSTextAlignment.Left
            lblStatJump.text = "Jump"
            lblStatJump.sizeToFit()
            lblStatJump.center = CGPoint(x: spacing + lblStatJump.frame.width / 2, y: jumpBarBG.center.y)
            //lblStatJump.adjustsFontSizeToFitWidth
            button.addSubview(lblStatJump)
            
            // Speed Bar
            
            let speedBarBG = UIView(frame: CGRect(x: 0, y: 0, width: width / 2, height: statBarHeight))
            speedBarBG.backgroundColor = darkBlue
            speedBarBG.userInteractionEnabled = false
            speedBarBG.center = CGPoint(x: width - speedBarBG.frame.width / 2 - spacing, y: jumpBarBG.center.y + speedBarBG.frame.height + spacing * 2 / 3)
            button.addSubview(speedBarBG)
            
            let speedBarFill = UIView(frame: CGRect(x: 0, y: 0, width: speedBarBG.frame.width * CGFloat(characterStatSpeed * 10) / 100, height: speedBarBG.frame.height))
            speedBarFill.backgroundColor = white
            speedBarBG.addSubview(speedBarFill)
            
            let lblStatSpeed = UILabel()
            lblStatSpeed.font = UIFont(name: "EncodeSansNarrow-Regular", size: 12)
            lblStatSpeed.textColor = white
            lblStatSpeed.userInteractionEnabled = false
            lblStatSpeed.textAlignment = NSTextAlignment.Left
            lblStatSpeed.text = "Speed"
            lblStatSpeed.sizeToFit()
            lblStatSpeed.center = CGPoint(x: spacing + lblStatSpeed.frame.width / 2, y: speedBarBG.center.y)
            button.addSubview(lblStatSpeed)
            
            // Player Icon Image
            let playerIconImage = UIImage(named: "Character \(index + 1) Icon")! as UIImage
            let playerIconView = UIImageView(image: playerIconImage)
            playerIconView.userInteractionEnabled = false
            playerIconView.center = CGPoint(x: width / 2, y: height * 0.4 - playerIconView.frame.height / 2)
            button.addSubview(playerIconView)
            
        }
        
        return button
    }
    
    func createLevelButton(position: CGPoint, width: CGFloat, height: CGFloat, levelNumber: Int) -> UIView {
        
        let levelPlist = NSBundle.mainBundle().pathForResource("GameInfo", ofType: "plist")
        let levelData = NSDictionary(contentsOfFile: levelPlist!)!
        let levelList = levelData["Levels"] as! NSArray
        let levelInfo = levelList[levelNumber] as! NSDictionary
        let levelTitle = levelInfo["Title"] as! String
        let colorOneString = levelInfo["Color 1"] as! String
        let colorOne = getColor(colorOneString)
        let colorTwoString = levelInfo["Color 2"] as! String
        let colorTwo = getColor(colorTwoString)
        let textColorString = levelInfo["Text Color"] as! String
        let textColor = getColor(textColorString)
        
        
        let button = UIView()
        button.frame = CGRect(x: 0, y: 0, width: width, height: height)
        button.center = position
        
        let buttonView = UIView()
        buttonView.clipsToBounds = true
        buttonView.frame = button.frame
        buttonView.userInteractionEnabled = false
        buttonView.backgroundColor = UIColor.clearColor()
        buttonView.center = CGPoint(x: button.frame.width / 2, y: button.frame.height / 2)
        buttonView.layer.cornerRadius = cornerRadius
        
        let gradient = createNamedGradient(colorOneString, view: buttonView)
        buttonView.layer.insertSublayer(gradient, atIndex: 0)
        
        
        if let levelThumbnail = UIImage(named: "Level \(levelNumber + 1) Thumbnail") {
            let levelThumbnailView = UIImageView(image: levelThumbnail)
            levelThumbnailView.center = CGPoint(x: buttonView.frame.width / 2, y: buttonView.frame.height / 2)
            buttonView.addSubview(levelThumbnailView)
            
            // Set vertical effect
            let verticalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y",
                type: .TiltAlongVerticalAxis)
            verticalMotionEffect.minimumRelativeValue = -20
            verticalMotionEffect.maximumRelativeValue = 20
            
            // Set horizontal effect
            let horizontalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x",
                type: .TiltAlongHorizontalAxis)
            horizontalMotionEffect.minimumRelativeValue = -20
            horizontalMotionEffect.maximumRelativeValue = 20
            
            // Create group to combine both
            let group = UIMotionEffectGroup()
            group.motionEffects = [horizontalMotionEffect, verticalMotionEffect]
            
            // Add both effects to your view
            levelThumbnailView.addMotionEffect(group)
        }
        
        
        button.addSubview(buttonView)
        
        //
        
        //
        
        let lblLevelTitle = UILabel(frame: CGRectMake(0, 0, popUpWidth, height * 0.15))
        lblLevelTitle.font = UIFont(name: "EncodeSansNarrow-Bold", size: 50)
        lblLevelTitle.numberOfLines = 0
        lblLevelTitle.adjustsFontSizeToFitWidth = true
        lblLevelTitle.textColor = textColor
        lblLevelTitle.center = CGPoint(x: button.frame.width / 2, y: button.frame.height / 2)
        lblLevelTitle.textAlignment = NSTextAlignment.Center
        lblLevelTitle.text = "\(levelTitle)"
        button.addSubview(lblLevelTitle)
        
        
        
        let levelNumberCircle = UIView(frame: CGRect(x: 0, y: 0, width: spacing * 2.5, height: spacing * 2.5))
        levelNumberCircle.layer.cornerRadius = levelNumberCircle.frame.height / 2
        levelNumberCircle.backgroundColor = colorTwo
        levelNumberCircle.center = CGPoint(x: width / 2, y: lblLevelTitle.center.y - height * 0.2)
        
        button.addSubview(levelNumberCircle)
        
        let lblLevelNumber = UILabel(frame: CGRectMake(0, 0, levelNumberCircle.frame.height * 0.75, levelNumberCircle.frame.width * 0.75))
        lblLevelNumber.font = UIFont(name: "EncodeSansNarrow-Bold", size: 30)
        lblLevelNumber.numberOfLines = 0
        lblLevelNumber.adjustsFontSizeToFitWidth = true
        lblLevelNumber.textColor = textColor
        lblLevelNumber.center = CGPoint(x: levelNumberCircle.center.x, y: levelNumberCircle.center.y - spacing / 16)
        lblLevelNumber.textAlignment = NSTextAlignment.Center
        lblLevelNumber.text = "\(levelNumber + 1)"
        button.addSubview(lblLevelNumber)
        
        let playButton = UIButton(frame: CGRect(x: 0, y: 0, width: width * 0.25, height: spacing * 2.5))
        playButton.tag = levelNumber
        playButton.addTarget(self, action: "startLevel:", forControlEvents: UIControlEvents.TouchUpInside)
        playButton.backgroundColor = UIColor.clearColor()
        playButton.setBackgroundImage(UIImage.imageWithColor(black), forState: .Normal)
        playButton.setBackgroundImage(UIImage.imageWithColor(lightBlack), forState: .Highlighted)
        playButton.layer.cornerRadius = cornerRadius
        playButton.clipsToBounds = true
        playButton.center = CGPoint(x: width / 2, y: height - spacing * 2 - playButton.frame.height / 2)
        
        
        let playButtonText = UILabel(frame: CGRect(x: 0, y: 0, width: playButton.frame.width - spacing * 0.75, height: playButton.frame.height - spacing * 0.75))
        playButtonText.font = UIFont(name: "EncodeSansNarrow-Bold", size: 50)
        playButtonText.numberOfLines = 0
        playButtonText.adjustsFontSizeToFitWidth = true
        playButtonText.textColor = colorTwo
        playButtonText.textAlignment = NSTextAlignment.Center
        playButtonText.text = "Play"
        playButtonText.center = CGPoint(x: playButton.frame.width / 2, y: playButton.frame.height / 2 - spacing * 0.1)
        playButton.addSubview(playButtonText)
        
        button.addSubview(playButton)
        
        return button
    }
    
    func createAbilityButton(index: Int) -> UIButton {
        
        let abilityLevel = GameState.sharedInstance.abilities[index]
        
        let levelPlist = NSBundle.mainBundle().pathForResource("GameInfo", ofType: "plist")
        let levelData = NSDictionary(contentsOfFile: levelPlist!)!
        let abilityList = levelData["Skills"] as! NSArray
        let abilityDict = abilityList[index] as! NSDictionary
        let abilityTitle = abilityDict["Title"] as! String
        let abilityColor = abilityDict["Color"] as! String
        let abilityUpgrades = abilityDict["Upgrades"] as! NSArray
        let abilityOne = abilityUpgrades[0] as! NSDictionary
        let abilityUnlockRank = abilityOne["Rank"] as! Int
        
        let abilityButtonHeight = self.view.frame.height * 0.32
        let abilityButtonWidth = self.view.frame.width * 0.2
        let xPosition = abilityButtonWidth * CGFloat(index) + abilityButtonWidth / 2 + spacing / 2 * CGFloat(index + 1)
        
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: abilityButtonWidth, height: abilityButtonHeight))
        button.center = CGPoint(x: xPosition, y: abilitySelectionScrollView.frame.height / 2)
        button.tag = index
        button.layer.cornerRadius = cornerRadius
        button.backgroundColor = UIColor.clearColor()
        button.setBackgroundImage(UIImage.imageWithColor(black), forState: .Normal)
        button.setBackgroundImage(UIImage.imageWithColor(lightBlack), forState: .Highlighted)
        button.clipsToBounds = true
        button.addTarget(self, action: "revealAbilityDetails:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let iconBG = UIView(frame: CGRect(x: 0, y: 0, width: spacing * 2, height: spacing * 2))
        iconBG.backgroundColor = getColor(abilityColor)
        iconBG.layer.cornerRadius = spacing
        iconBG.center = CGPoint(x: abilityButtonWidth / 2, y: abilityButtonHeight * 0.35)
        iconBG.userInteractionEnabled = false
        button.addSubview(iconBG)
        
        if let iconImage = UIImage(named: "\(abilityTitle) Icon") {
            let iconImageView = UIImageView(image: iconImage)
            iconImageView.center = CGPoint(x: iconBG.bounds.width / 2, y: iconBG.bounds.height / 2)
            iconImageView.userInteractionEnabled = false
            iconBG.addSubview(iconImageView)
            
        }
        
        
        let lblTitle = UILabel(frame: CGRect(x: 0, y: 0, width: abilityButtonWidth - spacing, height: abilityButtonHeight/8))
        lblTitle.font = UIFont(name: "EncodeSansNarrow-Bold", size: 50)
        lblTitle.numberOfLines = 0
        lblTitle.adjustsFontSizeToFitWidth = true
        lblTitle.textColor = white
        lblTitle.center = CGPoint(x: abilityButtonWidth / 2, y: abilityButtonHeight * 0.58)
        lblTitle.textAlignment = NSTextAlignment.Center
        lblTitle.userInteractionEnabled = false
        //abilityTitle.uppercaseString = true
        lblTitle.text = "\(abilityTitle)"
        button.addSubview(lblTitle)
        
        for var indexBar = 0; indexBar < abilityUpgrades.count - 1; ++indexBar {
            let bar = UIView(frame: CGRect(x: 0, y: 0, width: abilityButtonWidth * 0.12, height: spacing / 4))
            let count = CGFloat(abilityUpgrades.count) - 2
            let offsetX = abilityButtonWidth / 2 - (count * bar.frame.width + spacing * count / 4) / 2
            bar.backgroundColor = darkBlue
            bar.center = CGPoint(x: CGFloat(indexBar) * bar.frame.width + spacing * CGFloat(indexBar) / 4 + offsetX, y: abilityButtonHeight * 0.7)
            bar.userInteractionEnabled = false
            if abilityLevel - 1 >= Int(indexBar) {
                bar.backgroundColor = white
                addGlow(bar, size: 0.5)
            }
            
            button.addSubview(bar)
        }
        
        // Check if Ability is Active
        
        if GameState.sharedInstance.activeAbilities.contains(index) {
            
            // Add Lock Icon
            
            let equippedIconImage = UIImage(named: "Equipped Icon")! as UIImage
            let equippedIconView = UIImageView(image: equippedIconImage)
            
            addGlow(equippedIconView, size: 0.25)
            
            equippedIconView.center = CGPoint(x: equippedIconView.frame.width / 2 + spacing / 2, y: equippedIconView.frame.height / 2 + spacing / 2)
            
            button.addSubview(equippedIconView)
        }
        
        // Check if Ability is Locked
        
        if abilityUnlockRank > GameState.sharedInstance.level {
            
            button.removeTarget(self, action: "revealAbilityDetails:", forControlEvents: UIControlEvents.TouchUpInside)
            
            // Change Text and Color
            
            iconBG.backgroundColor = darkBlue
            lblTitle.text = "Rank \(abilityUnlockRank)"
            button.alpha = 0.5
            
            // Add Lock Icon
            
            let lockIconImage = UIImage(named: "Lock Icon")! as UIImage
            let lockIconView = UIImageView(image: lockIconImage)
            
            lockIconView.center = CGPoint(x: lockIconView.frame.width / 2 + spacing / 2, y: lockIconView.frame.height / 2 + spacing / 2)
            
            
            button.addSubview(lockIconView)
        }
        
        
        
        return button
        
    }
    
    func revealAbilityDetails(sender: UIButton!) {
        
        for view in self.abilityDetailView.subviews {
            view.removeFromSuperview()
        }
        
        abilityDetailView.removeFromSuperview()
        
        abilityDetailView = createSelectedAbilityView(sender.tag)
        
        abilitySelectionView.addSubview(abilityDetailView)
        
        let selectedButton = abilityButtonArray[sender.tag]
        selectedButton.layer.borderWidth = 3
        selectedButton.layer.borderColor = yellow.CGColor
        
        var index = 0
        for button in abilityButtonArray {
            
            if index != sender.tag {
                button.layer.borderWidth = 0
                button.layer.borderColor = UIColor.clearColor().CGColor
            }
            
            index++
        }
        
        
    }
    
    func createSelectedAbilityView(index: Int) -> UIView {
        
        let abilityLevel = GameState.sharedInstance.abilities[index]
        
        let levelPlist = NSBundle.mainBundle().pathForResource("GameInfo", ofType: "plist")
        let levelData = NSDictionary(contentsOfFile: levelPlist!)!
        let abilityList = levelData["Skills"] as! NSArray
        let abilityDict = abilityList[index] as! NSDictionary
        let abilityTitle = abilityDict["Title"] as! String
        let abilityColor = abilityDict["Color"] as! String
        let abilityDescription = abilityDict["Description"] as! String
        let abilityUpgrades = abilityDict["Upgrades"] as! NSArray
        //let abilityOne = abilityUpgrades[0] as! NSDictionary
        //let abilityUnlockRank = abilityOne["Rank"] as! Int
        
        
        // Check if the ability is maxed
        
        let abilityCurrent = abilityUpgrades[abilityLevel] as! NSDictionary
        
        
        
        let abilityCurrentAttributes = abilityCurrent["Attributes"] as! [NSDictionary]
        let abilityCurrentCost = abilityCurrent["Cost"] as! Int
        
        let width = abilitySelectionView.frame.width
        let height = self.view.frame.height - bottomBar.frame.height - spacing - self.abilitySelectionScrollView.frame.height
        
        let abilityView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        
        
        // Create Ability Icon
        
        let iconBG = UIView(frame: CGRect(x: 0, y: 0, width: spacing * 2, height: spacing * 2))
        iconBG.backgroundColor = getColor(abilityColor)
        iconBG.layer.cornerRadius = spacing
        iconBG.center = CGPoint(x: iconBG.frame.width / 2 + spacing * 2, y: iconBG.frame.height / 2 + spacing)
        abilityView.addSubview(iconBG)
        
        if let iconImage = UIImage(named: "\(abilityTitle) Icon") {
            let iconImageView = UIImageView(image: iconImage)
            iconImageView.center = CGPoint(x: iconBG.bounds.width / 2, y: iconBG.bounds.height / 2)
            iconBG.addSubview(iconImageView)
        }
        
        // Create Title
        
        let lblTitle = UILabel(frame: CGRect(x: 0, y: 0, width: width / 3, height: height/7))
        lblTitle.font = UIFont(name: "EncodeSansNarrow-Bold", size: 50)
        lblTitle.numberOfLines = 0
        lblTitle.adjustsFontSizeToFitWidth = true
        lblTitle.textColor = white
        lblTitle.center = CGPoint(x: iconBG.center.x + iconBG.frame.width / 2 + spacing + lblTitle.frame.width / 2, y: iconBG.center.y)
        lblTitle.textAlignment = NSTextAlignment.Left
        lblTitle.text = abilityTitle
        abilityView.addSubview(lblTitle)
        
        // Create Description
        
        let lblDescription = UILabel(frame: CGRect(x: 0, y: 0, width: width * 0.66, height: height/4))
        lblDescription.font = UIFont(name: "EncodeSansNarrow-Regular", size: 50)
        lblDescription.numberOfLines = 2
        lblDescription.adjustsFontSizeToFitWidth = true
        lblDescription.textColor = white
        lblDescription.center = CGPoint(x: lblDescription.frame.width / 2 + spacing * 2, y: iconBG.center.y + iconBG.frame.height / 2 + lblDescription.frame.height / 2 + spacing * 1.75)
        lblDescription.textAlignment = NSTextAlignment.Left
        lblDescription.text = abilityDescription
        abilityView.addSubview(lblDescription)
        
        // Create Level Bars
        
        for var indexBar = 0; indexBar < abilityUpgrades.count - 1; ++indexBar {
            let bar = UIView(frame: CGRect(x: 0, y: 0, width: width * 0.12, height: spacing / 3))
            //let count = CGFloat(abilityUpgrades.count) - 1
            let offsetX = bar.frame.width / 2 + spacing * 2
            bar.backgroundColor = black
            bar.center = CGPoint(x: CGFloat(indexBar) * bar.frame.width + spacing * CGFloat(indexBar) / 2 + offsetX, y: iconBG.center.y + iconBG.frame.height / 2 + spacing)
            
            
            if abilityLevel - 1 >= Int(indexBar) {
                bar.backgroundColor = white
                addGlow(bar, size: 0.5)
            }
            
            
            abilityView.addSubview(bar)
        }
        
        var abilitiesIndex = 0 as CGFloat
        
        // Create Attributes
        
        var delay = 0.0 as Double
        
        for abilities in abilityCurrentAttributes {
            
            let title = abilities["Title"] as! String
            let description = abilities["Description"] as! String
            let type = abilities["Type"] as! String
            
            let attributeWidth = abilityView.frame.width * 0.25
            
            
            // Create Attribute Icons
            
            let iconBG = UIView(frame: CGRect(x: 0, y: 0, width: spacing * 1.5, height: spacing * 1.5))
            iconBG.backgroundColor = black
            iconBG.layer.cornerRadius = iconBG.frame.width / 2
            iconBG.center = CGPoint(x: iconBG.frame.width / 2 + spacing * 2 + abilitiesIndex * attributeWidth, y: abilityView.frame.height - spacing - iconBG.frame.height / 2)
            iconBG.transform = CGAffineTransformMakeScale(0,0)
            abilityView.addSubview(iconBG)
            
            if let iconImage = UIImage(named: "\(type) Icon") {
                let iconImageView = UIImageView(image: iconImage)
                iconImageView.center = CGPoint(x: iconBG.bounds.width / 2, y: iconBG.bounds.height / 2)
                iconBG.addSubview(iconImageView)
            }
            
            UIView.animateWithDuration(0.7, delay: delay, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [.CurveEaseInOut], animations: {
                iconBG.transform = CGAffineTransformMakeScale(1,1)
                
                }, completion: nil)
            
            
            
            // Create Title
            
            let lblTitle = UILabel(frame: CGRect(x: 0, y: 0, width: attributeWidth - spacing, height: height / 10))
            lblTitle.font = UIFont(name: "EncodeSansNarrow-Bold", size: 50)
            lblTitle.numberOfLines = 0
            lblTitle.adjustsFontSizeToFitWidth = true
            lblTitle.textColor = white
            lblTitle.center = CGPoint(x: iconBG.center.x + iconBG.frame.width / 2 + spacing / 2 + lblTitle.frame.width / 2, y: iconBG.center.y - spacing / 2)
            lblTitle.textAlignment = NSTextAlignment.Left
            lblTitle.text = title
            lblTitle.alpha = 0.0
            abilityView.addSubview(lblTitle)
            
            // Create Description
            
            let lblDescription = UILabel(frame: CGRect(x: 0, y: 0, width: attributeWidth - spacing, height: height / 12))
            lblDescription.font = UIFont(name: "EncodeSansNarrow-Regular", size: 50)
            lblDescription.numberOfLines = 0
            lblDescription.adjustsFontSizeToFitWidth = true
            lblDescription.textColor = white
            lblDescription.center = CGPoint(x: iconBG.center.x + iconBG.frame.width / 2 + spacing / 2 + lblDescription.frame.width / 2, y: iconBG.center.y + spacing / 2)
            lblDescription.textAlignment = NSTextAlignment.Left
            lblDescription.text = description
            lblDescription.alpha = 0.0
            abilityView.addSubview(lblDescription)
            
            
            UIView.animateWithDuration(0.7, delay: delay, options: [.CurveEaseInOut], animations: {
                lblDescription.alpha = 1.0
                lblTitle.alpha = 1.0
                }, completion: nil)
            
            abilitiesIndex++
            delay = delay + 0.2
        }
        
        // Create Equip Button
        
        if abilityLevel == 0 {
            
            // Create Purchase Button
            abilityEquipButton = UIButton(frame: CGRect(x: 0, y: 0, width: width * 0.18, height: height / 3))
            abilityEquipButton.center = CGPoint(x: width - abilityEquipButton.frame.width / 2 - spacing, y: abilityEquipButton.frame.height / 2 + spacing)
            abilityEquipButton.backgroundColor = UIColor.clearColor()
            abilityEquipButton.setBackgroundImage(UIImage.imageWithColor(black), forState: .Normal)
            abilityEquipButton.setBackgroundImage(UIImage.imageWithColor(lightBlack), forState: .Highlighted)
            abilityEquipButton.layer.cornerRadius = cornerRadius
            abilityEquipButton.clipsToBounds = true
            abilityEquipButton.addTarget(self, action: "createAbilityPopUpView:", forControlEvents: UIControlEvents.TouchUpInside)
            abilityEquipButton.tag = index
            abilityView.addSubview(abilityEquipButton)
            self.shinyAnimation(abilityEquipButton)
            
            let equipText = UILabel(frame: CGRect(x: 0, y: 0, width: abilityEquipButton.frame.width - spacing * 0.75, height: spacing))
            equipText.font = UIFont(name: "EncodeSansNarrow-Bold", size: 50)
            
            equipText.numberOfLines = 0
            equipText.adjustsFontSizeToFitWidth = true
            equipText.textColor = yellow
            equipText.textAlignment = NSTextAlignment.Center
            equipText.text = "PURCHASE"
            
            abilityEquipButton.addSubview(equipText)
            
            let coinText = UILabel(frame: CGRect(x: 0, y: 0, width: abilityEquipButton.frame.width - spacing * 0.75, height: spacing * 1.5))
            coinText.text = "\(abilityCurrentCost)"
            coinText.font = optimisedfindAdaptiveFontWithName("EncodeSansNarrow-Regular", label: coinText, minSize: 5, maxSize: 50)
            coinText.sizeToFit()
            coinText.textColor = white
            coinText.textAlignment = NSTextAlignment.Center
            
            let coinImage = UIImage(named: "Coin Icon")! as UIImage
            let coinImageView = UIImageView(image: coinImage)
            addGlow(coinImageView, size: 0.1)
            
            equipText.center = CGPoint(x: abilityEquipButton.frame.width / 2, y: abilityEquipButton.frame.height / 2 - coinText.frame.height / 2)
            
            let coinTextImage = centerViews(coinImageView, viewTwo: coinText, spacing: spacing / 2)
            coinTextImage.userInteractionEnabled = false
            
            coinTextImage.center = CGPoint(x: abilityEquipButton.frame.width / 2, y: abilityEquipButton.frame.height / 2 + equipText.frame.height / 2)
            abilityEquipButton.addSubview(coinTextImage)
            
        } else {
            
            abilityEquipButton = UIButton(frame: CGRect(x: 0, y: 0, width: width * 0.18, height: height / 5))
            abilityEquipButton.center = CGPoint(x: width - abilityEquipButton.frame.width / 2 - spacing, y: abilityEquipButton.frame.height / 2 + spacing)
            abilityEquipButton.backgroundColor = UIColor.clearColor()
            abilityEquipButton.setBackgroundImage(UIImage.imageWithColor(black), forState: .Normal)
            abilityEquipButton.setBackgroundImage(UIImage.imageWithColor(lightBlack), forState: .Highlighted)
            abilityEquipButton.tag = index
            abilityEquipButton.addTarget(self, action: "equipAbility:", forControlEvents: UIControlEvents.TouchUpInside)
            abilityEquipButton.layer.cornerRadius = cornerRadius
            abilityEquipButton.clipsToBounds = true
            self.shinyAnimation(abilityEquipButton)
            abilityView.addSubview(abilityEquipButton)
            
            let equipText = UILabel(frame: CGRect(x: 0, y: 0, width: abilityEquipButton.frame.width - spacing * 0.75, height: spacing * 1.5))
            equipText.text = "EQUIP"
            if GameState.sharedInstance.activeAbilities.contains(index) {
                equipText.text = "UNEQUIP"
                abilityEquipButton.removeTarget(self, action: "equipAbility:", forControlEvents: UIControlEvents.TouchUpInside)
                abilityEquipButton.addTarget(self, action: "unEquipAbility:", forControlEvents: UIControlEvents.TouchUpInside)
            }
            
            equipText.font = optimisedfindAdaptiveFontWithName("EncodeSansNarrow-Bold", label: equipText, minSize: 5, maxSize: 50)
            equipText.textColor = yellow
            equipText.textAlignment = .Left
            equipText.sizeToFit()
            equipText.center = CGPoint(x: abilityEquipButton.frame.width / 2, y: abilityEquipButton.frame.height / 2)
            abilityEquipButton.addSubview(equipText)
            
        }
        
        
        // Create Upgrade Button
        
        
        if (abilityUpgrades.count - 2) < abilityLevel || abilityLevel == 0 {
            
        } else {
            
            let upgradeButton = UIButton(frame: CGRect(x: 0, y: 0, width: width * 0.18, height: height / 3))
            upgradeButton.center = CGPoint(x: width - upgradeButton.frame.width / 2 - spacing, y: abilityEquipButton.center.y + abilityEquipButton.frame.height / 2 + upgradeButton.frame.height / 2 + spacing)
            upgradeButton.backgroundColor = UIColor.clearColor()
            upgradeButton.setBackgroundImage(UIImage.imageWithColor(black), forState: .Normal)
            upgradeButton.setBackgroundImage(UIImage.imageWithColor(lightBlack), forState: .Highlighted)
            upgradeButton.layer.cornerRadius = cornerRadius
            upgradeButton.clipsToBounds = true
            upgradeButton.addTarget(self, action: "createAbilityPopUpView:", forControlEvents: UIControlEvents.TouchUpInside)
            upgradeButton.tag = index
            self.shinyAnimation(upgradeButton)
            abilityView.addSubview(upgradeButton)
            
            
            
            let equipText = UILabel(frame: CGRect(x: 0, y: 0, width: upgradeButton.frame.width - spacing * 0.75, height: spacing))
            equipText.font = UIFont(name: "EncodeSansNarrow-Bold", size: 50)
            
            equipText.numberOfLines = 0
            equipText.adjustsFontSizeToFitWidth = true
            equipText.textColor = yellow
            equipText.textAlignment = NSTextAlignment.Center
            equipText.text = "UPGRADE"
            
            upgradeButton.addSubview(equipText)
            
            let coinText = UILabel(frame: CGRect(x: 0, y: 0, width: upgradeButton.frame.width - spacing * 0.75, height: spacing * 1.5))
            coinText.text = "\(abilityCurrentCost)"
            coinText.font = optimisedfindAdaptiveFontWithName("EncodeSansNarrow-Regular", label: coinText, minSize: 5, maxSize: 50)
            coinText.sizeToFit()
            coinText.textColor = white
            coinText.textAlignment = NSTextAlignment.Center
            
            
            let coinImage = UIImage(named: "Coin Icon")! as UIImage
            let coinImageView = UIImageView(image: coinImage)
            addGlow(coinImageView, size: 0.1)
            
            
            equipText.center = CGPoint(x: upgradeButton.frame.width / 2, y: upgradeButton.frame.height / 2 - coinText.frame.height / 2)
            
            
            
            let coinTextImage = centerViews(coinImageView, viewTwo: coinText, spacing: spacing / 2)
            coinTextImage.userInteractionEnabled = false
            
            coinTextImage.center = CGPoint(x: upgradeButton.frame.width / 2, y: upgradeButton.frame.height / 2 + equipText.frame.height / 2)
            upgradeButton.addSubview(coinTextImage)
            
        }
        
        return abilityView
    }
    
    
    
    func levelButton(sender:UIButton!) {
        
        let levelPlist = NSBundle.mainBundle().pathForResource("GameInfo", ofType: "plist")
        let levelData = NSDictionary(contentsOfFile: levelPlist!)!
        let levelList = levelData["Levels"] as! NSArray
        let levelInfo = levelList[sender.tag] as! NSDictionary
        let levelTitle = levelInfo["Title"] as! String
        
        blackFadeButton = UIButton(type: UIButtonType.System) as UIButton
        blackFadeButton.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        blackFadeButton.backgroundColor = UIColor.blackColor()
        blackFadeButton.alpha = 0.0
        blackFadeButton.addTarget(self, action: "removePopUp:", forControlEvents: UIControlEvents.TouchUpInside)
        view?.addSubview(blackFadeButton)
        
        UIView.animateWithDuration(0.5, delay: 0, options: [], animations: {
            self.blackFadeButton.alpha = 0.75
            }, completion: nil)
        
        popUpView.frame = CGRect(origin: CGPointZero, size: CGSize(width: popUpWidth, height: popUpHeight))
        popUpView.backgroundColor = UIColor.clearColor()
        popUpView.center = CGPoint(x: self.view.frame.size.width / 2, y: 0 - popUpView.frame.height / 2)
        view?.addSubview(popUpView)
        
        UIView.animateWithDuration(0.7, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: [], animations: {
            self.popUpView.center.y = self.view.frame.size.height / 2
            }, completion: nil)
        
        let lblLevelTitle = UILabel(frame: CGRectMake(0, 0, popUpWidth, 20))
        lblLevelTitle.font = UIFont(name: ".SFUIText-Medium", size: 20)
        lblLevelTitle.textColor = UIColor.blackColor()
        lblLevelTitle.center = CGPoint(x: popUpWidth / 2, y: popUpHeight / 10)
        lblLevelTitle.textAlignment = NSTextAlignment.Center
        lblLevelTitle.text = "\(levelTitle)"
        popUpView.addSubview(lblLevelTitle)
        
        if let currentUser = PFUser.currentUser() {
            let scoreBoard = createScoreBoard(popUpWidth, frameHeight: popUpHeight / 3)
            scoreBoard.center = CGPoint(x: popUpWidth / 2, y: popUpHeight - popUpHeight / 2 + scoreBoard.frame.height / 2 - edgeSpace*2)
            popUpView.addSubview(scoreBoard)
        } else {
            fbButton = UIButton(type: UIButtonType.System) as UIButton
            fbButton.frame = CGRectMake(0, 0, popUpWidth / 2, popUpHeight / 7)
            fbButton.center = CGPoint(x: popUpWidth / 2, y: popUpHeight - popUpHeight / 3 - 4)
            fbButton.backgroundColor = UIColor.blueColor()
            fbButton.setTitle("Sync with Facebook", forState: UIControlState.Normal)
            fbButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            fbButton.addTarget(self, action: "fbLogin:", forControlEvents: UIControlEvents.TouchUpInside)
            popUpView.addSubview(fbButton)
        }
        
        let smashButton = UIButton(type: UIButtonType.System) as UIButton
        smashButton.frame = CGRectMake(0, popUpHeight * 0.75, popUpWidth, popUpHeight / 4)
        smashButton.backgroundColor = UIColor.grayColor()
        smashButton.setTitle("Smash!", forState: UIControlState.Normal)
        smashButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        smashButton.addTarget(self, action: "startLevel:", forControlEvents: UIControlEvents.TouchUpInside)
        
        popUpView.addSubview(smashButton)
        
    }
    
    func createScoreBoard(frameWidth: CGFloat, frameHeight: CGFloat) -> UIScrollView {
        
        var scoreBoardView = UIView()
        let scrollView = UIScrollView()
        scoreBoardView = UIView()
        scoreBoardView.backgroundColor = UIColor.clearColor()
        
        if let currentUser = PFUser.currentUser() {
            
            
            let titleSize = 15 as CGFloat
            let subTitleSize = 10 as CGFloat
            
            
            
            let fbFriends = currentUser["facebookFriends"] as! NSArray
            var fbFriendsClean = [String()]
            let userFBID = currentUser["fbID"] as! String
            fbFriendsClean.append(userFBID)
            
            for var index = 0; index < fbFriends.count; ++index {
                
                let fbFriend = fbFriends[index] as! NSDictionary
                let friendID = fbFriend["id"] as! String
                //let query : PFQuery = PFUser.query()!
                
                fbFriendsClean.append(friendID)
                
                
            }
            
            scoreBoardView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: frameWidth / 3 * (CGFloat(fbFriendsClean.count)), height: frameHeight))
            
            scoreBoardView.alpha = 1.0
            
            scrollView.contentSize = CGSizeMake(frameWidth / 3 * (CGFloat(fbFriendsClean.count)), frameHeight)
            scrollView.frame = CGRect(origin: CGPoint(x: self.view.frame.width / 4, y: self.view.frame.height / 4), size: CGSize(width: frameWidth, height: frameHeight))
            scrollView.backgroundColor = UIColor.clearColor()
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.alpha = 1.0
            scrollView.addSubview(scoreBoardView)
            
            
            
            var highScore = 0 as Int
            var name = ""
            
            let query : PFQuery = PFUser.query()!
            query.whereKey("fbID", containedIn: fbFriendsClean)
            query.orderByDescending("highScore")
            query.cachePolicy = .CacheElseNetwork
            query.findObjectsInBackgroundWithBlock({(NSArray objects, NSError error) in
                if (error != nil) {
                    
                    NSLog("error on getting highscores " + error!.localizedDescription)
                    
                } else {
                    
                    var index = 0
                    for object in objects! {
                        let xPosition = CGFloat(index) * frameWidth / 3 + frameWidth / 6 as CGFloat
                        
                        if object["highScore"] != nil {
                            
                            highScore = object["highScore"] as! Int
                            let lblHighScore = UILabel(frame: CGRectMake(0, 0, 100, 20))
                            lblHighScore.font = UIFont(name: ".SFUIText-Medium", size: titleSize)
                            lblHighScore.textColor = UIColor.blackColor()
                            lblHighScore.center = CGPointMake(xPosition, frameHeight - titleSize / 2 - 2.5 * frameHeight / 10)
                            lblHighScore.textAlignment = NSTextAlignment.Center
                            lblHighScore.text = "\(highScore)"
                            scoreBoardView.addSubview(lblHighScore)
                            
                        }
                        
                        if object["name"] != nil {
                            let nameString = object["name"] as! String
                            let myArray : [String] = nameString.componentsSeparatedByString(" ")
                            name = myArray[0]
                            let lblName = UILabel(frame: CGRectMake(0, 0, 100, 20))
                            lblName.font = UIFont(name: ".SFUIText-Light", size: subTitleSize)
                            lblName.textColor = UIColor.grayColor()
                            lblName.center = CGPointMake(xPosition, frameHeight - subTitleSize / 2 - frameHeight / 10)
                            lblName.textAlignment = NSTextAlignment.Center
                            lblName.text = "\(name)"
                            scoreBoardView.addSubview(lblName)
                            
                        }
                        
                        if let userImageFile = object["profilePicture"] as? PFFile {
                            userImageFile.getDataInBackgroundWithBlock {
                                (imageData: NSData?, error: NSError?) -> Void in
                                if error == nil {
                                    if let imageData = imageData {
                                        let image = UIImage(data:imageData)
                                        
                                        let imageSize = frameHeight / 2
                                        //let image = getStockProfileImage(CGSize(width: imageSize, height: imageSize))
                                        let imageView = UIImageView(image: image)
                                        
                                        
                                        imageView.frame = CGRect(x: 0, y: 0, width: imageSize, height: imageSize)
                                        imageView.center = CGPointMake(xPosition, imageSize / 2 + frameHeight / 10)
                                        
                                        scoreBoardView.addSubview(imageView)
                                        
                                        let hexagonPath = GameState.sharedInstance.createHexagonPath(imageSize/2)
                                        
                                        let maskLayer = CAShapeLayer()
                                        maskLayer.path = hexagonPath
                                        maskLayer.position = CGPoint(x: imageSize/2, y: imageSize/2)
                                        imageView.layer.mask = maskLayer
                                        imageView.image = image
                                        
                                    } else {
                                        
                                        let imageSize = frameHeight / 2
                                        let image = self.getStockProfileImage(CGSize(width: imageSize, height: imageSize))
                                        let imageView = UIImageView(image: image)
                                        
                                        
                                        imageView.frame = CGRect(x: 0, y: 0, width: imageSize, height: imageSize)
                                        imageView.center = CGPointMake(xPosition, imageSize / 2 + frameHeight / 10)
                                        
                                        scoreBoardView.addSubview(imageView)
                                        
                                        let hexagonPath = GameState.sharedInstance.createHexagonPath(imageSize/2)
                                        
                                        let maskLayer = CAShapeLayer()
                                        maskLayer.path = hexagonPath
                                        maskLayer.position = CGPoint(x: imageSize/2, y: imageSize/2)
                                        imageView.layer.mask = maskLayer
                                        
                                    }
                                }
                            }
                        }
                        
                        
                        index++
                        
                    }
                    
                }
            })
            
            
            
        } else {
            print("No user logged in")
            // add Facebook Login Button here
        }
        return scrollView
    }
    
    
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
    
    func removePopUp(sender:UIButton!) {
        UIView.animateWithDuration(0.5, delay: 0, options: [], animations: {
            
            self.blackFadeButton.alpha = 0.0
            self.blur.alpha = 0.0
            
            
            }, completion: { _ in
                
                self.blackFadeButton.removeFromSuperview()
                self.blur.removeFromSuperview()
        })
        
        UIView.animateWithDuration(0.3, delay: 0, options: [.CurveEaseIn], animations: {
            self.popUpView.center.y = self.view.frame.height + self.popUpView.frame.height / 2
            }, completion: { _ in
                for view in self.popUpView.subviews {
                    view.removeFromSuperview()
                }
                self.popUpView.removeFromSuperview()
                
                
        })
        
        
    }
    
    
    
    func removeFBButton() {
        for view in fbButton.subviews {
            view.removeFromSuperview()
        }
        fbButton.removeFromSuperview()
        
    }
    
    func startLevel(sender:UIButton!) {
        
        let levelPlist = NSBundle.mainBundle().pathForResource("GameInfo", ofType: "plist")
        let levelData = NSDictionary(contentsOfFile: levelPlist!)!
        let levelList = levelData["Levels"] as! NSArray
        let levelOneInfo = levelList[Int(sender.tag)] as! NSDictionary
        let levelOneColorOneString = levelOneInfo["Color 1"] as! String
        
        let gradientView = UIView(frame: self.view.frame)
        gradientView.alpha = 0.0
        let gradient = createNamedGradient(levelOneColorOneString, view: self.view)
        gradientView.layer.insertSublayer(gradient, atIndex: 0)
        self.view.addSubview(gradientView)
        UIView.animateWithDuration(0.5, delay: 0, options: [.CurveEaseIn], animations: {
            
            self.mainMenu.transform = CGAffineTransformMakeScale(2.0, 2.0)
            self.mainMenu.center.y = self.mainMenu.center.y + self.view.frame.height * 0.25
            gradientView.alpha = 1.0
            self.bottomBar.center.y = self.bottomBar.center.y + self.bottomBar.frame.height
            self.abilityButton.center.y = self.abilityButton.center.y + self.bottomBar.frame.height
            
            }, completion: { _ in
                
                // Remove Menu
                
                for view in self.popUpView.subviews {
                    view.removeFromSuperview()
                }
                for view in self.popUpView.subviews {
                    view.removeFromSuperview()
                }
                self.popUpView.removeFromSuperview()
                
                for view in self.mainMenu.subviews {
                    view.removeFromSuperview()
                }
                
                self.mainMenu.removeFromSuperview()
                self.blackFadeButton.removeFromSuperview()
                
                for view in self.view.subviews {
                    view.removeFromSuperview()
                }
                
                self.mainMenu.transform = CGAffineTransformMakeScale(1.0, 1.0)
                
                // Present Level
                let gameScene = GameScene(size: self.view.frame.size)
                let skScene = self.view as! SKView
                skScene.presentScene(gameScene)
                
                
        })
        
    }
    
    
    func getFBInfo(sender: AnyObject!){
        
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
            let pictureURL = "https://graph.facebook.com/\(facebookID)/picture?type=large"
            
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
    // Facebook Login
    func fbLogin(sender: UIButton!){
        let permissions = ["public_profile", "user_friends", "user_about_me"]
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    print("User signed up and logged in through Facebook!")
                    self.getFBInfo(self)
                    self.removeFBButton()
                    let scoreBoard = self.createScoreBoard(self.popUpWidth, frameHeight: self.popUpHeight / 3)
                    scoreBoard.center = CGPoint(x: self.popUpWidth / 2, y: self.popUpHeight - self.popUpHeight / 2 + scoreBoard.frame.height / 2 - self.edgeSpace*2)
                    self.popUpView.addSubview(scoreBoard)
                    user["rank"] = GameState.sharedInstance.level
                    user.saveInBackground()
                    
                } else {
                    print("User logged in through Facebook!")
                    self.getFBInfo(self)
                    self.removeFBButton()
                    let scoreBoard = self.createScoreBoard(self.popUpWidth, frameHeight: self.popUpHeight / 3)
                    scoreBoard.center = CGPoint(x: self.popUpWidth / 2, y: self.popUpHeight - self.popUpHeight / 2 + scoreBoard.frame.height / 2 - self.edgeSpace*2)
                    self.popUpView.addSubview(scoreBoard)
                    if let parseRank = user["rank"] as? Int {
                        
                        if parseRank > GameState.sharedInstance.level {
                            
                            GameState.sharedInstance.level = parseRank
                            
                        } else if parseRank < GameState.sharedInstance.level {
                            
                            user["rank"] = GameState.sharedInstance.level
                            user.saveInBackground()
                            
                        }
                    } else {
                        user["rank"] = GameState.sharedInstance.level
                        user.saveInBackground()
                    }
                    
                }
            } else {
                print("Uh oh. The user cancelled the Facebook login.")
            }
        }
    }
    
    
    
    
    
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func levelSelectorNextPage(sender: UIButton!) {
        
        let indexOfPage = levelScrollView.contentOffset.x / levelScrollView.frame.size.width
        
        if levelScrollViewIsScrolling == false {
            if sender.tag == 2 {
                levelScrollView.scrollRectToVisible(CGRect(x: levelScrollView.frame.width * (indexOfPage + 1), y: 0, width: levelScrollView.frame.width, height: levelScrollView.frame.height), animated: true)
            } else if sender.tag == 1 {
                levelScrollView.scrollRectToVisible(CGRect(x: levelScrollView.frame.width * (indexOfPage - 1), y: 0, width: levelScrollView.frame.width, height: levelScrollView.frame.height), animated: true)
            }
        }
        
        
        
    }
    
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        levelScrollViewIsScrolling = false
        print("scrollViewDidEndScrollingAnimation")
        setLevelScrollValues()
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        levelScrollViewIsScrolling = false
        
        print("scrollViewDidEndDecelerating")
        setLevelScrollValues()
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let levelPlist = NSBundle.mainBundle().pathForResource("GameInfo", ofType: "plist")
        let levelData = NSDictionary(contentsOfFile: levelPlist!)!
        let levelList = levelData["Levels"] as! NSArray
        
        
        levelScrollViewIsScrolling = true
        
        
        let indexOfPage = scrollView.contentOffset.x / scrollView.frame.size.width
        
        let indexInt = Int(indexOfPage)
        var indexOne = 0
        var indexTwo = 0
        
        if indexOfPage < CGFloat(indexInt) {
            
            indexOne = indexInt - 1
            indexTwo = indexInt
            
        } else {
            
            indexOne = indexInt
            indexTwo = indexInt + 1
            
        }
        
        if indexOne + 1 < levelButtonArray.count && indexOfPage > 0 {
            
            if indexOfPage > CGFloat(indexOne) && indexOfPage <= CGFloat(indexTwo) {
                
                let buttonOne = levelButtonArray[indexOne]
                let buttonTwo = levelButtonArray[indexTwo]
                let offset = indexOfPage - CGFloat(indexOne)
                
                // Change Background Color
                
                let levelOneInfo = levelList[Int(indexOne)] as! NSDictionary
                let levelOneColorOneString = levelOneInfo["Color 1"] as! String
                let levelOneColorTwoString = levelOneInfo["Color 2"] as! String
                let levelOneColorTwo = getColor(levelOneColorTwoString)

                
                let levelTwoInfo = levelList[Int(indexTwo)] as! NSDictionary
                let levelTwoColorOneString = levelTwoInfo["Color 1"] as! String
                let levelTwoColorTwoString = levelTwoInfo["Color 2"] as! String
                let levelTwoColorTwo = getColor(levelTwoColorTwoString)
                
                let gradientOneColors = getGradientColors(levelOneColorOneString)
                let gradientTwoColors = getGradientColors(levelTwoColorOneString)
                
                
                let blendedColorGradientTop = blendColors(gradientOneColors[0], colorTwo: gradientTwoColors[0], blend: offset)
                let blendedColorGradientBottom = blendColors(gradientOneColors[1], colorTwo: gradientTwoColors[1], blend: offset)
                
                let blendedGradient = createNewGradient(blendedColorGradientTop, colorTwo: blendedColorGradientBottom, view: mainMenu)
                
                let blendedColorTwo = blendColors(levelOneColorTwo, colorTwo: levelTwoColorTwo, blend: offset)
                
                
                //self.mainMenu.backgroundColor = blendedColorOne
                mainMenuGradient.removeFromSuperlayer()
                mainMenuGradient = blendedGradient
                mainMenu.layer.insertSublayer(mainMenuGradient, atIndex: 0)
                self.arrowLeft.strokeColor = blendedColorTwo.CGColor
                self.arrowRight.strokeColor = blendedColorTwo.CGColor
                
                // Scale Buttons
                
                buttonOne.transform = CGAffineTransformMakeScale(1.0 - offset/4, 1.00 - offset/4)
                buttonTwo.transform = CGAffineTransformMakeScale(0.75 + offset/4, 0.75 + offset/4)
                
                if indexOne == 0 && indexTwo == 1 {
                    self.arrowLeft.opacity = 0.0 + Float(offset)
                } else if indexOne == (levelButtonArray.count - 2) && indexTwo == (levelButtonArray.count - 1) {
                    self.arrowRight.opacity = 1.0 - Float(offset)
                }
                
            }
            
        } else {
            
        }
        
        
        
    }
    
    func setLevelScrollValues() {
        let indexOfPage = CGFloat(Int(levelScrollView.contentOffset.x / levelScrollView.frame.size.width))
        print(indexOfPage)
        
        let levelPlist = NSBundle.mainBundle().pathForResource("GameInfo", ofType: "plist")
        let levelData = NSDictionary(contentsOfFile: levelPlist!)!
        let levelList = levelData["Levels"] as! NSArray
        let levelInfo = levelList[Int(indexOfPage)] as! NSDictionary
        let colorOneString = levelInfo["Color 1"] as! String
        let colorTwoString = levelInfo["Color 2"] as! String
        let colorTwo = getColor(colorTwoString)
        let textColorString = levelInfo["Text Color"] as! String
        let textColor = getColor(textColorString)
        
        mainMenuGradient.removeFromSuperlayer()
        mainMenuGradient = createNamedGradient(colorOneString, view: mainMenu)
        mainMenu.layer.insertSublayer(mainMenuGradient, atIndex: 0)
        self.arrowLeft.strokeColor = colorTwo.CGColor
        self.arrowRight.strokeColor = colorTwo.CGColor
        
        if indexOfPage == 0 {
            self.arrowLeft.opacity = 0.0
        } else if indexOfPage == CGFloat(levelButtonArray.count) {
            self.arrowRight.opacity = 0.0
        }
        
        var index = 0 as CGFloat
        
        for levelButton in levelButtonArray {
            if indexOfPage == index {
                levelButton.transform = CGAffineTransformMakeScale(1.0, 1.0)
            } else {
                levelButton.transform = CGAffineTransformMakeScale(0.75, 0.75)
            }
            index++
        }
        
    }
    
    func getColor(colorString: String) -> UIColor {
        if colorString == "Red" {
            return red
        } else if colorString == "Blue" {
            return blue
        } else if colorString == "Green" {
            return green
        } else if colorString == "Purple" {
            return purple
        } else if colorString == "Orange" {
            return orange
        } else if colorString == "Dark Blue" {
            return darkBlue
        } else if colorString == "Yellow" {
            return yellow
        } else if colorString == "Pink" {
            return pink
        } else if colorString == "White" {
            return white
        } else if colorString == "Black" {
            return black
        } else {
            return UIColor.redColor()
        }
    }
    
    func blendColors(colorOne: UIColor, colorTwo: UIColor, blend: CGFloat) -> UIColor {
        let colorCIOne = CGColorGetComponents(colorOne.CGColor)
        let colorCITwo = CGColorGetComponents(colorTwo.CGColor)
        
        
        let newRed = colorCIOne[0] + (colorCITwo[0] - colorCIOne[0]) * blend
        let newGreen = colorCIOne[1] + (colorCITwo[1] - colorCIOne[1]) * blend
        let newBlue = colorCIOne[2] + (colorCITwo[2] - colorCIOne[2]) * blend
        let newAlpha = colorCIOne[3] + (colorCITwo[3] - colorCIOne[3]) * blend
        
        let newColor = UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: newAlpha)
        
        return newColor
        
    }
    
    
    func chooseCharacter(sender: UIButton!) {
        
        print("Character Choice \(sender.tag)")
        let button = characterButtonArray[sender.tag] as UIButton
        button.layer.borderColor = yellow.CGColor
        button.layer.borderWidth = 3
        
        let playerIconImage = UIImage(named: "Character \(sender.tag + 1) Icon")! as UIImage
        playerIconView.image = playerIconImage
        
        GameState.chooseCharacter(sender.tag)
        var index = 0 as Int
        
        for button in characterButtonArray {
            
            if index != sender.tag {
                button.layer.borderWidth = 0
                button.layer.borderColor = UIColor.clearColor().CGColor
            }
            
            index++
        }
        
    }
    
    func createAbilityPopUpView(sender: UIButton) {
        
        let levelPlist = NSBundle.mainBundle().pathForResource("GameInfo", ofType: "plist")
        let levelData = NSDictionary(contentsOfFile: levelPlist!)!
        let abilityList = levelData["Skills"] as! NSArray
        let abilityDict = abilityList[sender.tag] as! NSDictionary
        let abilityTitle = abilityDict["Title"] as! String
        let abilityUpgrades = abilityDict["Upgrades"] as! NSArray
        
        let abilityCurrentRank = GameState.sharedInstance.abilities[sender.tag]
        
        if abilityCurrentRank >= 0 {
            
            blur = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
            blur.frame = self.view.frame
            blur.alpha = 0.0
            self.view.addSubview(blur)
            
            blackFadeButton = UIButton(frame: self.view.frame)
            blackFadeButton.alpha = 0.0
            blackFadeButton.addTarget(self, action: "removePopUp:", forControlEvents: UIControlEvents.TouchUpInside)
            
            
            let gradient = createNamedGradient("Blue", view: blackFadeButton)
            blackFadeButton.layer.insertSublayer(gradient, atIndex: 0)
            
            self.view.addSubview(blackFadeButton)
            
            popUpView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width / 2, height: self.view.frame.height / 2))
            popUpView.layer.cornerRadius = cornerRadius
            popUpView.backgroundColor = UIColor.clearColor()
            
            //let xButton = createXButton(spacing * 2, strokeWidth: spacing / 4, color: black)
            //popUpView.addSubview(xButton)
            
            let confirmButton = UIButton(frame: CGRect(x: 0, y: 0, width: popUpView.frame.width / 2 - spacing * 1.5, height: popUpView.frame.height * 0.2))
            confirmButton.layer.cornerRadius = cornerRadius
            confirmButton.backgroundColor = UIColor.clearColor()
            confirmButton.setBackgroundImage(UIImage.imageWithColor(blue), forState: .Normal)
            confirmButton.setBackgroundImage(UIImage.imageWithColor(blueDeep), forState: .Highlighted)
            confirmButton.clipsToBounds = true
            confirmButton.tag = sender.tag
            confirmButton.center = CGPoint(x: popUpView.frame.width - spacing -  confirmButton.frame.width / 2, y: popUpView.frame.height - spacing - confirmButton.frame.height / 2)
            confirmButton.addTarget(self, action: "removePopUp:", forControlEvents: UIControlEvents.TouchUpInside)
            confirmButton.addTarget(self, action: "upgradeAbility:", forControlEvents: UIControlEvents.TouchUpInside)
            popUpView.addSubview(confirmButton)
            
            let cancelButton = UIButton(frame: CGRect(x: 0, y: 0, width: popUpView.frame.width / 2 - spacing * 1.5, height: popUpView.frame.height * 0.2))
            cancelButton.layer.cornerRadius = cornerRadius
            cancelButton.backgroundColor = UIColor.clearColor()
            cancelButton.setBackgroundImage(UIImage.imageWithColor(grey), forState: .Normal)
            cancelButton.setBackgroundImage(UIImage.imageWithColor(blue), forState: .Highlighted)
            cancelButton.clipsToBounds = true
            cancelButton.center = CGPoint(x: spacing + cancelButton.frame.width / 2, y: popUpView.frame.height - spacing - cancelButton.frame.height / 2)
            cancelButton.addTarget(self, action: "removePopUp:", forControlEvents: UIControlEvents.TouchUpInside)
            popUpView.addSubview(cancelButton)
            
            let lblCancel = UILabel(frame: CGRect(x: 0, y: 0, width: cancelButton.frame.width * 0.75, height: cancelButton.frame.height * 0.6))
            lblCancel.font = UIFont(name: "EncodeSansNarrow-Regular", size: 50)
            lblCancel.text = "Cancel"
            lblCancel.textColor = black
            lblCancel.numberOfLines = 0
            lblCancel.adjustsFontSizeToFitWidth = true
            lblCancel.textAlignment = .Center
            lblCancel.center = CGPoint(x: cancelButton.frame.width / 2, y: cancelButton.frame.height / 2)
            cancelButton.addSubview(lblCancel)
            
            let lblConfirm = UILabel(frame: CGRect(x: 0, y: 0, width: confirmButton.frame.width * 0.75, height: confirmButton.frame.height * 0.6))
            lblConfirm.font = UIFont(name: "EncodeSansNarrow-Regular", size: 50)
            lblConfirm.text = "Ok"
            lblConfirm.textColor = black
            lblConfirm.numberOfLines = 0
            lblConfirm.adjustsFontSizeToFitWidth = true
            lblConfirm.textAlignment = .Center
            lblConfirm.center = CGPoint(x: confirmButton.frame.width / 2, y: confirmButton.frame.height / 2)
            confirmButton.addSubview(lblConfirm)
            
            let lblTitle = UILabel(frame: CGRect(x: 0, y: 0, width: popUpView.frame.width - spacing, height: popUpView.frame.height * 0.2))
            lblTitle.center = CGPoint(x: popUpView.frame.width / 2, y: spacing + lblTitle.frame.height / 2)
            lblTitle.font = UIFont(name: "EncodeSansNarrow-Bold", size: 50)
            if abilityCurrentRank == 0 {
                lblTitle.text = "Purchase \(abilityTitle)"
            } else {
                lblTitle.text = "Upgrade \(abilityTitle)"
            }
            lblTitle.textColor = white
            lblTitle.numberOfLines = 0
            lblTitle.adjustsFontSizeToFitWidth = true
            lblTitle.textAlignment = .Center
            popUpView.addSubview(lblTitle)
            
            popUpView.center = CGPoint(x: self.view.frame.width / 2, y: -popUpView.frame.height / 2)
            self.view.addSubview(popUpView)
            
            UIView.animateWithDuration(0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [.CurveEaseInOut], animations: {
                
                self.popUpView.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2)
                
                }, completion: { _ in

            })
            
            UIView.animateWithDuration(0.2, delay: 0, options: [.CurveEaseInOut], animations: {
                
                self.blackFadeButton.alpha = 0.75
                
                self.blur.alpha = 0.75
                
                }, completion: nil)
        }
        
    }
    
    func upgradeAbility(sender: UIButton) {
        
        GameState.sharedInstance.upgradeAbility(sender.tag)
        
        for view in self.abilityDetailView.subviews {
            view.removeFromSuperview()
        }
        
        abilityDetailView.removeFromSuperview()
        
        
        refreshAbilityButton(sender.tag, highlight: true)
        
        
        
        // Create updated Detail View
        
        abilityDetailView = createSelectedAbilityView(sender.tag)
        
        abilitySelectionView.addSubview(abilityDetailView)
        
        refreshAbilityButton(sender.tag, highlight: true)
        
        
    }
    
    func equipAbility(sender: UIButton) {
        
        
        let levelPlist = NSBundle.mainBundle().pathForResource("GameInfo", ofType: "plist")
        let levelData = NSDictionary(contentsOfFile: levelPlist!)!
        let abilityList = levelData["Skills"] as! NSArray
        let abilityDict = abilityList[sender.tag] as! NSDictionary
        let abilityTitle = abilityDict["Title"] as! String
        let abilityColor = abilityDict["Color"] as! String
        
        let activeAbilities = GameState.sharedInstance.activeAbilities
        
        var abilityHasBeenActivated = false
        
        var abilityIndex = 0
        
        for ability in activeAbilities {
            
            
            
            if ability == 100 && abilityHasBeenActivated == false {
                // Place ability
                
                GameState.sharedInstance.saveActiveAbilities(abilityIndex, ability: sender.tag)
                
                // Remove current button
                
                let center = abilityActiveButtonsArray[abilityIndex].center
                
                for view in abilityActiveButtonsArray[abilityIndex].subviews {
                    view.removeFromSuperview()
                }
                
                abilityActiveButtonsArray[abilityIndex].removeFromSuperview()
                
                
                // Created new active ability button
                
                let iconBG = UIButton(frame: CGRect(x: 0, y: 0, width: spacing * 2, height: spacing * 2))
                iconBG.backgroundColor = getColor(abilityColor)
                iconBG.layer.cornerRadius = spacing
                iconBG.tag = sender.tag
                iconBG.center = center
                iconBG.userInteractionEnabled = false
                
                if let iconImage = UIImage(named: "\(abilityTitle) Icon") {
                    let iconImageView = UIImageView(image: iconImage)
                    iconImageView.center = CGPoint(x: iconBG.bounds.width / 2, y: iconBG.bounds.height / 2)
                    iconImageView.userInteractionEnabled = false
                    iconBG.addSubview(iconImageView)
                }
                
                abilityActiveButtonsArray[abilityIndex] = iconBG
                
                abilityButton.addSubview(abilityActiveButtonsArray[abilityIndex])
                
                
                
                
                abilityHasBeenActivated = true
                
                // Swap out Equip Button with UnEquip Button
                
                
                let equipText = UILabel(frame: CGRect(x: 0, y: 0, width: abilityEquipButton.frame.width - spacing * 0.75, height: spacing * 1.5))
                equipText.text = "UNEQUIP"
                equipText.font = optimisedfindAdaptiveFontWithName("EncodeSansNarrow-Bold", label: equipText, minSize: 5, maxSize: 50)
                equipText.textColor = yellow
                equipText.textAlignment = .Left
                equipText.sizeToFit()
                
                equipText.center = CGPoint(x: abilityEquipButton.frame.width / 2, y: abilityEquipButton.frame.height / 2)
                
                for view in abilityEquipButton.subviews {
                    if view.isKindOfClass(UILabel) {
                        view.removeFromSuperview()
                    }
                    
                }
                
                abilityEquipButton.backgroundColor = UIColor.clearColor()
                abilityEquipButton.setBackgroundImage(UIImage.imageWithColor(black), forState: .Normal)
                abilityEquipButton.setBackgroundImage(UIImage.imageWithColor(lightBlack), forState: .Highlighted)
                
                abilityEquipButton.addSubview(equipText)
                abilityEquipButton.removeTarget(self, action: "equipAbility:", forControlEvents: UIControlEvents.TouchUpInside)
                abilityEquipButton.addTarget(self, action: "unEquipAbility:", forControlEvents: UIControlEvents.TouchUpInside)
                
                refreshAbilityButton(sender.tag, highlight: true)
                
            } else {
                
                //Unable to place ability
                
                // Check if this is the last ability slot and the ability has still not been activated
                
                if abilityIndex + 1 >= activeAbilities.count && abilityHasBeenActivated == false  {
                    
                    // If so prompt the user to swap deactivate one of their current abilities
                    
                    print("Unable to place ability, prompt to deactivate")
                    createAbilitiesFullView(sender.tag)
                }
            }
            
            abilityIndex++
            
            
        }
        
        // Recreate Ability Button
        
        
        
        
        
        
        
        
        
    }
    
    func unEquipAbility(sender: UIButton) {
        
        var abilityIndex = 0
        for ability in GameState.sharedInstance.activeAbilities {
            if ability == sender.tag {
                GameState.sharedInstance.saveActiveAbilities(abilityIndex, ability: 100)
                let center = abilityActiveButtonsArray[abilityIndex].center
                
                for view in abilityActiveButtonsArray[abilityIndex].subviews {
                    view.removeFromSuperview()
                }
                
                abilityActiveButtonsArray[abilityIndex].removeFromSuperview()
                
                let emptyAbilityButton = createEmptyAbilityButton()
                emptyAbilityButton.center = center
                
                abilityActiveButtonsArray[abilityIndex] = emptyAbilityButton
                
                abilityButton.addSubview(abilityActiveButtonsArray[abilityIndex])
                print(GameState.sharedInstance.activeAbilities)
            }
            abilityIndex++
        }
        
        // Swap out UnEquip Button with Equip Button
        
        let equipText = UILabel(frame: CGRect(x: 0, y: 0, width: abilityEquipButton.frame.width - spacing * 0.75, height: spacing * 1.5))
        equipText.text = "EQUIP"
        equipText.font = optimisedfindAdaptiveFontWithName("EncodeSansNarrow-Bold", label: equipText, minSize: 5, maxSize: 50)
        equipText.textColor = yellow
        equipText.textAlignment = .Left
        equipText.sizeToFit()
        equipText.center = CGPoint(x: abilityEquipButton.frame.width / 2, y: abilityEquipButton.frame.height / 2)
        
        for view in abilityEquipButton.subviews {
            if view.isKindOfClass(UILabel) {
                view.removeFromSuperview()
            }
            
        }
        
        abilityEquipButton.addSubview(equipText)
        abilityEquipButton.removeTarget(self, action: "unEquipAbility:", forControlEvents: UIControlEvents.TouchUpInside)
        abilityEquipButton.addTarget(self, action: "equipAbility:", forControlEvents: UIControlEvents.TouchUpInside)
        
        refreshAbilityButton(sender.tag, highlight: true)
        
        abilityEquipButton.backgroundColor = UIColor.clearColor()
        abilityEquipButton.setBackgroundImage(UIImage.imageWithColor(black), forState: .Normal)
        abilityEquipButton.setBackgroundImage(UIImage.imageWithColor(lightBlack), forState: .Highlighted)
    }
    
    func createEmptyAbilityButton() -> UIButton {
        let abilityCircle = UIButton(frame: CGRect(x: 0, y: 0, width: spacing * 2, height: spacing * 2))
        abilityCircle.layer.cornerRadius = abilityCircle.frame.width / 2
        abilityCircle.layer.borderWidth = 2
        abilityCircle.tag = 100
        abilityCircle.layer.borderColor = white.CGColor
        abilityCircle.userInteractionEnabled = false
        
        return abilityCircle
        
    }
    
    
    func addGlow(view: UIView, size: CGFloat) {
        view.layer.shadowColor = white.CGColor
        view.layer.shadowRadius = view.frame.height * size
        view.layer.shadowOpacity = 0.9
        view.layer.shadowOffset = CGSizeZero
        view.layer.masksToBounds = false
        view.layer.shouldRasterize = true
    }
    
    func createAbilitiesFullView(index: Int) {
        
        abilityButton.removeTarget(self, action: "revealBottomMenu:", forControlEvents: UIControlEvents.TouchUpInside)
        
        abilityFullDarkBG = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        abilityFullDarkBG.center = CGPoint(x: mainMenu.frame.width / 2, y: mainMenu.frame.height / 2)
        abilityFullDarkBG.backgroundColor = black
        abilityFullDarkBG.tag = index
        abilityFullDarkBG.alpha = 0.85
        abilityFullDarkBG.addTarget(self, action: "removeAbilitySwapButton:", forControlEvents: UIControlEvents.TouchUpInside)
        //abilityFullDarkBG.userInteractionEnabled = false
        mainMenu.addSubview(abilityFullDarkBG)
        
        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width / 3, height: self.view.frame.height / 4))
        bgView.center = CGPoint(x: abilityButton.center.x, y: bgView.frame.height + spacing * 1.5 + abilityButton.frame.height / 2)
        bgView.layer.cornerRadius = cornerRadius
        bgView.userInteractionEnabled = false
        bgView.backgroundColor = white
        
        let triangleShape = CAShapeLayer()
        let trianglePath = GameState.sharedInstance.createTrianglePath(spacing*2)
        triangleShape.path = trianglePath
        triangleShape.fillColor = bgView.backgroundColor?.CGColor
        triangleShape.position = CGPoint(x: bgView.frame.width / 2, y: -triangleShape.frame.height + 1)
        triangleShape.lineWidth = 3
        bgView.layer.addSublayer(triangleShape)
        
        let text = UILabel(frame: CGRect(x: 0, y: 0, width: bgView.frame.width - spacing * 3, height: bgView.frame.height - spacing * 3))
        text.text = "Choose an ability to swap out"
        text.font = UIFont(name: "EncodeSansNarrow-Regular", size: 50)
        text.numberOfLines = 2
        text.adjustsFontSizeToFitWidth = true
        text.textColor = black
        text.textAlignment = NSTextAlignment.Center
        text.userInteractionEnabled = false
        text.center = CGPoint(x: bgView.frame.width / 2, y: bgView.frame.height / 2)
        
        bgView.addSubview(text)
        
        
        abilityFullDarkBG.addSubview(bgView)
        
        for button in abilityActiveButtonsArray {
            
            abilityButton.bringSubviewToFront(button)
            button.userInteractionEnabled = true
            button.addTarget(self, action: "swapAbility:", forControlEvents: UIControlEvents.TouchUpInside)
            
        }
        
        mainMenu.bringSubviewToFront(abilityButton)
    }
    
    func swapAbility(sender: UIButton) {
        
        abilityButton.addTarget(self, action: "revealBottomMenu:", forControlEvents: UIControlEvents.TouchUpInside)
        
        print("Swap Ability Function has run")
        let tag = sender.tag
        
        let center = sender.center
        
        // Remove selected Ability
        
        for view in sender.subviews {
            view.removeFromSuperview()
        }
        sender.removeFromSuperview()
        
        // Replace the button with the new button
        var selectedButtonIndex = 0
        
        for button in abilityActiveButtonsArray {
            if button.tag == tag {
                
                print("Found a match, Tag = \(button.tag)")
                
                let levelPlist = NSBundle.mainBundle().pathForResource("GameInfo", ofType: "plist")
                let levelData = NSDictionary(contentsOfFile: levelPlist!)!
                let abilityList = levelData["Skills"] as! NSArray
                let abilityDict = abilityList[abilityFullDarkBG.tag] as! NSDictionary
                let abilityTitle = abilityDict["Title"] as! String
                let abilityColor = abilityDict["Color"] as! String
                
                // Place ability
                
                GameState.sharedInstance.saveActiveAbilities(selectedButtonIndex, ability: abilityFullDarkBG.tag)
                
                
                // Created new active ability button
                
                let iconBG = UIButton(frame: CGRect(x: 0, y: 0, width: spacing * 2, height: spacing * 2))
                iconBG.tag = abilityFullDarkBG.tag
                iconBG.backgroundColor = getColor(abilityColor)
                iconBG.layer.cornerRadius = spacing
                iconBG.center = center
                
                
                if let iconImage = UIImage(named: "\(abilityTitle) Icon") {
                    let iconImageView = UIImageView(image: iconImage)
                    iconImageView.center = CGPoint(x: iconBG.bounds.width / 2, y: iconBG.bounds.height / 2)
                    iconBG.addSubview(iconImageView)
                }
                
                abilityActiveButtonsArray[selectedButtonIndex] = iconBG
                
                abilityButton.addSubview(abilityActiveButtonsArray[selectedButtonIndex])
                
                
                let equipText = UILabel(frame: CGRect(x: 0, y: 0, width: abilityEquipButton.frame.width - spacing * 0.75, height: spacing * 1.5))
                equipText.text = "UNEQUIP"
                equipText.font = optimisedfindAdaptiveFontWithName("EncodeSansNarrow-Bold", label: equipText, minSize: 5, maxSize: 50)
                equipText.textColor = yellow
                equipText.textAlignment = .Left
                equipText.sizeToFit()
                equipText.center = CGPoint(x: abilityEquipButton.frame.width / 2, y: abilityEquipButton.frame.height / 2)
                
                for view in abilityEquipButton.subviews {
                    if view.isKindOfClass(UILabel) {
                        view.removeFromSuperview()
                    }
                    
                }
                
                abilityEquipButton.addSubview(equipText)
                abilityEquipButton.removeTarget(self, action: "equipAbility:", forControlEvents: UIControlEvents.TouchUpInside)
                abilityEquipButton.addTarget(self, action: "unEquipAbility:", forControlEvents: UIControlEvents.TouchUpInside)
                
                // Remove Dark BG
                for view in abilityFullDarkBG.subviews {
                    view.removeFromSuperview()
                }
                
                abilityFullDarkBG.removeFromSuperview()
                

                
                for button in abilityActiveButtonsArray {
                    button.removeTarget(self, action: "swapAbility:", forControlEvents: UIControlEvents.TouchUpInside)
                    button.userInteractionEnabled = false
                }
            }
            
            selectedButtonIndex++
        }
        
        refreshAbilityButton(sender.tag, highlight: false)
        refreshAbilityButton(abilityFullDarkBG.tag, highlight: true)
        
    }
    
    func removeAbilitySwapButton(sender: UIButton) {
        
        abilityButton.addTarget(self, action: "revealBottomMenu:", forControlEvents: UIControlEvents.TouchUpInside)
        
        for view in abilityFullDarkBG.subviews {
            view.removeFromSuperview()
        }
        abilityFullDarkBG.removeFromSuperview()
        
        for button in abilityActiveButtonsArray {
            button.removeTarget(self, action: "swapAbility:", forControlEvents: UIControlEvents.TouchUpInside)
            button.userInteractionEnabled = false
        }
    }
    
    func refreshAbilityButton(index: Int, highlight: Bool) {
        
        
        for view in abilityButtonArray[index].subviews {
            view.removeFromSuperview()
        }
        abilityButtonArray[index].removeFromSuperview()
        
        
        let newButton = createAbilityButton(index)
        
        if highlight == true {
            newButton.layer.borderWidth = 3
            newButton.layer.borderColor = yellow.CGColor
        }
        
        
        
        abilityButtonArray[index] = newButton
        
        
        self.abilitySelectionUIView.addSubview(abilityButtonArray[index])
    }
    
    func optimisedfindAdaptiveFontWithName(fontName:String, label:UILabel!, minSize:CGFloat, maxSize:CGFloat) -> UIFont! {
        
        var tempFont:UIFont
        var tempHeight:CGFloat
        var tempMax:CGFloat = maxSize
        var tempMin:CGFloat = minSize
        
        while (ceil(tempMin) != ceil(tempMax)){
            let testedSize = (tempMax + tempMin) / 2
            
            
            tempFont = UIFont(name:fontName, size:testedSize)!
            let attributedString = NSAttributedString(string: label.text!, attributes: [NSFontAttributeName : tempFont])
            
            let textFrame = attributedString.boundingRectWithSize(CGSize(width: label.bounds.size.width, height: CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin , context: nil)
            
            let difference = label.frame.height - textFrame.height
            print("\(tempMin)-\(tempMax) - tested : \(testedSize) --> difference : \(difference)")
            if(difference > 0){
                tempMin = testedSize
            } else {
                tempMax = testedSize
            }
        }
        
        
        return UIFont(name: fontName, size: tempMin - 1)
    }
    
    func centerViews(viewOne: UIView, viewTwo: UIView, spacing: CGFloat) -> UIView {
        
        var height = viewOne.frame.height
        
        if viewTwo.frame.height > viewOne.frame.height {
            height = viewTwo.frame.height
        }
        
        let centeredView = UIView(frame: CGRect(x: 0, y: 0, width: viewOne.frame.width + viewTwo.frame.width + spacing, height: height))
        
        viewOne.center = CGPoint(x: viewOne.frame.width / 2, y: centeredView.frame.height / 2)
        viewTwo.center = CGPoint(x: viewOne.frame.width + spacing + viewTwo.frame.width / 2, y: centeredView.frame.height / 2)
        centeredView.addSubview(viewOne)
        centeredView.addSubview(viewTwo)
        
        return centeredView
        
    }
    
    func shinyAnimation(view: UIView) {
        
        let shine = UIView(frame: CGRect(x: 0, y: 0, width: spacing * 4, height: view.frame.height * 4))
        shine.backgroundColor = UIColor(white: 1.0, alpha: 0.3)
        shine.center = CGPoint(x: -shine.frame.width, y: view.frame.height / 2)
        shine.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))
        
        view.addSubview(shine)
        
        
        
        UIView.animateWithDuration(0.4, delay: 0, options: [.CurveEaseInOut], animations: {
            shine.center.x = view.frame.width + shine.frame.width
            }, completion: { _ in
                shine.removeFromSuperview()
        })
        
    }
    
    func textColorAnimation(string: String, fontName: String, width: CGFloat, height: CGFloat, colorOne: UIColor, colorTwo: UIColor, colorThree: UIColor) -> UILabel {
        
        var myString:NSString = string
        var myMutableString = NSMutableAttributedString()
        
        myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSFontAttributeName:UIFont(name: fontName, size: 50.0)!])
        
        let lblHighScore = UILabel(frame: CGRectMake(0, 0, width, height))
        lblHighScore.attributedText = myMutableString
        lblHighScore.numberOfLines = 0
        lblHighScore.adjustsFontSizeToFitWidth = true
        lblHighScore.textAlignment = NSTextAlignment.Center
        
        let length = string.characters.count
        
        myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSFontAttributeName:UIFont(name: fontName, size: 50.0)!])
        lblHighScore.sizeToFit()
        
        runAfterDelay(1/24, block: {
            
            let colorArray = [UIColor.clearColor(), UIColor.clearColor(), UIColor.clearColor(), colorTwo, colorThree]
            
            for var index = 0; index < length; ++index {
                
                let randomNumber = arc4random_uniform(UInt32(colorArray.count) - 1)
                
                let chosenColor = colorArray[Int(randomNumber)]
                
                myMutableString.addAttribute(NSForegroundColorAttributeName, value: chosenColor, range: NSRange(location:index, length:1))
                
                
            }
            lblHighScore.attributedText = myMutableString
            
            
            
            self.runAfterDelay(1/24, block: {
                
                let colorArray = [UIColor.clearColor(), UIColor.clearColor(), colorTwo, colorThree]
                
                for var index = 0; index < length; ++index {
                    
                    let randomNumber = arc4random_uniform(UInt32(colorArray.count) - 1)
                    
                    let chosenColor = colorArray[Int(randomNumber)]
                    
                    myMutableString.addAttribute(NSForegroundColorAttributeName, value: chosenColor, range: NSRange(location:index, length:1))
                    
                    
                }
                lblHighScore.attributedText = myMutableString
                
                self.runAfterDelay(2/24, block: {
                    
                    let colorArray = [UIColor.clearColor(), colorTwo, colorThree, colorTwo, colorThree]
                    
                    for var index = 0; index < length; ++index {
                        
                        let randomNumber = arc4random_uniform(UInt32(colorArray.count) - 1)
                        
                        let chosenColor = colorArray[Int(randomNumber)]
                        
                        myMutableString.addAttribute(NSForegroundColorAttributeName, value: chosenColor, range: NSRange(location:index, length:1))
                        
                        
                    }
                    lblHighScore.attributedText = myMutableString
                    
                    self.runAfterDelay(2/24, block: {
                        
                        let colorArray = [colorTwo, colorThree, colorTwo, colorThree]
                        
                        for var index = 0; index < length; ++index {
                            
                            let randomNumber = arc4random_uniform(UInt32(colorArray.count) - 1)
                            
                            let chosenColor = colorArray[Int(randomNumber)]
                            
                            myMutableString.addAttribute(NSForegroundColorAttributeName, value: chosenColor, range: NSRange(location:index, length:1))
                            
                            
                        }
                        lblHighScore.attributedText = myMutableString
                        
                        self.runAfterDelay(3/24, block: {
                            
                            let colorArray = [colorTwo, colorThree, colorOne]
                            
                            for var index = 0; index < length; ++index {
                                
                                let randomNumber = arc4random_uniform(UInt32(colorArray.count) - 1)
                                
                                let chosenColor = colorArray[Int(randomNumber)]
                                
                                myMutableString.addAttribute(NSForegroundColorAttributeName, value: chosenColor, range: NSRange(location:index, length:1))
                                
                                
                            }
                            lblHighScore.attributedText = myMutableString
                            
                            self.runAfterDelay(3/24, block: {
                                
                                let colorArray = [colorTwo, colorThree, colorOne, colorOne, colorOne, colorOne]
                                
                                for var index = 0; index < length; ++index {
                                    
                                    let randomNumber = arc4random_uniform(UInt32(colorArray.count) - 1)
                                    
                                    let chosenColor = colorArray[Int(randomNumber)]
                                    
                                    myMutableString.addAttribute(NSForegroundColorAttributeName, value: chosenColor, range: NSRange(location:index, length:1))
                                    
                                    
                                }
                                lblHighScore.attributedText = myMutableString
                                
                                self.runAfterDelay(4/24, block: {
                                    
                                    let colorArray = [colorTwo, colorThree, colorOne, colorOne, colorOne, colorOne]
                                    
                                    for var index = 0; index < length; ++index {
                                        
                                        let randomNumber = arc4random_uniform(UInt32(colorArray.count) - 1)
                                        
                                        let chosenColor = colorArray[Int(randomNumber)]
                                        
                                        myMutableString.addAttribute(NSForegroundColorAttributeName, value: chosenColor, range: NSRange(location:index, length:1))
                                        
                                        
                                    }
                                    lblHighScore.attributedText = myMutableString
                                    
                                    self.runAfterDelay(5/24, block: {
                                        
                                        myMutableString.addAttribute(NSForegroundColorAttributeName, value: colorOne, range: NSRange(location:0, length: length))
                                        lblHighScore.attributedText = myMutableString
                                        
                                        
                                        self.shinyAnimation(lblHighScore)
                                    })
                                })
                            })
                        })
                    })
                })
            })
        })
        
        
        // set label Attribute
        
        return lblHighScore
    }
    
    func runAfterDelay(delay: NSTimeInterval, block: dispatch_block_t) {
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue(), block)
    }
    
    func createNamedGradient(color: String, view: UIView) -> CAGradientLayer {
        let gradient : CAGradientLayer = CAGradientLayer()
        gradient.frame = view.frame
        
        let arrayColors = getGradientColors(color)
        
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        
        gradient.colors = [arrayColors[0].CGColor, arrayColors[1].CGColor]
        //view.layer.insertSublayer(gradient, atIndex: 0)
        return gradient
        
        
    }
    
    
    func getGradientColors(color: String) -> Array<UIColor> {
        var arrayColors: Array<UIColor> = []
        
        if color == "Blue" {
            let cor1 = UIColor(colorLiteralRed: 93/255, green: 206/255, blue: 255/255, alpha: 1.0)
            let cor2 = UIColor(colorLiteralRed: 0/255, green: 133/255, blue: 213/255, alpha: 1.0)
            arrayColors = [cor1, cor2]
        } else if color == "Orange" {
            let cor1 = UIColor(colorLiteralRed: 255/255, green: 172/255, blue: 102/255, alpha: 1.0)
            let cor2 = UIColor(colorLiteralRed: 232/255, green: 86/255, blue: 30/255, alpha: 1.0)
            arrayColors = [cor1, cor2]
        } else if color == "Red" {
            let cor1 = UIColor(colorLiteralRed: 255/255, green: 102/255, blue: 94/255, alpha: 1.0)
            let cor2 = UIColor(colorLiteralRed: 204/255, green: 39/255, blue: 75/255, alpha: 1.0)
            arrayColors = [cor1, cor2]
        } else if color == "Purple" {
            let cor1 = UIColor(colorLiteralRed: 228/255, green: 141/255, blue: 255/255, alpha: 1.0)
            let cor2 = UIColor(colorLiteralRed: 109/255, green: 41/255, blue: 176/255, alpha: 1.0)
            arrayColors = [cor1, cor2]
        } else if color == "Yellow" {
            let cor1 = UIColor(colorLiteralRed: 255/255, green: 235/255, blue: 118/255, alpha: 1.0)
            let cor2 = UIColor(colorLiteralRed: 232/255, green: 190/255, blue: 13/255, alpha: 1.0)
            arrayColors = [cor1, cor2]
        } else if color == "White" {
            let cor1 = UIColor(colorLiteralRed: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
            let cor2 = UIColor(colorLiteralRed: 178/255, green: 232/255, blue: 255/255, alpha: 1.0)
            arrayColors = [cor1, cor2]
        } else if color == "Black" {
            let cor1 = UIColor(colorLiteralRed: 5/215, green: 31/255, blue: 77/255, alpha: 1.0)
            let cor2 = UIColor(colorLiteralRed: 31/255, green: 61/255, blue: 115/255, alpha: 1.0)
            arrayColors = [cor1, cor2]
        }
        
        return arrayColors
    }
    
    func createNewGradient(colorOne: UIColor, colorTwo: UIColor, view: UIView) -> CAGradientLayer {
        
        let gradient : CAGradientLayer = CAGradientLayer()
        gradient.frame = view.frame
        
        
        let arrayColors = [colorOne.CGColor, colorTwo.CGColor]
        
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        
        gradient.colors = arrayColors
        //view.layer.insertSublayer(gradient, atIndex: 0)
        
        return gradient
    }
    
    func createXButton(size: CGFloat, strokeWidth: CGFloat, color: UIColor) -> UIButton {
        let xButton = UIButton(frame: CGRect(x: 0, y: 0, width: size, height: size))
        let crossOne = UIView(frame: CGRect(x: 0, y: 0, width: strokeWidth, height: size))
        crossOne.backgroundColor = color
        crossOne.layer.cornerRadius = crossOne.frame.width / 2
        crossOne.center = CGPoint(x: xButton.frame.width / 2, y: xButton.frame.height / 2)
        crossOne.transform = CGAffineTransformMakeScale(1.0, 0.0)
        xButton.addSubview(crossOne)
        
        let crossTwo = UIView(frame: CGRect(x: 0, y: 0, width: strokeWidth, height: size))
        crossTwo.backgroundColor = color
        crossTwo.layer.cornerRadius = crossTwo.frame.width / 2
        crossTwo.center = CGPoint(x: xButton.frame.width / 2, y: xButton.frame.height / 2)
        crossTwo.transform = CGAffineTransformMakeScale(1.0, 0.0)
        xButton.addSubview(crossTwo)
        
        UIView.animateWithDuration(0.7, delay: 1.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [.CurveEaseInOut], animations: {
            crossOne.transform = CGAffineTransformMakeScale(1.0, 1.0)
            crossTwo.transform = CGAffineTransformMakeScale(1.0, 1.0)
            
            }, completion: nil)
        
        
        UIView.animateWithDuration(0.7, delay: 1.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [.CurveEaseInOut], animations: {
            crossOne.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))
            crossTwo.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_4))
            }, completion: nil)
        
        return xButton
    }
    
}



extension UILabel{
    
    func requiredWidth() -> CGFloat{
        
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, CGFloat.max, self.frame.height))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = self.font
        label.text = self.text
        
        label.sizeToFit()
        
        return label.frame.width
    }
}

extension UIImage {
    
    class func imageWithColor(color:UIColor?) -> UIImage! {
        
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0);
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        
        let context = UIGraphicsGetCurrentContext();
        
        if let color = color {
            
            color.setFill()
        }
        else {
            
            UIColor.whiteColor().setFill()
        }
        
        CGContextFillRect(context, rect);
        
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image;
    }
    
}




