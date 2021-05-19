//  Created by Dominik Hauser on 12/05/2021.
//  Copyright © 2021 dasdom. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
  
  var spaceship: SKSpriteNode?
  var inputLabel: SKLabelNode?
  var labelBullet: SKLabelNode?
  var enemys: [SKSpriteNode] = []
//  var bullet: SKSpriteNode?
  var sparkEmitter: SKEmitterNode?
  var emitter: SKEmitterNode? {
    didSet {
      emitter?.run(SKAction.sequence([
        SKAction.wait(forDuration: 0.5),
        SKAction.run { [weak emitter] in
          emitter?.removeAllActions()
          emitter?.removeFromParent()
        }
      ]))
    }
  }
  var scoreLabel: SKLabelNode?
  var taskGenerator: TaskGeneratorProtocol = FiveDotsTaskGenerator()
  var lifesShips: [SKSpriteNode] = []
  var numberOfShips: Int = 3 {
    didSet {
      setupLifesShips()
      if numberOfShips > 0 {
        spawnEnemy()
      } else {
        gameOverHandler()
      }
    }
  }
  var score: Int = 0 {
    didSet {
      scoreLabel?.text = "Score: \(score)"
    }
  }
  var gameOverHandler: () -> Void = {}
 
  override func didMove(to view: SKView) {
    
    physicsWorld.contactDelegate = self
    backgroundColor = .black
    
    spaceship = Spaceship()
    if let node = spaceship {
      node.position = CGPoint(x: view.center.x, y: 300)
      addChild(node)
    }
    
    inputLabel = SKLabelNode(text: "")
    if let node = inputLabel, let spaceship = spaceship {
      node.verticalAlignmentMode = .top
      node.position = CGPoint(x: 0, y: -40)
      spaceship.addChild(node)
    }
    
    scoreLabel = SKLabelNode(text: "Score: \(score)")
    if let node = scoreLabel {
      node.verticalAlignmentMode = .top
      node.horizontalAlignmentMode = .right
      node.position = CGPoint(x: view.frame.width - 10, y: view.frame.height - 10)
      addChild(node)
    }
    
    spawnEnemy()
    
    sparkEmitter = SKEmitterNode(fileNamed: "spark")
    
    setupLifesShips()
    
    let keyboard = KeyboardNode(size: view.frame.size, type: taskGenerator.keyboardType, textInputHandler: fireBullet(text:))
    keyboard.position = CGPoint(x: 0, y: view.safeAreaInsets.bottom)
    addChild(keyboard)
  }
  
  private func setupLifesShips() {
    
    for node in lifesShips {
      node.removeFromParent()
    }
    
    lifesShips.removeAll()
    
    for i in 0..<numberOfShips {
      let node = SKSpriteNode(imageNamed: "spaceship")
      node.position = CGPoint(x: 20 + 30 * CGFloat(i), y: frame.size.height - 30)
      node.size = CGSize(width: 20, height: 40)
      addChild(node)
      
      lifesShips.append(node)
    }
  }
  
  func fireBullet(text: String) {
    let bulletSize = CGSize(width: 20, height: 20)
    
    labelBullet = SKLabelNode(text: text)

    if let bullet = labelBullet, let spaceship = spaceship {
      bullet.fontName = "HelveticaNeue-Bold"
      bullet.fontSize = 20
      bullet.fontColor = UIColor(named: "bullet_font_color")
      bullet.verticalAlignmentMode = .center
      bullet.physicsBody = SKPhysicsBody(rectangleOf: bulletSize)
      bullet.physicsBody?.affectedByGravity = false
      bullet.physicsBody?.categoryBitMask = PhysicsCategory.bullet
      bullet.physicsBody?.contactTestBitMask = PhysicsCategory.enemy
      bullet.physicsBody?.isDynamic = false
      
      let nodes = enemys.filter({ [weak self] node in
        guard let self = self, let task = node.name else { return false }
        return self.taskGenerator.evaluate(task: task, input: text)
      })
      
      if let node = nodes.first {
        let targetPosition = node.position
        let startPosition = spaceship.position
        
        bullet.position = startPosition
        addChild(bullet)
        
        let distance = hypot(targetPosition.x - startPosition.x, targetPosition.y - startPosition.y)
        let diffX = targetPosition.x - startPosition.x
//        NSLog("distance \(distance), diffX \(diffX)")
        let alpha: CGFloat
//        if diffX > 0 {
          alpha = -asin(diffX/distance)
//        } else {
//          alpha = asin(diffX/distance)
//        }
//        NSLog("alpha \(alpha), \(alpha * 180 / CGFloat.pi)")
        
        let rotateAction = SKAction.rotate(byAngle: alpha, duration: 0.2)
        let shootAction = SKAction.run({
          let moveAction = SKAction.move(to: targetPosition, duration: Double(distance/self.size.height))
          
          let scoreAction = SKAction.run {
            self.score += 1
            bullet.removeFromParent()
          }
          
          bullet.run(SKAction.sequence([moveAction, scoreAction]))
        })
        
        let waitAction = SKAction.wait(forDuration: 0.5)
        let rotateBackAction = SKAction.rotate(byAngle: -alpha, duration: 0.3)
        
        spaceship.run(SKAction.sequence([rotateAction, shootAction, waitAction, rotateBackAction]))
        
                
      } else if let firstEnemy = enemys.first {
        bullet.position = spaceship.position
        addChild(bullet)
        
        let position =  CGPoint(x: firstEnemy.position.x - firstEnemy.size.width - 300, y: size.height + 100)
        let moveAction = SKAction.move(to: position, duration: 1)
        
        let scoreAction = SKAction.run {
          self.score -= 1
          bullet.removeFromParent()
        }
        
        bullet.run(SKAction.sequence([moveAction, scoreAction]))
      }
    }
  }
  
