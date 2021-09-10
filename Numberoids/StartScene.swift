//  Created by Dominik Hauser on 14/05/2021.
//  
//

import SpriteKit

enum MaxValue: Int {
  case ten = 10
  case twenty = 20
  case oneHundred = 100
  case fourHundred = 400

  var text: String {
    return "\(rawValue)"
  }
}

class StartScene: SKScene {

  var plusButtonNode: SKShapeNode?
  var minusButtonNode: SKShapeNode?
  var timesButtonNode: SKShapeNode?
  var overButtonNode: SKShapeNode?

  var tenButtonNode: SKShapeNode?
  var twentyButtonNode: SKShapeNode?
  var oneHundredButtonNode: SKShapeNode?
  var twoHundredButtonNode: SKShapeNode?

  var startButtonNode: SKShapeNode?

  var buttons: [SKShapeNode] = []
  var calcOptions: CalcOptions = .plus
  var maxValue: MaxValue = .twenty
  var startHandler: (CalcOptions, MaxValue) -> Void = { _, _ in }
  
  override func didMove(to view: SKView) {

    let label = SKLabelNode(text: "Numberoids")
//    label.fontName = "Menlo-Bold"
    label.fontSize = 80
    label.position = CGPoint(x: view.center.x, y: view.center.y+140)
    label.horizontalAlignmentMode = .center
    label.verticalAlignmentMode = .center
    addChild(label)

    var buttonNode = button(text: CalcSign.plus.rawValue)
    let leftX = view.frame.width/2 - 1.5 * buttonNode.frame.width - 30
    let interButtonGap: CGFloat = 10
    let rightX = view.frame.width/2 + 0.5 * buttonNode.frame.width + 15
    buttonNode.position = CGPoint(x: leftX, y: view.center.y)
    addChild(buttonNode)
    buttons.append(buttonNode)
    plusButtonNode = buttonNode

    buttonNode = button(text: CalcSign.minus.rawValue)
    buttonNode.position = CGPoint(x: leftX + interButtonGap + buttonNode.frame.width, y: view.center.y)
    addChild(buttonNode)
    buttons.append(buttonNode)
    minusButtonNode = buttonNode

    buttonNode = button(text: CalcSign.times.rawValue)
    buttonNode.position = CGPoint(x: leftX, y: view.center.y - buttonNode.frame.height - 10)
    addChild(buttonNode)
    buttons.append(buttonNode)
    timesButtonNode = buttonNode

    buttonNode = button(text: CalcSign.over.rawValue)
    buttonNode.position = CGPoint(x: leftX + interButtonGap + buttonNode.frame.width, y: view.center.y - buttonNode.frame.height - 10)
    addChild(buttonNode)
    buttons.append(buttonNode)
    overButtonNode = buttonNode

    buttonNode = button(text: MaxValue.ten.text)
    buttonNode.position = CGPoint(x: rightX, y: view.center.y)
    addChild(buttonNode)
    buttons.append(buttonNode)
    tenButtonNode = buttonNode

    buttonNode = button(text: MaxValue.twenty.text)
    buttonNode.position = CGPoint(x: rightX + buttonNode.frame.width + 10, y: view.center.y)
    addChild(buttonNode)
    buttons.append(buttonNode)
    twentyButtonNode = buttonNode

    buttonNode = button(text: MaxValue.oneHundred.text)
    buttonNode.position = CGPoint(x: rightX, y: view.center.y - buttonNode.frame.height - 10)
    addChild(buttonNode)
    buttons.append(buttonNode)
    oneHundredButtonNode = buttonNode

    buttonNode = button(text: MaxValue.fourHundred.text)
    buttonNode.position = CGPoint(x: rightX + buttonNode.frame.width + 10, y: view.center.y - buttonNode.frame.height - 10)
    addChild(buttonNode)
    buttons.append(buttonNode)
    twoHundredButtonNode = buttonNode

    buttonNode = button(text: "Start", width: 200)
    buttonNode.position = CGPoint(x: view.center.x, y: view.center.y - 2 * buttonNode.frame.height - 40)
    addChild(buttonNode)
    buttons.append(buttonNode)
    startButtonNode = buttonNode

    updateButtons()
  }

  func updateButtons() {

    let selectedColor = UIColor(white: 0.3, alpha: 1)
    let normalColor = UIColor(white: 0.1, alpha: 1)

    if calcOptions.contains(.plus) {
      plusButtonNode?.fillColor = selectedColor
    } else {
      plusButtonNode?.fillColor = normalColor
    }
    if calcOptions.contains(.minus) {
      minusButtonNode?.fillColor = selectedColor
    } else {
      minusButtonNode?.fillColor = normalColor
    }
    if calcOptions.contains(.times) {
      timesButtonNode?.fillColor = selectedColor
    } else {
      timesButtonNode?.fillColor = normalColor
    }
    if calcOptions.contains(.over) {
      overButtonNode?.fillColor = selectedColor
    } else {
      overButtonNode?.fillColor = normalColor
    }

    [tenButtonNode, twentyButtonNode, oneHundredButtonNode, twoHundredButtonNode].forEach { node in
      node?.fillColor = normalColor
    }

    switch maxValue {
      case .ten:
        tenButtonNode?.fillColor = selectedColor
      case .twenty:
        twentyButtonNode?.fillColor = selectedColor
      case .oneHundred:
        oneHundredButtonNode?.fillColor = selectedColor
      case .fourHundred:
        twoHundredButtonNode?.fillColor = selectedColor
    }
  }
  
  func button(text: String, width: CGFloat = 100) -> SKShapeNode {
    let node = SKShapeNode(rectOf: CGSize(width: width, height: 50), cornerRadius: 10)
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
    
    if let position = touches.first?.location(in: self) {

      let previousOptions = calcOptions

      if let node = buttons.filter({ $0.frame.contains(position) }).first {
        let scaleAction = SKAction.scale(by: 1/0.95, duration: 0.1)
        node.run(scaleAction)

        if node == startButtonNode {
          startHandler(calcOptions, maxValue)
          return
        }

        switch node {
          case plusButtonNode:
            if calcOptions.contains(.plus) {
              calcOptions.remove(.plus)
            } else {
              calcOptions.insert(.plus)
            }
          case minusButtonNode:
            if calcOptions.contains(.minus) {
              calcOptions.remove(.minus)
            } else {
              calcOptions.insert(.minus)
            }
          case timesButtonNode:
            if calcOptions.contains(.times) {
              calcOptions.remove(.times)
            } else {
              calcOptions.insert(.times)
            }
          case overButtonNode:
            if calcOptions.contains(.over) {
              calcOptions.remove(.over)
            } else {
              calcOptions.insert(.over)
            }
          case tenButtonNode:
            maxValue = .ten
          case twentyButtonNode:
            maxValue = .twenty
          case oneHundredButtonNode:
            maxValue = .oneHundred
          case twoHundredButtonNode:
            maxValue = .fourHundred
          default:
            break
        }

      }

      if calcOptions.isEmpty {
        calcOptions = previousOptions
      }

      updateButtons()
    }
  }
}
