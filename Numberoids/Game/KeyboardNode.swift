//  Created by Dominik Hauser on 16/05/2021.
//  
//

import SpriteKit

class KeyboardNode: SKSpriteNode {
  
  let textInputHandler: (String) -> Void
  private let height: CGFloat = 50
  private let gap: CGFloat = 5
  private var keys: [SKShapeNode] = []

  init(size: CGSize, type: KeyboadType, textInputHandler: @escaping (String) -> Void) {
    
    self.textInputHandler = textInputHandler
    
    let keyboardSize = CGSize(width: size.width, height: 3 * height + 4 * gap)
    
    super.init(texture: nil, color: .black, size: keyboardSize)
    
    isUserInteractionEnabled = true
    anchorPoint = CGPoint(x: 0, y: 0)
    
    switch type {
      case .twentyOne:
        twentyOne()
      case .five:
        five()
    }
  }
  
  func five() {
    let numberOfKeysInRow: CGFloat = 5
    let width = (size.width - (numberOfKeysInRow + 1) * gap) / numberOfKeysInRow
    for i in 1...5 {
      
      let key = SKShapeNode(rectOf: CGSize(width: width, height: height))
      key.fillColor = UIColor(named: "button_color") ?? .yellow
      key.strokeColor = .clear
      let name = "\(i)"
      key.name = name
      
      let label = SKLabelNode(text: name)
      label.horizontalAlignmentMode = .center
      label.verticalAlignmentMode = .center
      
      key.addChild(label)
      
      let x = gap + CGFloat((i - 1) % 10) * (width + gap) + width / 2
      let y: CGFloat = gap + height / 2
      key.position = CGPoint(x: x, y: y)
      
      addChild(key)
      keys.append(key)
    }
  }
  
  func twentyOne() {
    let width = (size.width - 11 * gap) / 10
    for j in [0,1] {
      let start = j * 10 + 1
      let end = 10 * (j+1)
      for i in start...end {
        
        let key = SKShapeNode(rectOf: CGSize(width: width, height: height))
        key.fillColor = UIColor(named: "button_color") ?? .yellow
        key.strokeColor = .clear
        let name = "\(i)"
        key.name = name
        
        let label = SKLabelNode(text: name)
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        
        key.addChild(label)
        
        let x = gap + CGFloat((i - 1) % 10) * (width + gap) + width / 2
        let y: CGFloat = gap + height / 2 + CGFloat(j+1) * (height + gap)
        key.position = CGPoint(x: x, y: y)
        
        addChild(key)
        keys.append(key)
      }
    }
    
    let key = SKShapeNode(rectOf: CGSize(width: size.width - 2 * gap, height: height))
    key.fillColor = UIColor(named: "button_color") ?? .yellow
    key.strokeColor = .clear
    let name = "0"
    key.name = name
    
    let label = SKLabelNode(text: name)
    label.horizontalAlignmentMode = .center
    label.verticalAlignmentMode = .center
    
    key.addChild(label)
    
    let x = size.width / 2
    let y: CGFloat = gap + height / 2
    key.position = CGPoint(x: x, y: y)
    
    addChild(key)
    keys.append(key)
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError() }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    if let position = touches.first?.location(in: self) {
      if let node = keys.filter({ $0.frame.contains(position) }).first {
        let scaleAction = SKAction.scale(by: 0.95, duration: 0.1)
        node.run(scaleAction)
      }
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    if let position = touches.first?.location(in: self) {
      if let node = keys.filter({ $0.frame.contains(position) }).first {
        let scaleAction = SKAction.scale(by: 1.0/0.95, duration: 0.1)
        node.run(scaleAction)
        if let name = node.name {
          NSLog("\(name)")
          textInputHandler(name)
        }
      }
    }
  }
}
