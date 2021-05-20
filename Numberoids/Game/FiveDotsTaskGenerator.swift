//  Created by Dominik Hauser on 17/05/2021.
//  Copyright © 2021 dasdom. All rights reserved.
//

import Foundation

struct FiveDotsTaskGenerator: TaskGeneratorProtocol {
 
  let keyboardType: KeyboadType = .five
  let isImage: Bool = false
  
  func random() -> String {
    return ["●","●●","●●●","●●●●","●●●●●"].randomElement() ?? "?"
  }
  
  func evaluate(task: String, input: String) -> Bool {
    switch task {
      case "●":
        return input == "1"
      case "●●":
        return input == "2"
      case "●●●":
        return input == "3"
      case "●●●●":
        return input == "4"
      case "●●●●●":
        return input == "5"
      default:
        return false
    }
  }
  
  func canSeparate(task: String) -> Bool {
    if task == "●" {
      return false
    } else {
      return true
    }
  }
  
  func components(task: String) -> [String] {
    switch task {
      case "●":
        return ["●", "●"]
      case "●●":
        return ["●", "●"]
      case "●●●":
        return ["●●", "●"]
      case "●●●●":
        return ["●●", "●●"]
      case "●●●●●":
        return ["●●●", "●●"]
      default:
        return ["●"]
    }
  }
}
