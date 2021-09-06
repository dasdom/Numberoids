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
  var enemies: [Enemy] = []
  var sparkEmitter: SKEmitterNode?
  var scoreLabel: SKLabelNode?
  var taskGenerator: TaskGeneratorProtocol = FiveDotsTaskGenerator()
  var lifesShips: [SKSpriteNode] = []
  var gameOverHandler: () -> Void = {}
  var keyboard: KeyboardNode?
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
        spawnEnemy(type: .rock)
        updateKeyboard()
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
      node.position = CGPoint(x: view.center.x, y: 0)
      addChild(node)
    }
    
//    let dragFieldNode = SKFieldNode.dragField()
//    dragFieldNode.position = CGPoint(x: view.center.x, y: 300)
//    addChild(dragFieldNode)
    
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

//    spawnEnemy(type: .alien)

    sparkEmitter = SKEmitterNode(fileNamed: "spark")
    
    setupLifesShips()
    
    let _keyboard = KeyboardNode(size: view.frame.size, type: taskGenerator.keyboardType, textInputHandler: fireBullet(text:))
    let keyboardSize = _keyboard.size
    _keyboard.position = CGPoint(x: keyboardSize.width/2, y: view.safeAreaInsets.bottom + keyboardSize.height/2)
    addChild(_keyboard)
    keyboard = _keyboard

    spawnEnemy(type: .alien)

    updateKeyboard()
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

    keyboard?.disableKeys()

    labelBullet = Bullet(text: text)

    if let bullet = labelBullet, let spaceship = spaceship {
      
      let nodes = enemies.filter({ node in
        return node.answer == text
      })
      
      let targetPosition: CGPoint
      
      if let node = nodes.first {
        targetPosition = node.position
      } else {
        showNotCorrect()
        return
      }
      
      let startPosition = spaceship.position
      
      bullet.position = startPosition
      addChild(bullet)
      
      let distance = hypot(targetPosition.x - startPosition.x, targetPosition.y - startPosition.y)
      let diffX = targetPosition.x - startPosition.x
      //        NSLog("distance \(distance), diffX \(diffX)")
      let alpha: CGFloat = -asin(diffX/distance)
      
      let rotateAction = SKAction.rotate(toAngle: alpha, duration: 0.15)
      let shootAction = SKAction.run({
        let moveAction = SKAction.move(to: targetPosition, duration: Double(distance/self.size.height/2))
        
        let removeAction = SKAction.run {
          bullet.removeAllActions()
          bullet.removeFromParent()
          self.keyboard?.enableKeys()
        }
        bullet.run(SKAction.sequence([moveAction, removeAction]))
      })
      
      spaceship.run(SKAction.sequence([rotateAction, shootAction]))
    }
  }

  func updateKeyboard() {
    let answers = enemies.map({ $0.answer })
    print("answers: \(answers)")

    keyboard?.updateKeys(answers: answers)
  }
  
  func spawnEnemy(spawnRegion: SpawnRegion = .all, type: EnemyType) {

    let (question, answer) = taskGenerator.random()
    
    let spawnPosition = enemySpawnPosition(for: spawnRegion)
    let enemy = Enemy(string: question, answer: answer, type: type, position: spawnPosition)
    
    insertChild(enemy, at: 1)
    
    enemies.append(enemy)
    
    enemy.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -level*8))
  }
  
  func spawnTwoRocks(name: String?, position: CGPoint) {
    
    guard let name = name else {
      return
    }
    
    let components = taskGenerator.components(task: name)
    
    for (index, (answer, question)) in components.enumerated() {

      let x = position.x + CGFloat(index) * 60 - 30
      let y = position.y
      let spawnPosition = CGPoint(x: x, y: y)
      let enemy = Enemy(string: question, answer: answer, type: .smallRock, position: spawnPosition)
      
      addChild(enemy)
      
      enemy.physicsBody?.applyImpulse(CGVector(dx: CGFloat(index) * 20 - 10, dy: 0))
      
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
        
        self.score += level
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
    } else if collision == PhysicsCategory.enemy | PhysicsCategory.keyboard {

      if let node = node(for: PhysicsCategory.enemy, in: contact) as? Enemy {

        explosion(at: node.position)

        nextEnemy(previous: node)
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
        spawnEnemy(type: .alien)
        updateKeyboard()
      case (_, 2):
        spawnEnemy(type: .rock)
        updateKeyboard()
      case (_, 3), (.smallRock, 4...):
        if enemies.count < 1 {
          spawnEnemy(spawnRegion: .left, type: .alien)
          spawnEnemy(spawnRegion: .right, type: .alien)
          updateKeyboard()
        }
      case (.alien, 4):
        if enemies.count < 1 {
          spawnEnemy(type: .rock)
          updateKeyboard()
        }
      case (.alien, 5...):
        if enemies.count < 1 {
          spawnEnemy(spawnRegion: .left, type: .rock)
          spawnEnemy(spawnRegion: .right, type: .rock)
          updateKeyboard()
        }
      case (.rock, 4...):
        if taskGenerator.canSeparate(task: name) {
          spawnTwoRocks(name: name, position: position)
        } else {
          spawnEnemy(type: .alien)
        }
        updateKeyboard()
      case (.smallRock, 4...):
        if enemies.count < 1 {
          spawnEnemy(spawnRegion: .left, type: .alien)
          spawnEnemy(spawnRegion: .right, type: .alien)
          updateKeyboard()
        }
      default:
        fatalError()
    }

    keyboard?.enableKeys()
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

  private func showNotCorrect() {
    let levelNode = SKLabelNode(text: "Not correct 😟")
    levelNode.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
    levelNode.fontName = "HelveticaNeue-Bold"
    levelNode.fontSize = 60
    addChild(levelNode)
    levelNode.alpha = 0
    levelNode.setScale(0.5)
    let showLevelAction = SKAction.group([
      SKAction.fadeIn(withDuration: 0.2),
      SKAction.scale(to: 1, duration: 0.2)
    ])
    let hideLevelAction = SKAction.group([
      SKAction.fadeOut(withDuration: 0.5),
      SKAction.scale(to: 0.5, duration: 0.5),
      SKAction.run {
        self.keyboard?.enableKeys()
      },
    ])
    levelNode.run(SKAction.sequence([
      showLevelAction,
      SKAction.wait(forDuration: 1),
      hideLevelAction,
      SKAction.wait(forDuration: 0.5),
      SKAction.run({
        self.gravityFieldNode?.isEnabled = true
      }),
      SKAction.removeFromParent()
    ]))
  }
}
