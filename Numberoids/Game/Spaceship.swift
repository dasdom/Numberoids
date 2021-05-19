//  Created by Dominik Hauser on 16/05/2021.
//  Copyright © 2021 dasdom. All rights reserved.
//

import SpriteKit

class Spaceship: SKSpriteNode {
  init() {
    
    let texture = SKTexture(image: UIImage(named: "spaceship")!)
    
    let size = texture.size()
    
    super.init(texture: texture, color: .white, size: size)
    
    physicsBody = SKPhysicsBody(rectangleOf: size)
    physicsBody?.affectedByGravity = false
    physicsBody?.categoryBitMask = PhysicsCategory.spaceship
    physicsBody?.isDynamic = false
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
