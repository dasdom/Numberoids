//  Created by Dominik Hauser on 16/05/2021.
//  
//

import Foundation

protocol TaskSelectionProtocol {
  
  associatedtype Task
  associatedtype Input
  
  func random() -> Task
  func evaluate(task: Task, input: Input) -> Bool
}
