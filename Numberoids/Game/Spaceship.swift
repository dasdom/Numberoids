//  Created by Dominik Hauser on 16/05/2021.
//  
//

import SpriteKit

class Spaceship: SKSpriteNode {
  init(texture: SKTexture?) {
    
    let size = texture?.size() ?? CGSize(width: 1, height: 1)
    
    super.init(texture: texture, color: .white, size: size)
    
    if let texture = texture {
      physicsBody = SKPhysicsBody(texture: texture, alphaThreshold: 0.1, size: CGSize(width: 60, height: 60))
    }
    physicsBody?.affectedByGravity = false
    physicsBody?.categoryBitMask = PhysicsCategory.spaceship
    physicsBody?.isDynamic = false
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
