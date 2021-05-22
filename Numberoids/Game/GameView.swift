//  Created by Dominik Hauser on 13/05/2021.
//  Copyright © 2021 dasdom. All rights reserved.
//

import UIKit
import SpriteKit

class GameView: SKView {

  var startScene: StartScene?
  var gameScene: GameScene?
  
  override init(frame: CGRect) {
    
    super.init(frame: frame)
        
//    ignoresSiblingOrder = true
//    showsPhysics = true
    showsFPS = true
    showsNodeCount = true
//    showsFields = true
  }
  
  required init?(coder: NSCoder) { fatalError() }
  
  func presentGame(taskGenerator: TaskGeneratorProtocol, gameOverHandler: @escaping () -> Void) {
    
    gameScene = GameScene(size: frame.size)
    gameScene?.taskGenerator = taskGenerator

    if let scene = gameScene {
      scene.gameOverHandler = gameOverHandler
      scene.scaleMode = .aspectFill
      presentScene(scene, transition: .fade(with: .black, duration: 1))
    }
  }
  
  func presentStart(animated: Bool, startHandler: @escaping (GameMode) -> Void) {
    
    startScene = StartScene(size: frame.size)
    
    if let scene = startScene {
      scene.startHandler = startHandler
      scene.scaleMode = .aspectFill

      if animated {
        presentScene(scene, transition: .fade(with: .black, duration: 1))
      } else {
        presentScene(scene)
      }
    }
  }
}
