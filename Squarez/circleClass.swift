//
//  circleClass.swift
//  Squarez
//
//  Created by Elias Stevenson on 6/19/17.
//  Copyright © 2017 Elias Stevenson. All rights reserved.
//

import Foundation
import SpriteKit

class circleClass: SKTextureAtlas{
    var circle: SKShapeNode? = nil
    
    func spawnCircle(pos: CGFloat, camera: SKCameraNode) -> SKShapeNode{
        circle = SKShapeNode(circleOfRadius: 15)
        circle?.name = "circle"
        circle?.lineWidth = 0.5
        let color = rand()
        if color == 0{
            circle?.fillColor = .magenta
            circle?.strokeColor = .magenta
        } else if color == 1{
            circle?.fillColor = .cyan
            circle?.strokeColor = .cyan
        } else if color == 2{
            circle?.fillColor = .green
            circle?.strokeColor = .green
        } else if color == 3{
            circle?.fillColor = .orange
            circle?.strokeColor = .orange
        } else if color == 4{
            circle?.fillColor = .gray
            circle?.strokeColor = .gray
        }
        circle?.position.x = pos
        circle?.zPosition = 2
        circle?.position.y = camera.position.y + 700
        circle?.physicsBody?.isDynamic = false
        circle?.physicsBody?.allowsRotation = false
        circle?.physicsBody = SKPhysicsBody(circleOfRadius: 15)
        circle?.physicsBody?.affectedByGravity = true
        circle?.physicsBody?.contactTestBitMask = ColliderType.CIRCLE
        //removeFromParent()
        return circle!
    }
    
    func rand() -> Int{
        let num = arc4random_uniform(5)
        return Int(num)
    }
}
