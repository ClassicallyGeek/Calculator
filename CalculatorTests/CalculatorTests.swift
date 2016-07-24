//
//  CalculatorTests.swift
//  CalculatorTests
//
//  Created by Ashley on 7/24/16.
//

import XCTest

class CalculatorTests: XCTestCase {
    
    func testDescription() {
        // touching 7 + shows "7 + ..." with 7 still in the display
        let brain = CalculatorBrain()
        brain.setOperand(7)
        brain.performOperation("+")
        XCTAssertEqual(brain.description, "7 + ")
        XCTAssertEqua(brain.result, 7.0)
    }
}