//  func spawnEnemies(_ number: Int) {
//    for i in 0..<number {
//      DispatchQueue.main.asyncAfter(deadline: .now() + 4 * TimeInterval(i), execute: spawnEnemy)
//    }
//  }
  
  func spawnEnemy() {

    print("spawn Enemy")
    let string = taskGenerator.random()
    
    let enemy = Enemy(string: string, type: .smallRock)
    
    let x = CGFloat.random(in: 40..<size.width-40)
    let height = size.height
    let y = CGFloat.random(in: height-20...height+40)
    enemy.position = CGPoint(x: x, y: y)
    
    addChild(enemy)
    
    enemys.append(enemy)
    
    if let spaceship = spaceship {
      let duration = Double.random(in: 15...20)
      let action = SKAction.move(to: spaceship.position, duration: duration)
      enemy.run(action)
    }
  }
}

extension GameScene: SKPhysicsContactDelegate {
  func didBegin(_ contact: SKPhysicsContact) {
    
    let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
    if collision == PhysicsCategory.enemy | PhysicsCategory.bullet {
            
      guard let emitterCopy = sparkEmitter?.copy() as? SKEmitterNode else { fatalError() }
      
      if let emitter = emitter {
        emitter.removeFromParent()
      }
            
      if let node = node(for: PhysicsCategory.enemy, in: contact) {
        emitterCopy.position = node.position
        addChild(emitterCopy)

        emitter = emitterCopy

        node.removeAllActions()
        node.removeFromParent()
        
        enemys.removeAll(where: { $0 == node })
        
        if enemys.isEmpty {
          spawnEnemy()
        }
      }
      
      if let node = node(for: PhysicsCategory.bullet, in: contact) {
        node.removeFromParent()
      }
    } else if collision == PhysicsCategory.enemy | PhysicsCategory.spaceship {
      
      guard let emitterCopy = sparkEmitter?.copy() as? SKEmitterNode else { fatalError() }
      
      if let emitter = emitter {
        emitter.removeFromParent()
      }
            
      if let node = node(for: PhysicsCategory.enemy, in: contact) {
        node.removeAllActions()
        node.removeFromParent()
        enemys.removeAll(where: { $0 == node })
      } else {
        return
      }
      
      if let node = node(for: PhysicsCategory.spaceship, in: contact) {
        emitterCopy.position = node.position
        addChild(emitterCopy)
        emitter = emitterCopy
                
        numberOfShips -= 1
      }
      
    }
  }
  
  private func node(for category: UInt32, in contact: SKPhysicsContact) -> SKNode? {
    
    let node: SKNode?
    if contact.bodyA.categoryBitMask == category {
      node = contact.bodyA.node
    } else if contact.bodyB.categoryBitMask == category {
      node = contact.bodyB.node
    } else {
      node = nil
    }
    return node
  }
}
