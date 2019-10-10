//
//  GameScene.swift
//  Bounce
//
//  Created by Parachute on 3/20/18.
//  Copyright © 2018 Parachute. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

struct physicsCategory {
    
    static let Alien:  UInt32        = 0x1 << 1
    static let block:  UInt32        = 0x1 << 2
    static let topBoundry: UInt32    = 0x1 << 3
    static let bottomBoundry: UInt32 = 0x1 << 4
    static let circle:  UInt32       = 0x1 << 5
    static let rightBoundry: UInt32  = 0x1 << 6
    static let leftBoundry: UInt32   = 0x1 << 7
    static let sprinkle:  UInt32     = 0x1 << 8


    
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var Alien = SKSpriteNode()
    var block = SKSpriteNode()
    var circle = SKSpriteNode()
    var sprinkle = SKSpriteNode()
    var restartBTN = SKSpriteNode()
    var menuBTN = SKSpriteNode()
    var highScoreBTN = SKSpriteNode()
    var topBoundry = SKSpriteNode()
    var bottomBoundry = SKSpriteNode()
    var rightBoundry = SKSpriteNode()
    var leftBoundry = SKSpriteNode()
    var moveAndRemove = SKAction()
    var scoreLabel = SKLabelNode()
    var highScoreLabel = SKLabelNode()
    var gameStarted = Bool()
    var died = Bool()
    var score = Int()
    var highScore = Int()
    var audioPlayer = AVAudioPlayer()
    var secondStage:Bool = false
    var thirdStage:Bool = false
    var background = SKSpriteNode()
    var colorizeToBlack = SKAction()
    var rotate = SKAction()
    var waitDuration = 0.05
    
   
    func restartScene(){
        
        self.removeAllChildren()
        self.removeAllActions()
        died = false
        gameStarted = false
        self.scene?.speed = 1
        score = 0
        createScene()
    }
    func createScene(){
        
        rotate = SKAction.rotate(byAngle: 50, duration: 30)//rotates the nodes(Action used in update function
        self.physicsWorld.contactDelegate = self
        background.color = SKColor(red: 93/225, green: 158/255, blue: 180/255, alpha: 1)
        background.size = CGSize(width: self.frame.width, height: self.frame.height)
        background.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        self.addChild(background)
        colorizeToBlack = SKAction.colorize(with: SKColor(red: 63.0, green: 7.0, blue: 210.0, alpha: 1.0) , colorBlendFactor: 1, duration: 20)
        
        scoreLabel.position = CGPoint(x: scoreLabel.fontSize, y: self.frame.height - scoreLabel.fontSize)
        scoreLabel.fontColor = UIColor.white
        scoreLabel.text = "\(score)"
        self.addChild(scoreLabel)
        
        topBoundry = SKSpriteNode(color: UIColor.black, size: CGSize(width: self.frame.width, height: 1))
        topBoundry.position = CGPoint(x: 0, y: self.frame.height )
        topBoundry.physicsBody = SKPhysicsBody(rectangleOf: topBoundry.size)
        topBoundry.physicsBody?.categoryBitMask = physicsCategory.topBoundry
        topBoundry.physicsBody?.affectedByGravity = false
        topBoundry.physicsBody?.isDynamic = false
        self.addChild(topBoundry)
        
        bottomBoundry = SKSpriteNode(color: UIColor.black, size: CGSize(width: self.frame.width, height: 1))
        bottomBoundry.position = CGPoint(x: 0, y: -1)
        bottomBoundry.physicsBody = SKPhysicsBody(rectangleOf: bottomBoundry.size)
        bottomBoundry.physicsBody?.categoryBitMask = physicsCategory.bottomBoundry
        bottomBoundry.physicsBody?.contactTestBitMask = physicsCategory.Alien
        bottomBoundry.physicsBody?.affectedByGravity = false
        bottomBoundry.physicsBody?.isDynamic = false
        self.addChild(bottomBoundry)
        
        rightBoundry = SKSpriteNode(color: UIColor.black, size: CGSize(width: 1, height: self.frame.height))
        rightBoundry.position = CGPoint(x: self.frame.width, y: self.frame.height/2)
        rightBoundry.physicsBody = SKPhysicsBody(rectangleOf: rightBoundry.size)
        rightBoundry.physicsBody?.categoryBitMask = physicsCategory.rightBoundry
        rightBoundry.physicsBody?.contactTestBitMask = physicsCategory.circle
        rightBoundry.physicsBody?.collisionBitMask = physicsCategory.circle
        rightBoundry.physicsBody?.affectedByGravity = false
        rightBoundry.physicsBody?.isDynamic = false
        rightBoundry.zPosition = 1
        self.addChild(rightBoundry)
        
        leftBoundry = SKSpriteNode(color: UIColor.black, size: CGSize(width: 1, height: self.frame.height))
        leftBoundry.position = CGPoint(x: 0, y: self.frame.height/2)
        leftBoundry.physicsBody = SKPhysicsBody(rectangleOf: leftBoundry.size)
        leftBoundry.physicsBody?.categoryBitMask = physicsCategory.leftBoundry
        leftBoundry.physicsBody?.contactTestBitMask = physicsCategory.circle
        leftBoundry.physicsBody?.collisionBitMask = physicsCategory.circle
        leftBoundry.physicsBody?.affectedByGravity = false
        leftBoundry.physicsBody?.isDynamic = false
        leftBoundry.zPosition = 1
        self.addChild(leftBoundry)
        
        Alien = SKSpriteNode(imageNamed: "Neo2")
        Alien.size = CGSize(width: 25, height: 60)
        Alien.position = CGPoint(x: self.frame.width/2 , y: (self.frame.height/3) - Alien.frame.height)
        Alien.physicsBody = SKPhysicsBody(rectangleOf: Alien.size)
        Alien.physicsBody?.categoryBitMask = physicsCategory.Alien
        Alien.physicsBody?.collisionBitMask = physicsCategory.block | physicsCategory.circle
        Alien.physicsBody?.contactTestBitMask = physicsCategory.block | physicsCategory.circle
        Alien.physicsBody?.affectedByGravity = false
        Alien.physicsBody?.isDynamic = true

        self.addChild(Alien)
        
        
        
    }
    func createBTN(){
        restartBTN = SKSpriteNode(imageNamed: "Restart")
        restartBTN.position = CGPoint(x: self.frame.width/2, y: self.frame.height/1.5)
        restartBTN.size = CGSize(width: 250, height: 100)
        restartBTN.zPosition = 5
        self.addChild(restartBTN)
        
        menuBTN = SKSpriteNode(imageNamed: "MenuBTN")
        menuBTN.size = CGSize(width: restartBTN.size.width/2 - 5, height: restartBTN.size.height)
        menuBTN.position = CGPoint(x: restartBTN.position.x - menuBTN.size.width/2 - 5, y: restartBTN.position.y - restartBTN.size.height - 10)
        menuBTN.zPosition = 6
        self.addChild(menuBTN)
        
        highScoreBTN = SKSpriteNode(imageNamed: "HighScore")
        highScoreBTN.size = CGSize(width: menuBTN.size.width, height: restartBTN.size.height)
        highScoreBTN.position = CGPoint(x: restartBTN.position.x + highScoreBTN.size.width/2 + 5, y: restartBTN.position.y - restartBTN.size.height - 10)
        highScoreBTN.zPosition = 7
        self.addChild(highScoreBTN)
        
        highScoreLabel.position = CGPoint(x: highScoreBTN.position.x + highScoreLabel.fontSize/2, y: highScoreBTN.position.y - 7)
        highScoreLabel.fontColor = UIColor.white
        highScoreLabel.text = "\(highScore)"
        highScoreLabel.zPosition = 10
        self.addChild(highScoreLabel)
        
        
        
        
    }
    
