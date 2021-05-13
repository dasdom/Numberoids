//  Created by Dominik Hauser on 12/05/2021.
//  
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
  
  var spaceship: SKSpriteNode?
  var inputLabel: SKLabelNode?
 
  override func didMove(to view: SKView) {
    
    spaceship = SKSpriteNode(color: .gray, size: CGSize(width: 20, height: 30))
    if let node = spaceship {
      node.position = view.center
      addChild(node)
    }
    
    inputLabel = SKLabelNode(text: "")
    if let node = inputLabel {
      node.position = CGPoint(x: view.center.x, y: view.center.y - 80)
      addChild(node)
    }
  }
}
