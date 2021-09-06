//  Created by Dominik Hauser on 13/05/2021.
//  
//

import Foundation

enum PhysicsCategory {
  static let enemy:     UInt32 = 0b0001
  static let bullet:    UInt32 = 0b0010
  static let spaceship: UInt32 = 0b0100
  static let keyboard:  UInt32 = 0b1000
}
