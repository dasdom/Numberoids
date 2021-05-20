//  Created by Dominik Hauser on 19/05/2021.
//  Copyright © 2021 dasdom. All rights reserved.
//

import SpriteKit

class Bullet: SKLabelNode {

  override init() {
    super.init()
  }
  
  init(text: String) {
    
    super.init(fontNamed: "HelveticaNeue-Bold")

    self.text = text
    
    fontSize = 20
    fontColor = UIColor(named: "bullet_font_color")
    verticalAlignmentMode = .center
    
    physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 20, height: 20))
    physicsBody?.affectedByGravity = false
    physicsBody?.categoryBitMask = PhysicsCategory.bullet
    physicsBody?.contactTestBitMask = PhysicsCategory.enemy
    physicsBody?.isDynamic = false
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError() }
}
