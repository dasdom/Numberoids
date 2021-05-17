//  Created by Dominik Hauser on 16/05/2021.
//  
//

import SpriteKit

struct PlusTaskGenerator: TaskGeneratorProtocol {
  
  let maxValue: Int
  let keyboardType: KeyboadType = .twentyOne
  let isImage: Bool = false
  
  func random() -> String {
    let sum = Int.random(in: 0...maxValue)
    let firstInt = Int.random(in: 0...sum)
    let secondInt = sum - firstInt
    return "\(firstInt)+\(secondInt)"
  }
  
  func evaluate(task: String, input: String) -> Bool {
    let additionComponents = task.split(separator: "+")
    let calcResult = additionComponents.reduce(0, { result, next in
      let int = Int(next) ?? 0
      return result + int
    })
    return "\(calcResult)" == input
  }
}
