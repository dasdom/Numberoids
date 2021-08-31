//  Created by Dominik Hauser on 21/05/2021.
//  Copyright © 2021 dasdom. All rights reserved.
//

import Foundation

enum QuestionType: Int, CaseIterable {
  case plusPlus
  case plusMinus
  case minusPlus
  case minusMinus
}

struct PlusMinusTaskGenerator: TaskGeneratorProtocol {
  
  let maxValue: Int = 20
  var keyboardType: KeyboadType = .twentyOne
  var isImage: Bool = false
  
  func random() -> (question: String, answer: String) {
    let randomTypeInt = Int.random(in: 0..<QuestionType.allCases.count)
    guard let questionType = QuestionType(rawValue: randomTypeInt) else {
      return ("","")
    }
    print("type: \(questionType)")
    
    let sum1 = Int.random(in: 0...maxValue)
    let firstInt = Int.random(in: 0...sum1)

    let calcString: (question: String, answer: String)
    switch questionType {
      case .plusPlus:
        let secondInt = sum1 - firstInt
        let thirdInt = Int.random(in: 0...(maxValue - sum1))
        calcString = (question: "\(firstInt)+\(secondInt)+\(thirdInt)", answer: "\(firstInt+secondInt+thirdInt)")
      case .plusMinus:
        let secondInt = sum1 - firstInt
        let thirdInt = Int.random(in: 0...sum1)
        calcString = (question: "\(firstInt)+\(secondInt)-\(thirdInt)", answer: "\(firstInt+secondInt-thirdInt)")
      case .minusPlus:
        let secondInt = Int.random(in: 0...(maxValue - (sum1 - firstInt)))
        calcString = (question: "\(sum1)-\(firstInt)+\(secondInt)", answer: "\(sum1-firstInt+secondInt)")
      case .minusMinus:
        let secondInt = Int.random(in: 0...(sum1 - firstInt))
        calcString = (question: "\(sum1)-\(firstInt)-\(secondInt)", answer: "\(sum1-firstInt-secondInt)")
    }
    return calcString
  }
  
  func evaluate(task: String, input: String) -> Bool {
    let result = calcAddition(in: task)
    return "\(result)" == input
  }
  
  private func calcAddition(in string: String) -> Int {
    let additionComponents = string.split(separator: "+").map({ component -> Int in
      if component.contains("-") {
        let subtraction = calcSubstraction(in: String(component))
        return subtraction
      } else {
        return Int(component) ?? 0
      }
    })
    let calcResult = additionComponents.reduce(0, { result, next in
      return result + next
    })
    return calcResult
  }
  
  private func calcSubstraction(in string: String) -> Int {
    let components = string.split(separator: "-")
    guard let first = components.first, let firstInt = Int(first) else {
      return 0
    }
    let calcResult = components.dropFirst().reduce(firstInt, { result, next in
      let int = Int(next) ?? 0
      return result - int
    })
    return calcResult
  }
  
  func canSeparate(task: String) -> Bool {
    true
  }
  
  func components(task: String) -> [(question: String, answer: String)] {
    return task.split(separator: "+").flatMap({ String($0).split(separator: "-").map({ (question: String($0), answer: String($0)) }) })
  }
}
