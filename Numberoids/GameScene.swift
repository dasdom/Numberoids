//  Created by Dominik Hauser on 12/05/2021.
//  
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
  var emitter: SKEmitterNode?
  var scoreLabel: SKLabelNode?
  var score: Int = 0 {
    didSet {
      scoreLabel?.text = "Score: \(score)"
    }
  }
 
  override func didMove(to view: SKView) {
    
    physicsWorld.contactDelegate = self
    
    spaceship = SKSpriteNode(color: .gray, size: CGSize(width: 20, height: 30))
    if let node = spaceship {
      node.anchorPoint = CGPoint(x: 0.5, y: 0)
      node.position = CGPoint(x: view.center.x, y: 300)
      addChild(node)
    }
    
    inputLabel = SKLabelNode(text: "")
    if let node = inputLabel, let spaceship = spaceship {
      node.verticalAlignmentMode = .top
      node.position = CGPoint(x: 0, y: -10)
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
  }
  
  func fireBullet(text: String) {
    let bulletSize = CGSize(width: 20, height: 20)
    
    labelBullet = inputLabel?.copy() as? SKLabelNode
    labelBullet?.fontName = "HelveticaNeue-Bold"
    labelBullet?.fontColor = UIColor(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
    labelBullet?.physicsBody = SKPhysicsBody(rectangleOf: bulletSize)
    labelBullet?.physicsBody?.affectedByGravity = false
    labelBullet?.physicsBody?.categoryBitMask = PhysicsCategory.bullet
    labelBullet?.physicsBody?.contactTestBitMask = PhysicsCategory.enemy
    
    if let bullet = labelBullet, let spaceship = spaceship {
      
      let nodes = enemys.filter({ node in
        if let calcString = node.name {
          let result = calculate(calcString)
          return text == result
        } else {
          return false
        }
      })
      
      if let node = nodes.first {
        let targetPosition = node.position
        let startPosition = spaceship.position
        
        bullet.position = startPosition
        addChild(bullet)
        
        let distance = hypot(targetPosition.x - startPosition.x, targetPosition.y - startPosition.y)
        
        let moveAction = SKAction.move(to: targetPosition, duration: Double(distance/size.height))
        
        let scoreAction = SKAction.run {
          self.score += 1
          bullet.removeFromParent()
        }
        
        bullet.run(SKAction.sequence([moveAction, scoreAction]))
        
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
  
  func calculate(_ string: String) -> String {
    let additionComponents = string.split(separator: "+")
    let calcResult = additionComponents.reduce(0, { result, next in
      let int = Int(next) ?? 0
      return result + int
    })
    return "\(calcResult)"
  }
  
  func spawnEnemy() {
    let sum = Int.random(in: 0...20)
    let firstInt = Int.random(in: 0...sum)
    let secondInt = sum - firstInt
    let string = "\(firstInt)+\(secondInt)"
    
    let texture = SKTexture(image: UIImage(named: "spaceship")!)
    let hostNode = SKSpriteNode(texture: texture)
    let label = SKLabelNode(text: string)
    label.fontName = "HelveticaNeue-Bold"
    label.position = CGPoint(x: 0, y: -16)
    let x = CGFloat.random(in: 40..<size.width-40)
    let height = size.height
    let y = CGFloat.random(in: height-20...height+40)
    hostNode.addChild(label)
    hostNode.position = CGPoint(x: x, y: y)
    hostNode.name = string
    hostNode.physicsBody = SKPhysicsBody(texture: texture, alphaThreshold: 0.1, size: CGSize(width: 140, height: 60))
    hostNode.physicsBody?.affectedByGravity = false
    hostNode.physicsBody?.categoryBitMask = PhysicsCategory.enemy
    hostNode.physicsBody?.contactTestBitMask = PhysicsCategory.bullet
    addChild(hostNode)
    
    enemys.append(hostNode)
    
    if let spaceship = spaceship {
      let duration = Double.random(in: 15...20)
      let action = SKAction.move(to: spaceship.position, duration: duration)
      hostNode.run(action)
    }
  }
}

extension GameScene: SKPhysicsContactDelegate {
  func didBegin(_ contact: SKPhysicsContact) {
    
    let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
    if collision == PhysicsCategory.enemy | PhysicsCategory.bullet {
      
      //      guard let emitterCopy = sparkEmitter?.copy() as? SKEmitterNode else { fatalError() }
      guard let emitterCopy = SKEmitterNode(fileNamed: "spark") else { return }
      
      if let emitter = emitter {
        emitter.removeFromParent()
      }
      
      let enemyNode: SKSpriteNode?
      
      if contact.bodyA.categoryBitMask == PhysicsCategory.enemy {
        enemyNode = contact.bodyA.node as? SKSpriteNode
      } else if contact.bodyB.categoryBitMask == PhysicsCategory.enemy {
        enemyNode = contact.bodyB.node as? SKSpriteNode
      } else {
        enemyNode = nil
      }
      
      if let node = enemyNode {
        emitterCopy.position = node.position
        addChild(emitterCopy)
        emitter = emitterCopy
        
        node.removeFromParent()
        enemys.removeAll(where: { $0 == node })
        
        spawnEnemy()
      }
    }
  }
}
