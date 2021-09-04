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
    
    contentView.presentStart(animated: false, startHandler: { [weak self] calcOptions, maxValue in
      self?.game(calcOptions: calcOptions, maxValue: maxValue)
    })
    
    view = contentView
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
    contentView.presentStart(animated: true, startHandler: { [weak self] calcOptions, maxValue in
      self?.game(calcOptions: calcOptions, maxValue: maxValue)
    })
  }
  
  func game(calcOptions: CalcOptions, maxValue: MaxValue) {
    let taskGenerator = BasicMathTaskGenerator(calcOptions: calcOptions, maxValue: maxValue)
    contentView.presentGame(taskGenerator: taskGenerator, gameOverHandler: { [weak self] in
      self?.start()
    })
  }
}
