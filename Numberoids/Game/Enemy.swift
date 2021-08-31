//  Created by Dominik Hauser on 19/05/2021.
//  Copyright © 2021 dasdom. All rights reserved.
//

import SpriteKit

enum EnemyType {
  case alien
  case rock
  case smallRock
  
  var name: String {
    let name: String
    switch self {
      case .alien:
        name = "alien_ship"
      case .rock:
        name = "rock"
      case .smallRock:
        name = "small_rock"
    }
    return name
  }
}

class Enemy: SKSpriteNode {
  
  let type: EnemyType
  let answer: String

  init(string: String, answer: String, type: EnemyType, position: CGPoint) {
    
    self.type = type
    self.answer = answer
    
    let texture = SKTexture(image: UIImage(named: type.name)!)
    let label = SKLabelNode(text: string)
    label.fontName = "HelveticaNeue-Bold"
    label.position = CGPoint(x: 0, y: -4)
    label.horizontalAlignmentMode = .center
    label.verticalAlignmentMode = .center
      
    super.init(texture: texture, color: .white, size: texture.size())

    self.position = position

    addChild(label)
    name = string
    physicsBody = SKPhysicsBody(rectangleOf: texture.size())
    physicsBody?.affectedByGravity = false
    physicsBody?.categoryBitMask = PhysicsCategory.enemy
    physicsBody?.contactTestBitMask = PhysicsCategory.bullet | PhysicsCategory.spaceship
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError() }
}
