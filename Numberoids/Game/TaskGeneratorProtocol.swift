//  Created by Dominik Hauser on 16/05/2021.
//  
//

import SpriteKit

protocol TaskGeneratorProtocol {
  
  var keyboardType: KeyboadType { get }
  var isImage: Bool { get }
  func random() -> String
  func evaluate(task: String, input: String) -> Bool
}
