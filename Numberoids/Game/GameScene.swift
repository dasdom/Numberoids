//  Created by Dominik Hauser on 12/05/2021.
//  Copyright © 2021 dasdom. All rights reserved.
//

import SpriteKit
import GameplayKit

enum SpawnRegion {
  case all
  case left
  case right
}

class GameScene: SKScene {
  
  var spaceship: SKSpriteNode?
  var gravityFieldNode: SKFieldNode?
  var inputLabel: SKLabelNode?
  var labelBullet: SKLabelNode?
  var enemies: [SKSpriteNode] = []
  var sparkEmitter: SKEmitterNode?
  var scoreLabel: SKLabelNode?
  var taskGenerator: TaskGeneratorProtocol = FiveDotsTaskGenerator()
  var lifesShips: [SKSpriteNode] = []
  var gameOverHandler: () -> Void = {}
  var level: Int = 1 {
    didSet {
      gravityFieldNode?.isEnabled = false
      showLevelUp()
    }
  }
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
  var numberOfShips: Int = 3 {
    didSet {
      setupLifesShips()
      if numberOfShips > 0 {
        spawnRock()
      } else {
        gameOverHandler()
      }
    }
  }
  var numberOfDestroyedObjects = 0 {
    didSet {
      #if DEBUG
      if [3,6,9,12].contains(numberOfDestroyedObjects) {
        level += 1
      }
      #else
      if [10,20,50,100].contains(numberOfDestroyedObjects) {
        level += 1
      }
      #endif
    }
  }
  var score: Int = 0 {
    didSet {
      scoreLabel?.text = "Score: \(score)"
    }
  }
 
  override func didMove(to view: SKView) {
    
    physicsWorld.contactDelegate = self
    backgroundColor = .black
    
    spaceship = Spaceship()
    if let node = spaceship {
      node.position = CGPoint(x: view.center.x, y: 300)
      addChild(node)
    }
    
    gravityFieldNode = SKFieldNode.radialGravityField()
    if let node = gravityFieldNode {
      node.position = CGPoint(x: view.center.x, y: 300)
      addChild(node)
    }
    
    let dragFieldNode = SKFieldNode.dragField()
    dragFieldNode.position = CGPoint(x: view.center.x, y: 300)
    addChild(dragFieldNode)
    
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
    
    spawnAlien()
    
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
    
    labelBullet = Bullet(text: text)

    if let bullet = labelBullet, let spaceship = spaceship {
      
      let nodes = enemies.filter({ [weak self] node in
        guard let self = self, let task = node.name else { return false }
        return self.taskGenerator.evaluate(task: task, input: text)
      })
      
      let targetPosition: CGPoint
      
      if let node = nodes.first {
        targetPosition = node.position
      } else {
        targetPosition = CGPoint(x: -10, y: spaceship.position.y)
      }
      
      let startPosition = spaceship.position
      
      bullet.position = startPosition
      addChild(bullet)
      
      let distance = hypot(targetPosition.x - startPosition.x, targetPosition.y - startPosition.y)
      let diffX = targetPosition.x - startPosition.x
      //        NSLog("distance \(distance), diffX \(diffX)")
      let alpha: CGFloat = -asin(diffX/distance)
      
      let rotateAction = SKAction.rotate(toAngle: alpha, duration: 0.2)
      let shootAction = SKAction.run({
        let moveAction = SKAction.move(to: targetPosition, duration: Double(distance/self.size.height))
        
        let removeAction = SKAction.run {
          bullet.removeAllActions()
          bullet.removeFromParent()
        }
        bullet.run(SKAction.sequence([moveAction, removeAction]))
      })
      
      spaceship.run(SKAction.sequence([rotateAction, shootAction]))
    }
  }
  
