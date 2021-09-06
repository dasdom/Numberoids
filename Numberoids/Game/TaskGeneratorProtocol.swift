//  Created by Dominik Hauser on 16/05/2021.
//  Copyright © 2021 dasdom. All rights reserved.
//

import Foundation

protocol TaskGeneratorProtocol {
  
  var keyboardType: KeyboardType { get }
  var isImage: Bool { get }
  var maxValue: MaxValue { get }
  func random() -> (question: String, answer: String)
//  func evaluate(task: String, input: String) -> Bool
  func canSeparate(task: String) -> Bool
  func components(task: String) -> [(question: String, answer: String)]
}
