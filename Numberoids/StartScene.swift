//  Created by Dominik Hauser on 14/05/2021.
//  
//

import SpriteKit

class StartScene: SKScene {
  
  var startButtonNode: SKShapeNode?
  var preSchoolNode: SKShapeNode?
  var upToTwentyPlusNode: SKShapeNode?
  var upToTwentyMinusNode: SKShapeNode?
  var buttons: [SKShapeNode] = []
  var startHandler: (GameMode) -> Void = { _ in }
  
  override func didMove(to view: SKView) {
    
    preSchoolNode = button(text: "Pre School")
    if let node = preSchoolNode {
      node.position = CGPoint(x: view.center.x, y: view.center.y + 30)
      
      addChild(node)
      buttons.append(node)
    }
    
    upToTwentyPlusNode = button(text: "Up To 20 (+)")
    if let node = upToTwentyPlusNode {
      node.position = CGPoint(x: view.center.x, y: view.center.y - 30)
      
      addChild(node)
      buttons.append(node)
    }
    
    upToTwentyMinusNode = button(text: "Up To 20 (-)")
    if let node = upToTwentyMinusNode {
      node.position = CGPoint(x: view.center.x, y: view.center.y - 90)
      
      addChild(node)
      buttons.append(node)
    }
  }
  
  func button(text: String) -> SKShapeNode {
    let node = SKShapeNode(rectOf: CGSize(width: 200, height: 50), cornerRadius: 10)
    node.fillColor = .init(white: 0.1, alpha: 1)
    
    let label = SKLabelNode(text: text)
    label.verticalAlignmentMode = .center
    label.horizontalAlignmentMode = .center
    
    node.addChild(label)
    
    return node
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
        } else if node == upToTwentyMinusNode {
          startHandler(.upToTweentyMinus)
        }
      }
    }
  }
}
