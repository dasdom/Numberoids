//  Created by Dominik Hauser on 13/05/2021.
//  
//

import UIKit
import SpriteKit

enum InputButtonType: String {
  case zero
  case one
  case two
  case three
  case four
  case five
  case six
  case seven
  case eight
  case nine
  case delete
  case fire
  
  var tag: Int {
    let tag: Int
    switch self {
      case .zero:
        tag = 0
      case .one:
        tag = 1
      case .two:
        tag = 2
      case .three:
        tag = 3
      case .four:
        tag = 4
      case .five:
        tag = 5
      case .six:
        tag = 6
      case .seven:
        tag = 7
      case .eight:
        tag = 8
      case .nine:
        tag = 9
      case .delete:
        tag = 101
      case .fire:
        tag = 102
    }
    return tag
  }
  
  var title: String {
    let title: String
    switch self {
      case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine:
        title = "\(self.tag)"
      case .delete:
        title = "⌫"
      case .fire:
        title = "🔥"
    }
    return title
  }
}

class GameView: SKView {

  let gameScene: GameScene
  let numberButtons: [UIButton]
  let fireButton: UIButton
  let deleteButton: UIButton
  private let spacing: CGFloat = 5
  
  override init(frame: CGRect) {
    
    gameScene = GameScene(size: frame.size)
    
    let button: (InputButtonType) -> UIButton = { type in
      let button = UIButton(type: .system)
      button.backgroundColor = .init(white: 0.1, alpha: 1)
      button.setTitleColor(.white, for: .normal)
      button.tag = type.tag
      button.setTitle(type.title, for: .normal)
      button.titleLabel?.font = .preferredFont(forTextStyle: .largeTitle)
      return button
    }
    
    var firstRowNumberButtons: [UIButton] = []
    [InputButtonType.zero, .one, .two, .three, .four].forEach { type in
      let button = button(type)
      firstRowNumberButtons.append(button)
    }
    
    deleteButton = UIButton(type: .system)
    deleteButton.backgroundColor = .init(white: 0.1, alpha: 1)
    deleteButton.setTitleColor(.white, for: .normal)
    deleteButton.tag = InputButtonType.delete.tag
    deleteButton.setTitle(InputButtonType.delete.title, for: .normal)
    deleteButton.titleLabel?.font = .preferredFont(forTextStyle: .largeTitle)
    
    let topStackView = UIStackView(arrangedSubviews: firstRowNumberButtons)
    topStackView.distribution = .fillEqually
    topStackView.spacing = spacing
    
    var secondRowNumberButtons: [UIButton] = []
    [InputButtonType.five, .six, .seven, .eight, .nine].forEach { type in
      let button = button(type)
      secondRowNumberButtons.append(button)
    }
    
    numberButtons = firstRowNumberButtons + secondRowNumberButtons
    
    fireButton = UIButton(type: .system)
    fireButton.backgroundColor = .init(white: 0.1, alpha: 1)
    fireButton.setTitleColor(.white, for: .normal)
    fireButton.tag = InputButtonType.fire.tag
    fireButton.setTitle(InputButtonType.fire.title, for: .normal)
    fireButton.titleLabel?.font = .preferredFont(forTextStyle: .largeTitle)

    let bottomStackView = UIStackView(arrangedSubviews: secondRowNumberButtons)
    bottomStackView.distribution = .fillEqually
    bottomStackView.spacing = spacing
    
    let numberButtonsStackView = UIStackView(arrangedSubviews: [topStackView, bottomStackView])
    numberButtonsStackView.axis = .vertical
    numberButtonsStackView.distribution = .fillEqually
    numberButtonsStackView.spacing = spacing
    
    let numberAndDeleteStackView = UIStackView(arrangedSubviews: [numberButtonsStackView, deleteButton])
    numberAndDeleteStackView.spacing = spacing
    
    let stackView = UIStackView(arrangedSubviews: [numberAndDeleteStackView, fireButton])
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.spacing = spacing
    
    super.init(frame: frame)
    
    gameScene.scaleMode = .aspectFill
    
    presentScene(gameScene)
        
//    ignoresSiblingOrder = true
//    showsPhysics = true
    showsFPS = true
    showsNodeCount = true
    
    addSubview(stackView)
    
    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
      stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
      stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
      
      topStackView.heightAnchor.constraint(equalToConstant: 60),
      bottomStackView.heightAnchor.constraint(equalTo: topStackView.heightAnchor),
      
      deleteButton.widthAnchor.constraint(equalToConstant: frame.width/8),
      fireButton.heightAnchor.constraint(equalTo: topStackView.heightAnchor),
    ])
  }
  
  required init?(coder: NSCoder) { fatalError() }
  
}
