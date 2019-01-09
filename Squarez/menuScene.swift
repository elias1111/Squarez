//
//  menuScene.swift
//  Squarez
//
//  Created by Elias Stevenson on 6/26/17.
//  Copyright © 2017 Elias Stevenson. All rights reserved.
//

import Foundation
import SpriteKit
import GoogleMobileAds

var scoreLabel: SKLabelNode?
var startLabel: SKLabelNode?
let fadeOut = SKAction.fadeAlpha(to: 0, duration: 0.5)
let fadeIn = SKAction.fadeAlpha(to: 1, duration: 0.5)

class menuScene: SKScene,  GADBannerViewDelegate, SKPaymentTransactionObserver, SKProductsRequestDelegate{
    
    var productsRequest = SKProductsRequest()
    var nonConsumablePurchaseMade = UserDefaults.standard.bool(forKey: "nonConsumablePurchaseMade")
    var productIDs: String = "DJE.premium"
    
    
    func requestProductInfo() {
        if SKPaymentQueue.canMakePayments() {
            let productIdentifiers = productIDs as! Set<String>
            let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
            
            productRequest.delegate = self
            productRequest.start()
        }
        else {
            print("Cannot perform In App Purchases.")
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
    }

    
    
    override func didMove(to view: SKView) {
        let highScore = UserDefaults.standard.integer(forKey: "HIGHSCORE")
        startLabel = scene?.childNode(withName: "starter") as? SKLabelNode!
        scoreLabel = scene?.childNode(withName: "score") as? SKLabelNode!
        scoreLabel?.text = String(highScore)
        
        Timer.scheduledTimer(timeInterval: TimeInterval(0.5), target: self, selector: #selector(menuScene.animateText), userInfo: nil, repeats: true)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            if atPoint(location).name == "topRight" || atPoint(location).name == "premium" || atPoint(location).name == "noads"{
                    print("in app purchase")
                }
            if atPoint(location).name != "topRight" && atPoint(location).name != "premium" && atPoint(location).name != "noads"{
                if let scene = GameplayScene(fileNamed: "GameplayScene"){
                    scene.scaleMode = .aspectFill
                    view?.presentScene(scene, transition: SKTransition.fade(withDuration: TimeInterval(0.5)))
                }

            }
        }
    }
    
    func animateText(){
        if startLabel?.alpha == 1{
            startLabel?.run(fadeOut)
        } else if startLabel?.alpha == 0{
            startLabel?.run(fadeIn)
        }
    }
    
}