  func spawnAlien(spawnRegion: SpawnRegion = .all) {

    let string = taskGenerator.random()
    
    let spawnPosition = enemySpawnPosition(for: spawnRegion)
    let enemy = Enemy(string: string, type: .alien, position: spawnPosition)
    
    addChild(enemy)
    
    enemies.append(enemy)
    
    enemy.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -10))
  }
  
  func spawnRock(spawnRegion: SpawnRegion = .all) {
    
    let string = taskGenerator.random()

    let spawnPosition = enemySpawnPosition(for: spawnRegion)
    let enemy = Enemy(string: string, type: .rock, position: spawnPosition)
    
    addChild(enemy)
    
    enemies.append(enemy)
    
    enemy.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -10))
  }
  
  func spawnTwoRocks(name: String?, position: CGPoint) {
    
    guard let name = name else {
      return
    }
    
    let components = taskGenerator.components(task: name)
    
    for (index, component) in components.enumerated() {
      
      
      let x = position.x + CGFloat(index) * 60 - 30
      let y = position.y
      let spawnPosition = CGPoint(x: x, y: y)
      let enemy = Enemy(string: component, type: .smallRock, position: spawnPosition)
      
      addChild(enemy)
      
      enemy.physicsBody?.applyImpulse(CGVector(dx: CGFloat(index) * 60 - 30, dy: 0))
      
      for existing in enemies {
        let constraint = SKConstraint.distance(SKRange(lowerLimit: 10), to: enemy)
        if let _ = existing.constraints {
          existing.constraints?.append(constraint)
        } else {
          existing.constraints = [constraint]
        }
      }
      
      enemies.append(enemy)
    }
  }
  
  func enemySpawnPosition(for spawnRegion: SpawnRegion) -> CGPoint {
    let x: CGFloat
    switch spawnRegion {
      case .all:
        x = CGFloat.random(in: 40..<size.width-40)
      case .left:
        x = CGFloat.random(in: 40..<size.width / 2 - 40)
      case .right:
        x = CGFloat.random(in: size.width / 2 + 40..<size.width - 40)
    }
    let height = size.height
    let y = CGFloat.random(in: height-20...height+40)
    return CGPoint(x: x, y: y)
  }
}

extension GameScene: SKPhysicsContactDelegate {
  func didBegin(_ contact: SKPhysicsContact) {
    
    let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
    if collision == PhysicsCategory.enemy | PhysicsCategory.bullet {
                  
      if let node = node(for: PhysicsCategory.enemy, in: contact) as? Enemy {
        
        self.score += 1
        self.numberOfDestroyedObjects += 1

        explosion(at: node.position)
        
        nextEnemy(previous: node)
      }
      
      if let node = node(for: PhysicsCategory.bullet, in: contact) {
        node.removeFromParent()
      }
    } else if collision == PhysicsCategory.enemy | PhysicsCategory.spaceship {
            
      if let node = node(for: PhysicsCategory.enemy, in: contact) {
        cleanUp(enemy: node)
      } else {
        return
      }
      
      if let node = node(for: PhysicsCategory.spaceship, in: contact) {
        
        explosion(at: node.position)
                
        numberOfShips -= 1
      }
    }
  }
  
  func nextEnemy(previous enemy: Enemy) {
    guard let name = enemy.name else {
      return
    }
    let position = enemy.position
    
    cleanUp(enemy: enemy)
    
    switch (enemy.type, level) {
      case (_, 1):
        spawnAlien()
      case (_, 2):
        spawnRock()
      case (_, 3), (.smallRock, 4...):
        if enemies.count < 1 {
          spawnAlien(spawnRegion: .left)
          spawnAlien(spawnRegion: .right)
        }
      case (.alien, 4):
        if enemies.count < 1 {
          spawnRock()
        }
      case (.alien, 5...):
        if enemies.count < 1 {
          spawnRock(spawnRegion: .left)
          spawnRock(spawnRegion: .right)
        }
      case (.rock, 4...):
        if taskGenerator.canSeparate(task: name) {
          spawnTwoRocks(name: name, position: position)
        } else {
          spawnAlien()
        }
      case (.smallRock, 4...):
        if enemies.count < 1 {
          spawnAlien(spawnRegion: .left)
          spawnAlien(spawnRegion: .right)
        }
      default:
        fatalError()
    }
  }
  
  private func explosion(at position: CGPoint) {
    guard let emitterCopy = sparkEmitter?.copy() as? SKEmitterNode else { fatalError() }
    
    emitterCopy.position = position
    addChild(emitterCopy)
    
    emitter = emitterCopy
  }
  
  private func cleanUp(enemy: SKNode) {
    enemies.removeAll(where: { $0 == enemy })
    enemy.removeAllActions()
    enemy.removeFromParent()
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
  
  private func showLevelUp() {
    let levelNode = SKLabelNode(text: "Level \(level)")
    levelNode.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
    levelNode.fontName = "HelveticaNeue-Bold"
    levelNode.fontSize = 60
    addChild(levelNode)
    levelNode.alpha = 0
    levelNode.setScale(0.5)
    let showLevelAction = SKAction.group([
      SKAction.fadeIn(withDuration: 0.5),
      SKAction.scale(to: 1, duration: 0.5)
    ])
    let hideLevelAction = SKAction.group([
      SKAction.fadeOut(withDuration: 0.5),
      SKAction.scale(to: 0.5, duration: 0.5)
    ])
    levelNode.run(SKAction.sequence([
      showLevelAction,
      SKAction.wait(forDuration: 1),
      hideLevelAction,
      SKAction.wait(forDuration: 1),
      SKAction.run({ self.gravityFieldNode?.isEnabled = true }),
      SKAction.removeFromParent()
    ]))
  }
}
