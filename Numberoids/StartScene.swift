//  Created by Dominik Hauser on 14/05/2021.
//  
//

import SpriteKit

class StartScene: SKScene {
  
  var startButtonNode: SKShapeNode?
  var startHandler: () -> Void = {}
  
  override func didMove(to view: SKView) {
    
    startButtonNode = SKShapeNode(rectOf: CGSize(width: 100, height: 50), cornerRadius: 10)
    if let node = startButtonNode {
      node.fillColor = .init(white: 0.1, alpha: 1)
      node.position = view.center
      
      let label = SKLabelNode(text: "Start")
      label.verticalAlignmentMode = .center
      label.horizontalAlignmentMode = .center

      node.addChild(label)
      
      addChild(node)
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    if let position = touches.first?.location(in: self),
       let startButtonNode = startButtonNode {
      
      if startButtonNode.frame.contains(position) {
        let scaleAction = SKAction.scale(by: 0.9, duration: 0.1)
        startButtonNode.run(scaleAction)
      }
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    if let position = touches.first?.location(in: self),
       let startButtonNode = startButtonNode {
      
      if startButtonNode.frame.contains(position) {
        let scaleAction = SKAction.scale(by: 1/0.9, duration: 0.1)
        let startAction = SKAction.run {
          self.startHandler()
        }
        startButtonNode.run(SKAction.sequence([scaleAction, startAction]))
      }
    }
  }
}
