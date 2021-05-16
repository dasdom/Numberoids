//  Created by Dominik Hauser on 16/05/2021.
//  
//

import SpriteKit

struct PlusTaskGenerator: TaskGeneratorProtocol {
  
  let maxValue: Int
  
  func random() -> SKSpriteNode {
    let sum = Int.random(in: 0...maxValue)
    let firstInt = Int.random(in: 0...sum)
    let secondInt = sum - firstInt
    let string = "\(firstInt)+\(secondInt)"
    
    let texture = SKTexture(image: UIImage(named: "alien_ship")!)
    let node = SKSpriteNode(texture: texture)
    let label = SKLabelNode(text: string)
    label.fontName = "HelveticaNeue-Bold"
    label.position = CGPoint(x: 0, y: -16)
    node.addChild(label)
    node.name = string
    node.physicsBody = SKPhysicsBody(texture: texture, alphaThreshold: 0.1, size: CGSize(width: 140, height: 60))
    node.physicsBody?.affectedByGravity = false
    node.physicsBody?.categoryBitMask = PhysicsCategory.enemy
    node.physicsBody?.contactTestBitMask = PhysicsCategory.bullet | PhysicsCategory.spaceship
    return node
  }
  
  func evaluate(task: SKSpriteNode, input: String) -> Bool {
    guard let name = task.name else {
      return false
    }
    let additionComponents = name.split(separator: "+")
    let calcResult = additionComponents.reduce(0, { result, next in
      let int = Int(next) ?? 0
      return result + int
    })
    return "\(calcResult)" == input
  }
}