    func afterCollidingWithBullets(){
        gameStarted = false
        self.scene?.speed = 0
        
        enumerateChildNodes(withName: "bullet", using: ({
            (node, error) in
            node.speed = 0
            self.removeAllActions()
        }))
        
        //setting stages to default after player is dead
        if secondStage == true{
            secondStage = false
        }
        if thirdStage == true{
            thirdStage = false
        }
        //===========//
        
        if died == false{
            audioPlayer.pause()
            died = true
            createBTN()
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision:UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if collision == physicsCategory.Alien | physicsCategory.block {
            afterCollidingWithBullets()
        }else if collision == physicsCategory.Alien | physicsCategory.circle{
            afterCollidingWithBullets()
        }else if collision == physicsCategory.Alien | physicsCategory.sprinkle{
            afterCollidingWithBullets()
        }
       

        

    }
    override func didMove(to view: SKView) {
        
        
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Boost", ofType: "mp3")!))
            audioPlayer.prepareToPlay()
        }
        catch{
            print(Error.self)
        }
        audioPlayer.play()
        
        //Keep the high score in game
        let highScoreDefault = UserDefaults.standard
        if highScoreDefault.value(forKey: "HighScore") != nil {
            highScore = highScoreDefault.value(forKey: "HighScore") as! NSInteger
            highScoreLabel.text = "\(highScore)"
        }
       
        
        createScene()
        
    }
    
