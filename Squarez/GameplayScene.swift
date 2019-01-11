//
//  GameplayScene.swift
//  Squarez
//
//  Created by Elias Stevenson on 6/14/17.
//  Copyright © 2017 Elias Stevenson. All rights reserved.
//
import Foundation
import SpriteKit
import GoogleMobileAds



class GameplayScene: SKScene, SKPhysicsContactDelegate, UIGestureRecognizerDelegate, GADInterstitialDelegate, GADBannerViewDelegate{

    var sprite: playerClass!
    var pauseMenu: SKSpriteNode?
    var scoreLabel: SKLabelNode?
    var startLabel: SKLabelNode?
    var firstTime: SKSpriteNode?
    var pauseScore: SKLabelNode?
    var pauseHighScore: SKLabelNode?
    var deleter: SKSpriteNode!
    var score = 0
    var warning: SKShapeNode?
    var cir = circleClass()
    var lifeLabel: SKLabelNode!
    var life = 5
    var touchPoint: CGPoint = CGPoint()
    var touching: Bool = false
    var mainCamera: SKCameraNode?
    var gameOver = false
    let highScore = UserDefaults.standard.integer(forKey: "HIGHSCORE")
    let defaults = UserDefaults.standard
    var launchedBefore = false //UserDefaults.standard.bool(forKey: "launchedBefore")
    var ad : GADInterstitial!
    var bottomAd : GADBannerView!
    var timer1 = Timer()
    var timer2 = Timer()
    var timer3 = Timer()
    var timer4 = Timer()
    var timer5 = Timer()
    var timer6 = Timer()
    var timer7 = Timer()
    var timer8 = Timer()
    var timer9 = Timer()
    var timer10 = Timer()
    var id = 0
    var presented = 0
    var fingerTouching = false
    
    
    override func didMove(to view: SKView) {
        initialize()
        if launchedBefore != true {
            firstTime?.isHidden = false
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            launchedBefore = true
        }
        self.ad = GADInterstitial(adUnitID: "ca-app-pub-8240706232956319/8682591453")
        let request = GADRequest()
        self.ad.load(request)
        //bottomAd = GADBannerView(adSize: kGADAdSizeFullBanner)
        //self.view?.addSubview(bottomAd)
        //bottomAd.adUnitID = "ca-app-pub-8240706232956319/5809850250"
        //bottomAd.rootViewController = self.view?.window?.rootViewController
        //bottomAd.frame = CGRect(x: 0.0, y: (self.view?.frame.size.height)! - bottomAd.frame.size.height, width: bottomAd.frame.size.width, height: (bottomAd.frame.size.height))
    }
    
    
    func initialize(){
        mainCamera = childNode(withName: "mainCamera") as? SKCameraNode!
        sprite = mainCamera?.childNode(withName: "player") as? SKSpriteNode as! playerClass!
        pauseMenu = mainCamera?.childNode(withName: "deadMenu") as? SKSpriteNode!
        firstTime = mainCamera?.childNode(withName: "firstMenu") as? SKSpriteNode!
        firstTime?.isHidden = true
        sprite.color = .magenta
        scoreLabel = mainCamera?.childNode(withName: "score") as? SKLabelNode!
        startLabel = firstTime?.childNode(withName: "taptc") as? SKLabelNode!
        pauseScore = pauseMenu?.childNode(withName: "currentScore") as? SKLabelNode!
        pauseHighScore = pauseMenu?.childNode(withName: "highScore") as? SKLabelNode!
        warning = sprite?.childNode(withName: "Warn") as? SKShapeNode!
        warning?.isHidden = true
        deleter = mainCamera?.childNode(withName: "deleter") as? SKSpriteNode!
        lifeLabel = sprite?.childNode(withName: "life") as? SKLabelNode!
        pauseMenu?.isHidden = true
        sprite.initialize()
        physicsWorld.contactDelegate = self
      
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.5) {
            self.timer1 = Timer.scheduledTimer(timeInterval: TimeInterval(0.33), target: self, selector: #selector(GameplayScene.spawnCirc), userInfo: nil, repeats: true)
        }
        
        Timer.scheduledTimer(timeInterval: TimeInterval(3), target: self, selector: #selector(GameplayScene.changePlayerColor), userInfo: nil, repeats: true)
        
        Timer.scheduledTimer(timeInterval: TimeInterval(25), target: self, selector: #selector(GameplayScene.addScoreForTime), userInfo: nil, repeats: true)
        
        Timer.scheduledTimer(timeInterval: TimeInterval(0.5), target: self, selector: #selector(GameplayScene.animateText), userInfo: nil, repeats: true)

    }
    
    override func update(_ currentTime: CFTimeInterval) {
        if life <= 0{
            gameOver = true
        }
        if gameOver == true{
            scoreLabel?.isHidden = true
            pauseScore?.text = String(score)
            pauseHighScore?.text = String(highScore)
            pauseMenu?.isHidden = false
            if presented != 1{
                //bottomAd.load(GADRequest())
                if score >= 1{
                    ad.present(fromRootViewController: (self.view?.window?.rootViewController)!)
                }
                presented = 1
            }
            if (score > highScore){
                defaults.set(score, forKey: "HIGHSCORE")
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        fingerTouching = true
        sprite.physicsBody?.isResting = false
        sprite.physicsBody?.isDynamic = true
        if gameOver != true{
            let touch = touches.first!
            var location = touch.location(in: mainCamera!)
            location.y += 185
            touchPoint = location
            touching = true
            firstTime?.isHidden = true
        } else if gameOver == true{
            let scene = menuScene(fileNamed: "menuScene")
            scene?.scaleMode = .aspectFill
            view?.presentScene(scene)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameOver != true{
        let touch = touches.first!
        var location = touch.location(in: mainCamera!)
        location.y += 185
        touchPoint = location
        if touching {
            let dt:CGFloat = 1.0/15
            let distance = CGVector(dx: touchPoint.x-sprite.position.x, dy: touchPoint.y-sprite.position.y)
            let velocity = CGVector(dx: distance.dx/dt, dy: distance.dy/dt)
            sprite.physicsBody!.velocity = velocity
        }
        }
    }

    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touching = false;
        //sprite.position.x = touchPoint.x
        //sprite.position.y = touchPoint.y
        //sprite.physicsBody?.isResting = true
        sprite.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        sprite.physicsBody?.isDynamic = false
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if gameOver != true{
        if contact.bodyA.node?.name == "player" && contact.bodyB.node?.name == "circle"{
            let secondBody = contact.bodyB.node as? SKShapeNode
            if sprite.color == secondBody?.fillColor{
                addScore()
                life += 1
            }else{
                if(life >= 10){
                    life -= 3
                }else{
                    life -= 2
                }
            }
            secondBody?.removeFromParent()
            lifeLabel.text = String(life)
        }
        }
        if contact.bodyA.node?.name == "deleter" && contact.bodyB.node?.name == "circle"{
            let deleteBody = contact.bodyB.node as? SKShapeNode
            deleteBody?.removeFromParent()
        }
        
    }
    
    func spawnCirc(){
        if firstTime?.isHidden == true{
        if score >= 5 && score < 10 && id != 1{
            timer1.invalidate()
            timer2 = Timer.scheduledTimer(timeInterval: TimeInterval(0.28), target: self, selector: #selector(GameplayScene.spawnCirc), userInfo: nil, repeats: true)
            id = 1
        }
        if score >= 10 && score < 15 && id != 2{
            timer2.invalidate()
            timer3 = Timer.scheduledTimer(timeInterval: TimeInterval(0.25), target: self, selector: #selector(GameplayScene.spawnCirc), userInfo: nil, repeats: true)
            id = 2
        }
        if score >= 15 && score < 25 && id != 3{
            timer3.invalidate()
            timer4 = Timer.scheduledTimer(timeInterval: TimeInterval(0.22), target: self, selector: #selector(GameplayScene.spawnCirc), userInfo: nil, repeats: true)
            id = 3
        }
        if score >= 25 && score < 35 && id != 4{
            timer4.invalidate()
            timer5 = Timer.scheduledTimer(timeInterval: TimeInterval(0.20), target: self, selector: #selector(GameplayScene.spawnCirc), userInfo: nil, repeats: true)
            id = 4
        }
        if score >= 35 && score < 45 && id != 5{
            timer5.invalidate()
            timer6 = Timer.scheduledTimer(timeInterval: TimeInterval(0.19), target: self, selector: #selector(GameplayScene.spawnCirc), userInfo: nil, repeats: true)
            id = 5
        }
        if score >= 45 && score < 65 && id != 6{
            timer6.invalidate()
            timer7 = Timer.scheduledTimer(timeInterval: TimeInterval(0.18), target: self, selector: #selector(GameplayScene.spawnCirc), userInfo: nil, repeats: true)
            id = 6
        }
        if score >= 65 && score < 85 && id != 7{
            timer7.invalidate()
            timer8 = Timer.scheduledTimer(timeInterval: TimeInterval(0.16), target: self, selector: #selector(GameplayScene.spawnCirc), userInfo: nil, repeats: true)
            id = 7
        }
        if score >= 85 && score < 95 && id != 8{
            timer8.invalidate()
            timer9 = Timer.scheduledTimer(timeInterval: TimeInterval(0.14), target: self, selector: #selector(GameplayScene.spawnCirc), userInfo: nil, repeats: true)
            id = 8
        }
        if score >= 95 && id != 9{
            timer9.invalidate()
            timer10 = Timer.scheduledTimer(timeInterval: TimeInterval(0.11), target: self, selector: #selector(GameplayScene.spawnCirc), userInfo: nil, repeats: true)
            id = 9
        }
        let pos = randomBetweenNum()
        self.scene?.addChild(cir.spawnCircle(pos: pos, camera: mainCamera!))
        }
    }
    
    func changePlayerColor(){
        if gameOver != true{
            warning?.isHidden = false
            let when = DispatchTime.now() + 0.5
            DispatchQueue.main.asyncAfter(deadline: when) {
                let num = arc4random_uniform(5)
                self.sprite.changeColor(color: Int(num))
                self.warning?.isHidden = true
            }
        }
    }

    func addScore(){
        if gameOver != true{
            score += 1
            scoreLabel?.text = String(score)
        }
    }
    
    func addScoreForTime(){
        if gameOver != true && firstTime?.isHidden == true{
            score += 5
            scoreLabel?.text = String(score)
        }
    }
    
    func animateText(){
        if startLabel?.alpha == 1{
            startLabel?.run(fadeOut)
        } else if startLabel?.alpha == 0{
            startLabel?.run(fadeIn)
        }
    }

    func randomBetweenNum() -> CGFloat{
        let randomNum = Int(arc4random_uniform(350))
        let neg = Int(arc4random_uniform(2))
        if neg == 0{
            return CGFloat(randomNum)
        }
        else if neg == 1{
            return CGFloat(-randomNum)
        }else{
            return 0
        }
    }
    
}
