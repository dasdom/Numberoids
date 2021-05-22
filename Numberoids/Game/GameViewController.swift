//  Created by Dominik Hauser on 12/05/2021.
//  Copyright © 2021 dasdom. All rights reserved.
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
    
    contentView.presentStart(animated: false, startHandler: { [weak self] mode in
      self?.game(mode: mode)
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
    contentView.presentStart(animated: true, startHandler: { [weak self] mode in
      self?.game(mode: mode)
    })
  }
  
  func game(mode: GameMode) {
    let taskGenerator: TaskGeneratorProtocol
    switch mode {
      case .preschool:
        taskGenerator = FiveDotsTaskGenerator()
      case .upToTwentyPlus:
        taskGenerator = PlusTaskGenerator()
      case .upToTwentyMinus:
        taskGenerator = MinusTaskGenerator()
      case .upToTwentyPlusMinus:
        taskGenerator = PlusMinusTaskGenerator()
    }
    contentView.presentGame(taskGenerator: taskGenerator, gameOverHandler: { [weak self] in
      self?.start()
    })
  }
}
