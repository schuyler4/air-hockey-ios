//
//  GameScene.swift
//  air-hockey
//
//  Created by Marek Newton on 2/5/17.
//  Copyright © 2017 Marek Newton. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var courtLine : SKShapeNode?
    var goal1: SKShapeNode?
    var goal2: SKShapeNode?
    
    var player: SKShapeNode?
    var enemy: SKShapeNode?
    
    var puck: SKShapeNode?
    
    var enemySpeed: CGFloat?
    
    var playerScore: Int?
    var enemyScore: Int?
    
    var playerScoreLabel: SKLabelNode?
    var enemyScoreLabel: SKLabelNode?
    
    var restartButton: SKShapeNode?
    var restartButtonText: SKLabelNode?
    var winnerText: SKLabelNode?
    
    var gameGoing: Bool?

    override func didMove(to view: SKView) {
        self.view?.isMultipleTouchEnabled = false
        self.view?.backgroundColor =  UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        physicsWorld.contactDelegate = self
        self.size = view.bounds.size
        
        enemySpeed = 600
        
        playerScore = 0
        enemyScore = 0
        
        playerScoreLabel = SKLabelNode(fontNamed: "Arial")
        playerScoreLabel?.text = String(describing: playerScore!)
        playerScoreLabel?.fontSize = 65
        playerScoreLabel?.fontColor = SKColor.white
        playerScoreLabel?.position = CGPoint(x: frame.midX + (playerScoreLabel?.frame.width)! - 2,
                                y: self.size.height / 2 - (playerScoreLabel?.frame.height)!)
        
        enemyScoreLabel = SKLabelNode(fontNamed: "Arial")
        enemyScoreLabel?.text = String(describing: enemyScore!)
        enemyScoreLabel?.fontSize = 65
        enemyScoreLabel?.fontColor = SKColor.white
        enemyScoreLabel?.position = CGPoint(x: frame.midX - (enemyScoreLabel?.frame.width)! - 2,
                                y: self.size.height / 2 - (enemyScoreLabel?.frame.height)!)
        
        courtLine = SKShapeNode(rectOf: CGSize(width: 10, height: self.size.height))
        courtLine?.name = "courtLine"
        courtLine?.fillColor = SKColor.white
        courtLine?.position = CGPoint(x: 0, y: 0)
    
        goal1 = SKShapeNode(rectOf: CGSize(width: 10, height: self.size.width / 8))
        goal1?.name = "goal1"
        goal1?.fillColor = SKColor.white
        goal1?.position = CGPoint(x: self.size.width / 2 - 8, y: 0)
        goal1?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: (goal1?.frame.width)!, height: (goal1?.frame.height)!))
        goal1?.physicsBody?.isDynamic = false
        goal1?.physicsBody!.contactTestBitMask = (goal1?.physicsBody!.collisionBitMask)!
        
        goal2 = SKShapeNode(rectOf: CGSize(width: 10, height: self.size.width / 8))
        goal2?.name = "goal2"
        goal2?.fillColor = SKColor.white
        goal2?.position = CGPoint(x: -self.size.width / 2 + 8, y: 0)
        goal2?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: (goal2?.frame.width)!, height: (goal2?.frame.height)!))
        goal2?.physicsBody?.isDynamic = false
        goal2?.physicsBody!.contactTestBitMask = (goal2?.physicsBody!.collisionBitMask)!
        
        player = SKShapeNode(circleOfRadius: 20)
        player?.name = "player"
        player?.fillColor = SKColor.red
        player?.strokeColor = SKColor.red
        player?.physicsBody = SKPhysicsBody(circleOfRadius:((player?.frame.size.width)! - 1.0) / 2.0)
        player?.physicsBody!.isDynamic = true
        player?.physicsBody?.affectedByGravity = false
        player?.physicsBody!.contactTestBitMask = (player?.physicsBody!.collisionBitMask)!
        
        puck = SKShapeNode(circleOfRadius: 10)
        puck?.name = "puck"
        puck?.fillColor = SKColor.yellow
        puck?.strokeColor = SKColor.yellow
        puck?.position = CGPoint(x: 0, y: 0)
        puck?.physicsBody = SKPhysicsBody(circleOfRadius:((puck?.frame.size.width)! - 1.0) / 2.0)
        puck?.physicsBody!.isDynamic = true
        puck?.physicsBody!.affectedByGravity = false
        puck?.physicsBody!.contactTestBitMask = (puck?.physicsBody!.collisionBitMask)!
        
        enemy = SKShapeNode(circleOfRadius: 20)
        enemy?.name = "enemy"
        enemy?.fillColor = SKColor.blue
        enemy?.strokeColor = SKColor.blue
        enemy?.position = CGPoint(x: -self.size.width / 4, y: 0)
        enemy?.physicsBody = SKPhysicsBody(circleOfRadius: ((enemy?.frame.size.width)! - 1.0) / 2.0)
        enemy?.physicsBody?.isDynamic = true
        enemy?.physicsBody?.affectedByGravity = false
        enemy?.physicsBody!.contactTestBitMask = (enemy?.physicsBody!.collisionBitMask)!
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.isDynamic = false
        self.name = "wall"
        self.physicsBody?.contactTestBitMask = (self.physicsBody!.collisionBitMask)
        
        self.addChild(courtLine!)
        self.addChild(goal1!)
        self.addChild(goal2!)
        
        self.addChild(puck!)
        self.addChild(enemy!)
        
        self.addChild(playerScoreLabel!)
        self.addChild(enemyScoreLabel!)
        
        gameGoing = true
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let playerScored: Bool = contact.bodyA.node?.name == "goal2" && contact.bodyB.node?.name == "puck" ||
            contact.bodyA.node?.name == "puck" && contact.bodyB.node?.name == "goal2"
        let enemyScored: Bool = contact.bodyA.node?.name == "goal1" && contact.bodyB.node?.name == "puck" ||
            contact.bodyA.node?.name == "puck" && contact.bodyB.node?.name == "goal1"
        
        if playerScored {
            scored(scoreToIncrease: "player")
        } else if enemyScored {
            scored(scoreToIncrease: "enemy")
        }
        
        let puckWithPlayer: Bool = contact.bodyA.node?.name == "puck" && contact.bodyB.node?.name == "player"
        let puckWithEnemy: Bool = contact.bodyA.node?.name == "puck" && contact.bodyB.node?.name == "enemy"
        
        if(puckWithPlayer || puckWithEnemy) {
            
            if Float((puck?.position.x)!) > Float((player?.position.x)!) {
                puck?.physicsBody?.velocity.dx = 1000
            } else if Float((puck?.position.x)!) < Float((player?.position.x)!) {
                puck?.physicsBody?.velocity.dx = -1000
            }
            
            if Float((puck?.position.y)!) > Float((player?.position.y)!) {
                puck?.physicsBody?.velocity.dy = 1000
            } else if Float((puck?.position.y)!) < Float((player?.position.y)!) {
               puck?.physicsBody?.velocity.dy = -1000
            }
            
        }
        
    }
    
    func showResetButton(winner: String) {
        gameGoing = false
        
        player?.removeFromParent()
        puck?.removeFromParent()
        enemy?.removeFromParent()
        
        restartButton = SKShapeNode(rectOf: CGSize(width: 200, height: 50))
        restartButton?.fillColor = SKColor.red
        restartButton?.position = CGPoint(x: 0, y: 0)
        
        winnerText = SKLabelNode(fontNamed: "Arial")
        
        if winner == "player" {
            winnerText?.text = "You won!"
            winnerText?.fontColor = SKColor.red
        } else if winner == "enemy" {
            winnerText?.text = "you lost!"
            winnerText?.fontColor = SKColor.blue
        }
        
        winnerText?.fontSize = 65
        winnerText?.position = CGPoint(x: 0, y: frame.midY + 50)
        
        restartButtonText = SKLabelNode(fontNamed: "Arial")
        restartButtonText?.text = "Play Again"
        restartButtonText?.fontSize = 30
        restartButtonText?.fontColor = SKColor.white
        restartButtonText?.position = CGPoint(x: 0, y: 0 - 10)
        
        
        self.addChild(restartButton!)
        self.addChild(winnerText!)
        self.addChild(restartButtonText!)
    }
    
    func scored(scoreToIncrease: String) {
        if scoreToIncrease == "player" {
            playerScore! += 1
            playerScoreLabel?.text = String(playerScore!)
        } else if scoreToIncrease == "enemy" {
            enemyScore! += 1
            enemyScoreLabel?.text = String(enemyScore!)
        }
        
        resetScene()

        if playerScore! >= 10 {
            showResetButton(winner: "player")
        } else if enemyScore! >= 10 {
            showResetButton(winner: "enemy")
        }
    }
    
    func resetScene() {
        puck?.removeFromParent()
        puck?.position = CGPoint(x: 0, y: 0)
        self.addChild(puck!)
        enemy?.removeFromParent()
        enemy?.position = CGPoint(x: -self.size.width / 4, y: 0)
        self.addChild(enemy!)
        player?.position = CGPoint(x: self.size.width / 4, y: 0)
        enemy?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        puck?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
    }
    
    func resetGame() {
        playerScore = 0
        enemyScore = 0
        playerScoreLabel?.text = String(playerScore!)
        enemyScoreLabel?.text = String(enemyScore!)
        restartButton?.removeFromParent()
        restartButtonText?.removeFromParent()
        winnerText?.removeFromParent()
        gameGoing = true
        resetScene()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if gameGoing! {
                player?.position = touch.location(in: self)
                self.addChild(player!)
            } else {
                if (restartButton?.contains(touch.location(in: self)))! {
                    resetGame()
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            if gameGoing! {
                player?.position = touch.location(in: self)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       player?.removeFromParent()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        player?.removeFromParent()
    }
    
    func moveEnemy() {
        if Float((enemy?.position.x)!) > Float(((puck?.position.x)!)) {
            enemy?.physicsBody?.velocity = CGVector(dx: -enemySpeed!, dy: 0)
        } else if Float((enemy?.position.x)!) < Float(((puck?.position.x)!)) {
            if (enemy?.position.x)! < self.frame.midX {
                enemy?.physicsBody?.velocity.dx = enemySpeed!
            }
            if (puck?.position.y)! < 0 + 50 && (puck?.position.y)! > 0 - 50 {
                if Float((enemy?.position.y)!) < Float(((puck?.position.y)!)) {
                    enemy?.physicsBody?.velocity.dy = enemySpeed!
                }  else if Float((enemy?.position.y)!) > Float(((puck?.position.y)!)) {
                    enemy?.physicsBody?.velocity.dy =  -enemySpeed!
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        moveEnemy()
    }
}
