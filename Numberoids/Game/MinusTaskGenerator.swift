//  Created by Dominik Hauser on 21/05/2021.
//  Copyright © 2021 dasdom. All rights reserved.
//

import Foundation

struct MinusTaskGenerator: TaskGeneratorProtocol {
  
  let maxValue: Int = 20
  var keyboardType: KeyboadType = .twentyOne
  var isImage: Bool = false
  
  func random() -> (question: String, answer: String) {
    let sum = Int.random(in: 0...maxValue)
    let firstInt = Int.random(in: 0...sum-1)
    return (question: "\(sum)-\(firstInt)", answer: "\(sum-firstInt)")
  }
  
  func evaluate(task: String, input: String) -> Bool {
    let components = task.split(separator: "-")
    guard let first = components.first, let firstInt = Int(first) else {
      return false
    }
    let calcResult = components.dropFirst().reduce(firstInt, { result, next in
      let int = Int(next) ?? 0
      return result - int
    })
    return "\(calcResult)" == input
  }
  
  func canSeparate(task: String) -> Bool {
    return true
  }
  
  func components(task: String) -> [(question: String, answer: String)] {
    return task.split(separator: "-").map({ (question: String($0), answer: String($0)) })
  }
}