    ///////*********SINGLE STAGE***********
    func createBlocks(){
        block.name = "bullet"
        block = SKSpriteNode(imageNamed: "Arroww" )
        block.size = CGSize(width: 6, height: 22)
        let randomXPosition = GKRandomDistribution(lowestValue: 0, highestValue: Int(self.frame.width))
        block.position = CGPoint(x: CGFloat(randomXPosition.nextInt()), y:  self.frame.height)
        block.physicsBody = SKPhysicsBody(rectangleOf: block.size)
        block.physicsBody?.categoryBitMask = physicsCategory.block
        block.physicsBody?.collisionBitMask = physicsCategory.Alien
        block.physicsBody?.contactTestBitMask = physicsCategory.Alien
        block.physicsBody?.affectedByGravity = false
        block.physicsBody?.isDynamic = false
        block.run(moveAndRemove) //bullet moves
        self.addChild(block)

    }
    func moveBlocks(){
        let spawn = SKAction.run({
            () in
            self.createBlocks()
        })
        let delay = SKAction.wait(forDuration: waitDuration)
        let spawnDelay = SKAction.sequence([spawn, delay])
        let spawnDelayForever = SKAction.repeatForever(spawnDelay)
        self.run(spawnDelayForever)
        
        let distance = CGFloat(self.frame.height + block.frame.height)
        //0.003 0.15 0.0012
        let moveBullets = SKAction.moveBy(x: 0, y: -distance-50, duration: TimeInterval( self.frame.height * 0.0000018 * distance))
        let removeBullets = SKAction.removeFromParent()
        moveAndRemove = SKAction.sequence([moveBullets, removeBullets])
        
    }
    ///*****************************************
    ///**************SINGLE STAGE *******************
   func createCircles(){
        circle.name = "bullet"
        circle = SKSpriteNode(imageNamed: "OvalWhite" )
        circle.size = CGSize(width: 10, height: 10)
        let randomXPosition = GKRandomDistribution(lowestValue: Int(-self.frame.width/2), highestValue: Int(self.frame.width) + Int(self.frame.width/2))
        circle.position = CGPoint(x: CGFloat(randomXPosition.nextInt()), y:  self.frame.height)
        circle.physicsBody = SKPhysicsBody(circleOfRadius: circle.size.width)
        circle.physicsBody?.categoryBitMask = physicsCategory.circle
        circle.physicsBody?.collisionBitMask = physicsCategory.Alien
        circle.physicsBody?.contactTestBitMask = physicsCategory.Alien
        circle.physicsBody?.affectedByGravity = true
        circle.physicsBody?.isDynamic = true
        circle.run(moveAndRemove) //bullet moves
        self.addChild(circle)
        
    }
    func moveCircles(){
        let spawn = SKAction.run ({
            () in
            self.createCircles()
            
        })
        
        let delay = SKAction.wait(forDuration: waitDuration)
        let spawnDelay = SKAction.sequence([spawn, delay])
        let spawnDelayForever = SKAction.repeatForever(spawnDelay)
        self.run(spawnDelayForever)
        let circleMoveX = GKRandomDistribution(lowestValue: Int(-self.frame.width), highestValue: Int(self.frame.width))
        let distance = CGFloat(self.frame.height + circle.size.height)
        //0.008
        let move = SKAction.moveBy(x: CGFloat(circleMoveX.nextInt()), y: -distance-50, duration: TimeInterval(self.frame.height * 0.0000060 * distance))
        let remove = SKAction.removeFromParent()
        moveAndRemove = SKAction.sequence([move, remove])
        
        
        
    }
    ///*****************************************
    ///**************SINGLE STAGE *******************
    func createSprinkles(){
        sprinkle.name = "bullet"
        sprinkle = SKSpriteNode(imageNamed: "Rectangle Copy" )
        sprinkle.size = CGSize(width: 3, height: 20)
        let randomXPosition = GKRandomDistribution(lowestValue: Int(-self.frame.width/2), highestValue: Int(self.frame.width) + Int(self.frame.width/2))
        sprinkle.position = CGPoint(x: CGFloat(randomXPosition.nextInt()), y:  self.frame.height)
        sprinkle.physicsBody = SKPhysicsBody(rectangleOf: sprinkle.size)
        sprinkle.physicsBody?.categoryBitMask = physicsCategory.sprinkle
        sprinkle.physicsBody?.collisionBitMask = physicsCategory.Alien
        sprinkle.physicsBody?.contactTestBitMask = physicsCategory.Alien
        sprinkle.physicsBody?.affectedByGravity = true
        sprinkle.physicsBody?.isDynamic = true
        sprinkle.run(moveAndRemove) //bullet moves
        self.addChild(sprinkle)
        
    }
    func moveSprinkles(){
        let spawn = SKAction.run ({
            () in
            self.createSprinkles()
            
        })
        
        let delay = SKAction.wait(forDuration: waitDuration)
        let spawnDelay = SKAction.sequence([spawn, delay])
        let spawnDelayForever = SKAction.repeatForever(spawnDelay)
        self.run(spawnDelayForever)
        let sprinkleMoveX = GKRandomDistribution(lowestValue: Int(-self.frame.width), highestValue: Int(self.frame.width))
        let distance = CGFloat(self.frame.height + sprinkle.size.height)
        //0.008
        let move = SKAction.moveBy(x: CGFloat(sprinkleMoveX.nextInt()), y: -distance-50, duration: TimeInterval(self.frame.height * 0.0000065 * distance))
        let remove = SKAction.removeFromParent()
        moveAndRemove = SKAction.sequence([move, remove])
        
        
        
    }
    ///********************************************//
    ///**************SINGLE STAGE *******************
   
