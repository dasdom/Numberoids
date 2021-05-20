//  Created by Dominik Hauser on 14/05/2021.
//  
//

import SpriteKit

class StartScene: SKScene {
  
  var startButtonNode: SKShapeNode?
  var upToTwentyPlusNode: SKShapeNode?
  var preSchoolNode: SKShapeNode?
  var buttons: [SKShapeNode] = []
  var startHandler: (GameMode) -> Void = { _ in }
  
  override func didMove(to view: SKView) {
    
//    startButtonNode = SKShapeNode(rectOf: CGSize(width: 200, height: 50), cornerRadius: 10)
//    if let node = startButtonNode {
//      node.fillColor = .init(white: 0.1, alpha: 1)
//      node.position = view.center
//
//      let label = SKLabelNode(text: "Start")
//      label.verticalAlignmentMode = .center
//      label.horizontalAlignmentMode = .center
//
//      node.addChild(label)
//
//      addChild(node)
//    }
    
    upToTwentyPlusNode = SKShapeNode(rectOf: CGSize(width: 200, height: 50), cornerRadius: 10)
    if let node = upToTwentyPlusNode {
      node.fillColor = .init(white: 0.1, alpha: 1)
      node.position = CGPoint(x: view.center.x, y: view.center.y - 30)
      
      let label = SKLabelNode(text: "Up To 20 (+)")
      label.verticalAlignmentMode = .center
      label.horizontalAlignmentMode = .center
      
      node.addChild(label)
      
      addChild(node)
      
      buttons.append(node)
    }
    
    preSchoolNode = SKShapeNode(rectOf: CGSize(width: 200, height: 50), cornerRadius: 10)
    if let node = preSchoolNode {
      node.fillColor = .init(white: 0.1, alpha: 1)
      node.position = CGPoint(x: view.center.x, y: view.center.y + 30)
      
      let label = SKLabelNode(text: "Pre School")
      label.verticalAlignmentMode = .center
      label.horizontalAlignmentMode = .center
      
      node.addChild(label)
      
      addChild(node)
      
      buttons.append(node)
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    if let position = touches.first?.location(in: self) {
      if let node = buttons.filter({ $0.frame.contains(position) }).first {
        let scaleAction = SKAction.scale(by: 0.95, duration: 0.1)
        node.run(scaleAction)
      }
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    if let position = touches.first?.location(in: self),
       let upToTwentyPlusNode = upToTwentyPlusNode,
       let preSchoolNode = preSchoolNode {
      
      if let node = buttons.filter({ $0.frame.contains(position) }).first {
        let scaleAction = SKAction.scale(by: 1/0.95, duration: 0.1)
        node.run(scaleAction)
        
        if node == preSchoolNode {
          startHandler(.preschool)
        } else if node == upToTwentyPlusNode {
          startHandler(.upToTweentyPlus)
        }
      }
    }
  }
}
