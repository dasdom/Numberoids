//  Created by Dominik Hauser on 31.08.21.
//  Copyright © 2021 dasdom. All rights reserved.
//

import Foundation

struct CalcOptions: OptionSet {
  let rawValue: Int

  static let plus = CalcOptions(rawValue: 1 << 0)
  static let minus = CalcOptions(rawValue: 1 << 1)
  static let times = CalcOptions(rawValue: 1 << 2)
  static let over = CalcOptions(rawValue: 1 << 3)

  static let all: CalcOptions = [.plus, .minus, .times, .over]
}

enum CalcSign: String, CaseIterable {
  case plus = "+"
  case minus = "-"
  case times = "×"
  case over = "÷"

  init(question: String) {
    if question.contains(Self.plus.rawValue) {
      self = .plus
    } else if question.contains(Self.minus.rawValue) {
      self = .minus
    } else if question.contains(Self.times.rawValue) {
      self = .times
    } else if question.contains(Self.over.rawValue) {
      self = .over
    } else {
      fatalError()
    }
  }
}

struct BasicMathTaskGenerator: TaskGeneratorProtocol {
  let keyboardType: KeyboardType = .twentyOne
  let maxValue: MaxValue
  var isImage: Bool = false
  let calcOptions: CalcOptions

  init(calcOptions: CalcOptions = .all, maxValue: MaxValue = .oneHundred) {
    self.calcOptions = calcOptions
    self.maxValue = maxValue
  }

  func random() -> (question: String, answer: String) {

    let options = [CalcOptions.plus, .minus, .times, .over].filter({ calcOptions.contains($0) })
    print("options: \(options)")
    let calcOption = options.randomElement() ?? .plus

    switch calcOption {
      case .minus:
        let sum = Int.random(in: 2...maxValue.rawValue)
        let firstInt = Int.random(in: 1...sum-1)
        return (question: "\(sum)-\(firstInt)", answer: "\(sum-firstInt)")
      case .times:
        switch maxValue {
          case .ten, .twenty:
            var product = Int.random(in: 2...maxValue.rawValue)
            let firstInt = Int.random(in: 1...product)
            while product % firstInt != 0 {
              product -= 1
            }
            let secondInt = product / firstInt
            return (question: "\(firstInt)×\(secondInt)", answer: "\(firstInt * secondInt)")
          case .oneHundred:
            let firstInt = Int.random(in: 1...maxValue.rawValue/10)
            let secondInt = Int.random(in: 1...maxValue.rawValue/10)
            return (question: "\(firstInt)×\(secondInt)", answer: "\(firstInt * secondInt)")
          case .fourHundred:
            let firstInt = Int.random(in: 1...maxValue.rawValue/20)
            let secondInt = Int.random(in: 1...maxValue.rawValue/20)
            return (question: "\(firstInt)×\(secondInt)", answer: "\(firstInt * secondInt)")
        }
      case .over:
        switch maxValue {
          case .ten, .twenty:
            var product = Int.random(in: 2...maxValue.rawValue)
            let firstInt = Int.random(in: 1...product)
            while product % firstInt != 0 {
              product -= 1
            }
            let secondInt = product / firstInt
            return (question: "\(product)÷\(secondInt)", answer: "\(product / secondInt)")
          case .oneHundred:
            let firstInt = Int.random(in: 1...maxValue.rawValue/10)
            let secondInt = Int.random(in: 1...maxValue.rawValue/firstInt)
            let product = firstInt * secondInt
            return (question: "\(product)÷\(firstInt)", answer: "\(product / firstInt)")
          case .fourHundred:
            let firstInt = Int.random(in: 1...maxValue.rawValue/20)
            let secondInt = Int.random(in: 1...maxValue.rawValue/firstInt)
            let product = firstInt * secondInt
            return (question: "\(product)÷\(firstInt)", answer: "\(product / firstInt)")
        }
      default:
        let sum = Int.random(in: 2...maxValue.rawValue)
        let firstInt = Int.random(in: 1...sum)
        let secondInt = sum - firstInt
        return (question: "\(firstInt)+\(secondInt)", answer: "\(sum)")
    }
  }

  func canSeparate(task: String) -> Bool {
    return true
  }

  func components(task: String) -> [(question: String, answer: String)] {
    let calcSign = CalcSign(question: task)
    return task.split(separator: Character(calcSign.rawValue)).map({ (question: String($0), answer: String($0)) })
  }
}
