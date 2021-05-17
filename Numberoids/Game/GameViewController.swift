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
    
    contentView.presentStart(animated: false, startHandler: { [weak self] in
      self?.game()
    })
    
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
  
  func start() {
    contentView.presentStart(animated: true, startHandler: { [weak self] in
      self?.game()
    })
  }
  
  func game() {
    contentView.presentGame(gameOverHandler: { [weak self] in
      self?.start()
    })
  }
}
