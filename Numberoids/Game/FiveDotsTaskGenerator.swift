//  Created by Dominik Hauser on 17/05/2021.
//  
//

import Foundation

struct FiveDotsTaskGenerator: TaskGeneratorProtocol {
 
  var keyboardType: KeyboadType = .five
  var isImage: Bool = false
  
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
  
  
}
