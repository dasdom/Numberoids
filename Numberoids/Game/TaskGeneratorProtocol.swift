//  Created by Dominik Hauser on 16/05/2021.
//  
//

import SpriteKit

protocol TaskGeneratorProtocol {
  
  func random() -> SKSpriteNode
  func evaluate(task: SKSpriteNode, input: String) -> Bool
}
