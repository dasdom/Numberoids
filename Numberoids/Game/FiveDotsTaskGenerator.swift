//  Created by Dominik Hauser on 17/05/2021.
//  Copyright © 2021 dasdom. All rights reserved.
//

import Foundation

struct FiveDotsTaskGenerator: TaskGeneratorProtocol {
 
  let keyboardType: KeyboardType = .five
  let isImage: Bool = false
  
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

  func random() -> (question: String, answer: String) {
    return [(question: "●", answer: "1"),
            (question: "●●", answer: "2"),
            (question: "●●●", answer: "3"),
            (question: "●●●●", answer: "4"),
            (question: "●●●●●", answer: "5")].randomElement() ?? (question: "?", answer: "!")
  }

  func components(task: String) -> [(question: String, answer: String)] {
    switch task {
      case "●":
        return [(question: "●", answer: "1"), (question: "●", answer: "1")]
      case "●●":
        return [(question: "●", answer: "1"), (question: "●", answer: "1")]
      case "●●●":
        return [(question: "●●", answer: "2"), (question: "●", answer: "1")]
      case "●●●●":
        return [(question: "●●", answer: "2"), (question: "●●", answer: "2")]
      case "●●●●●":
        return [(question: "●●●", answer: "3"), (question: "●●", answer: "2")]
      default:
        return [(question: "●", answer: "1")]
    }
  }
}
