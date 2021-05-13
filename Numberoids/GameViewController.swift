//  Created by Dominik Hauser on 12/05/2021.
//  
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
  
  let oneButton: UIButton = UIButton(type: .system)
  var contentView: GameView {
    return view as! GameView
  }
  
  override func loadView() {
    let contentView = GameView(frame: UIScreen.main.bounds)
    
    contentView.numberButtons.forEach { button in
      button.addTarget(self, action: #selector(addNumber(_:)), for: .touchUpInside)
    }
    
    contentView.fireButton.addTarget(self, action: #selector(fire(_:)), for: .touchUpInside)
    contentView.deleteButton.addTarget(self, action: #selector(deleteLastCharacter(_:)), for: .touchUpInside)

    view = contentView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
  }
  
  override var shouldAutorotate: Bool {
    return true
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .landscape
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
}

extension GameViewController {
  @objc func addNumber(_ sender: UIButton) {
    let text = contentView.gameScene.inputLabel?.text ?? ""
    contentView.gameScene.inputLabel?.text = text + "\(sender.tag)"
  }
  
  @objc func fire(_ sender: UIButton) {
    if let text = contentView.gameScene.inputLabel?.text, false == text.isEmpty {
      contentView.gameScene.fireBullet(text: text)
    }
    contentView.gameScene.inputLabel?.text = ""
  }
  
  @objc func deleteLastCharacter(_ sender: UIButton) {
    if let text = contentView.gameScene.inputLabel?.text, false == text.isEmpty {
      contentView.gameScene.inputLabel?.text = String(text.dropLast())
    }
  }
}
