//
//  GameScene.swift
//  ColorSlide
//
//  Created by Dustin Jones on 1/15/17.
//  Copyright © 2017 Dustin Jones. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var spinnySqaure : SKShapeNode?
    private var Circle : SKShapeNode?
    
    override func sceneDidLoad() {

        self.lastUpdateTime = 0
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnySqaure = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w))
        
        if let spinnySqaure = self.spinnySqaure {
            spinnySqaure.lineWidth = 2.5
            
            spinnySqaure.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(M_PI), duration: 1)))
            spinnySqaure.run(SKAction.sequence([SKAction.wait(forDuration: 0.5)]))
            spinnySqaure.run(SKAction.sequence([SKAction.wait(forDuration: 0.5), SKAction.fadeOut(withDuration: 2),SKAction.removeFromParent()]))
        }
        self.Circle = SKShapeNode.init(circleOfRadius: w * 0.5)
        
        if let circle = self.Circle {
            circle.lineWidth = 2.5
            circle.run(SKAction.sequence([SKAction.wait(forDuration: 0.5), SKAction.fadeOut(withDuration: 2),SKAction.removeFromParent()]))
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        switch Int(arc4random_uniform(2)){
            case 0:
                if let n = self.spinnySqaure?.copy() as! SKShapeNode? {
                    n.position = pos
                    n.strokeColor = SKColor.green
                    self.addChild(n)
                }
                break
            case 1:
                if let n = self.Circle?.copy() as! SKShapeNode? {
                    n.position = pos
                    n.strokeColor = SKColor.green
                    self.addChild(n)
                }
                break
            default:
                break
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnySqaure?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnySqaure?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}