    //**********************************
    
 
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        if gameStarted == false && died == false{
            gameStarted = true
            waitDuration = 0.10
            self.moveBlocks()
            
        }
        
    }
    func touchMoved(toPoint pos : CGPoint) {
        
        
        
    }
    
        
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if score > 500  && secondStage == false && died == false{
            enumerateChildNodes(withName: "bullet", using: ({
                (node, error) in
                self.removeAllActions()
                
            }))
            
            secondStage = true
            waitDuration = 0.05
            self.moveCircles()

        }
        
        else if score > 1000  && thirdStage == false && died == false{
            enumerateChildNodes(withName: "bullet", using: ({
                (node, error) in
                self.removeAllActions()
                
            }))
            thirdStage = true
            waitDuration = 0.05
            self.moveSprinkles()
            
            
        }
    
        for touch in touches{
            let location = touch.location(in: self)
            if died == true{
                if restartBTN.contains(location){
                    audioPlayer.play()
                    restartScene()
                }
            }
            else{
                if audioPlayer.play() == false{
                    audioPlayer.play()
                }
                if location.x < Alien.position.x + 100 && location.x > Alien.position.x - 100{
                    Alien.position.x = location.x
                }
            }
        }
        
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        if gameStarted == true{
            if died == false{
                score  = score + 1
                scoreLabel.text = "\(score)"
                circle.run(rotate)
                sprinkle.run(rotate)
                
                /**
                self.enumerateChildNodes(withName: "background", using: ({
                    (node, error) in
                    var bg = node as! SKSpriteNode
                    bg.position = CGPoint(x: bg.position.x, y: bg.position.y - 10 )
                    
                    if bg.position.y <= -bg.size.height{
                        bg.position = CGPoint(x: bg.position.x, y: bg.position.y + bg.size.height)
                    }
                }))**/
            }
           
            
            
        }
        else{
            if died == true{
                if score > highScore || highScore == 0{
                    highScore = score
                    highScoreLabel.text = "\(highScore)"
                    
                    let highScoreDefault = UserDefaults.standard
                    highScoreDefault.setValue(highScore, forKey: "HighScore")
                    highScoreDefault.synchronize()
                    
                }
        
            }
       
        }

    }
    
}
