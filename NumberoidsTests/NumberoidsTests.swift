//  Created by Dominik Hauser on 21/05/2021.
//  Copyright © 2021 dasdom. All rights reserved.
//

import XCTest
@testable import Numberoids

class NumberoidsTests: XCTestCase {
  
  var sut: PlusMinusTaskGenerator!
  
  override func setUpWithError() throws {
    sut = PlusMinusTaskGenerator()
  }
  
  override func tearDownWithError() throws {
    sut = nil
  }
  
  func test_evaluate_plusPlus() {
    let calcString = "5+6+7"
    
    let result = sut.evaluate(task: calcString, input: "18")
    
    XCTAssertEqual(result, true)
  }
  
  func test_evaluate_plusMinus() {
    let calcString = "5+6-7"
    
    let result = sut.evaluate(task: calcString, input: "4")
    
    XCTAssertEqual(result, true)
  }
  
  func test_evaluate_minusPlus() {
    let calcString = "7-6+5"
    
    let result = sut.evaluate(task: calcString, input: "6")
    
    XCTAssertEqual(result, true)
  }
  
  func test_evaluate_minusMinus() {
    let calcString = "7-3-2"
    
    let result = sut.evaluate(task: calcString, input: "2")
    
    XCTAssertEqual(result, true)
  }
}
