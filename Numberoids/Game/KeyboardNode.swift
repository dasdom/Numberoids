//  Created by Dominik Hauser on 16/05/2021.
//  Copyright © 2021 dasdom. All rights reserved.
//

import SpriteKit

class KeyboardNode: SKSpriteNode {
  
  let textInputHandler: (String) -> Void
  private let height: CGFloat = 60
  private let gap: CGFloat = 5
  private var keys: [SKShapeNode] = []

  init(size: CGSize, type: KeyboardType, textInputHandler: @escaping (String) -> Void) {
    
    self.textInputHandler = textInputHandler
    
    let keyboardSize = CGSize(width: size.width, height: height + 2 * gap)
    
    super.init(texture: nil, color: .black, size: keyboardSize)

    color = .gray
    isUserInteractionEnabled = true
//    anchorPoint = CGPoint(x: 0, y: 0)
    
    switch type {
      case .twentyOne:
        twentyOne()
      case .five:
        five()
    }

    physicsBody = SKPhysicsBody(rectangleOf: keyboardSize)
    physicsBody?.isDynamic = false
    physicsBody?.categoryBitMask = PhysicsCategory.keyboard
    physicsBody?.contactTestBitMask = PhysicsCategory.enemy
  }

  required init?(coder aDecoder: NSCoder) { fatalError() }

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
      label.fontName = "HelveticaNeue-Medium"
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
        label.fontName = "HelveticaNeue-Medium"
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
    label.fontName = "HelveticaNeue-Medium"
    label.horizontalAlignmentMode = .center
    label.verticalAlignmentMode = .center
    
    key.addChild(label)
    
    let x = size.width / 2
    let y: CGFloat = gap + height / 2
    key.position = CGPoint(x: x, y: y)
    
    addChild(key)
    keys.append(key)
  }

  func updateKeys(answers: [String], maxValue: Int) {
    let numberOfKeysInRow: CGFloat = 6
//    let numberOfRows: CGFloat = 2
    let numberOfKeys = Int(numberOfKeysInRow)

    for key in keys {
      key.removeFromParent()
    }

    keys.removeAll()

    var allPossibleAnswers = Set(answers)
    while allPossibleAnswers.count < numberOfKeys {
      let offset = Int.random(in: -5...5)
      if let randomElement = allPossibleAnswers.randomElement(), let intRandomElement = Int(randomElement) {
        let newElement = intRandomElement + offset
        if newElement < 0 || newElement > maxValue {
          continue
        }
        let newElementString = "\(newElement)"
        if false == allPossibleAnswers.contains(newElementString) {
          allPossibleAnswers.insert(newElementString)
        }
      }
    }
    print("\(allPossibleAnswers)")

    let sortedPossibleAnswers = allPossibleAnswers.sorted(by: { Int($0)! < Int($1)! })

    let width = (size.width - (numberOfKeysInRow + 1) * gap) / numberOfKeysInRow

    for (index, value) in sortedPossibleAnswers.enumerated() {

      let key = SKShapeNode(rectOf: CGSize(width: width, height: height))
      key.fillColor = UIColor(named: "button_color") ?? .yellow
      key.strokeColor = .clear
      let name = value
      key.name = name

      let label = SKLabelNode(text: name)
      label.fontName = "HelveticaNeue-Medium"
      label.horizontalAlignmentMode = .center
      label.verticalAlignmentMode = .center

      key.addChild(label)

      let x = gap + CGFloat((index) % 10) * (width + gap) + width / 2 - size.width / 2
      let y: CGFloat = gap + height / 2 - size.height / 2
      key.position = CGPoint(x: x, y: y)

      addChild(key)
      keys.append(key)
    }
  }

  func disableKeys() {
    alpha = 0.5
    isUserInteractionEnabled = false
  }

  func enableKeys() {
    alpha = 1
    isUserInteractionEnabled = true
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    if let position = touches.first?.location(in: self) {
      if let node = keys.filter({ $0.calculateAccumulatedFrame().contains(position) }).first {
        node.run(SKAction.sequence([
          SKAction.scale(to: 0.9, duration: 0.05),
          SKAction.scale(to: 1, duration: 0.05)
        ]))
        
        if let name = node.name {
          NSLog("\(name)")
          textInputHandler(name)
        }
      }
    }
  }
}
