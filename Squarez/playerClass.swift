//
//  playerClass.swift
//  Squarez
//
//  Created by Elias Stevenson on 6/15/17.
//  Copyright © 2017 Elias Stevenson. All rights reserved.
//

import Foundation
import SpriteKit

struct ColliderType{
    static let PLAYER: UInt32 = 0;
    static let CIRCLE: UInt32 = 1;
}

class playerClass: SKSpriteNode{
    
    func initialize(){
        physicsBody?.categoryBitMask = ColliderType.PLAYER
        physicsBody?.contactTestBitMask = ColliderType.CIRCLE
        physicsBody?.allowsRotation = false
        physicsBody?.affectedByGravity = false
        physicsBody?.isDynamic = false
    }
    
    func changeColor(color: Int){
        if color == 0{
            self.color = .magenta
        } else if color == 1{
            self.color = .cyan
        } else if color == 2{
            self.color = .green
        } else if color == 3{
            self.color = .orange
        } else if color == 4{
            self.color = .gray
        }

    }
}
