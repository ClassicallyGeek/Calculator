//
//  CalculatorTests.swift
//  CalculatorTests
//
//  Created by Ashley on 7/24/16.
//

import XCTest

class CalculatorTests: XCTestCase {
    
    func testInitialValues() {
        let brain = CalculatorBrain()
        XCTAssertEqual(brain.result, 0.0)
        XCTAssertEqual(brain.isPartialResult, false)
        XCTAssertEqual(brain.description, "0")
    }
    
    func testPartialResult() {
        let brain = CalculatorBrain()
        brain.setOperand(5)
        brain.performOperation("×")
        brain.setOperand(3)
        XCTAssertEqual(brain.isPartialResult, true)
        brain.performOperation("=")
        XCTAssertEqual(brain.isPartialResult, false)
    }
    
    func testDescription() {
        // a. touching 7 + shows "7 + ..." with 7 still in the display TODO will need an ... eventually
        let brain = CalculatorBrain()
        brain.setOperand(7)
        brain.performOperation("+")
        XCTAssertEqual(brain.description, "7 + ")
        XCTAssertEqual(brain.result, 7.0)
        
        // c. 7 + 9 = shows "7 + 9 " TODO will need an = eventually
        brain.setOperand(9)
        brain.performOperation("=")
        XCTAssertEqual(brain.description, "7 + 9")
        XCTAssertEqual(brain.result, 16.0)
        
        // d. 7 + 9 = √
        brain.performOperation("√")
        XCTAssertEqual(brain.description, "√(7 + 9)")
        XCTAssertEqual(brain.result, 4.0)

        // e. 7 + 9 √
        brain.setOperand(7)
        brain.performOperation("+")
        brain.setOperand(9)
        brain.performOperation("√")
        XCTAssertEqual(brain.description, "7 + √(9)")
        XCTAssertEqual(brain.result, 3.0)
        
        // f. 7 + 9 √ =
        brain.performOperation("=")
        XCTAssertEqual(brain.description, "7 + √(9)")
        XCTAssertEqual(brain.result, 10.0)
        
        // g. 7 + 9 = + 6 + 3
        brain.setOperand(7)
        brain.performOperation("+")
        brain.setOperand(9)
        brain.performOperation("=")
        brain.performOperation("+")
        brain.setOperand(6)
        brain.performOperation("+")
        brain.setOperand(3)
        brain.performOperation("=")
        XCTAssertEqual(brain.description, "7 + 9 + 6 + 3")
        XCTAssertEqual(brain.result, 25.0)
        
        // h. 7 + 9 = √ 6 + 3
        brain.setOperand(7)
        brain.performOperation("+")
        brain.setOperand(9)
        brain.performOperation("=")
        brain.performOperation("√")
        brain.setOperand(6)
        brain.performOperation("+")
        brain.setOperand(3)
        brain.performOperation("=")
        XCTAssertEqual(brain.description, "6 + 3")
        XCTAssertEqual(brain.result, 9.0)

        // i. 5 + 6 = 7 3
        brain.setOperand(5)
        brain.performOperation("+")
        brain.setOperand(6)
        XCTAssertEqual(brain.description, "5 + 6")
        // We haven't performed an operation so it won't have added them up yet
        XCTAssertEqual(brain.result, 6.0)
        brain.performOperation("=")
        XCTAssertEqual(brain.result, 11.0)
        
        // j. 7 + = will be 7 + 7 with 14 in the display
        brain.setOperand(7)
        brain.performOperation("+")
        brain.performOperation("=")
        XCTAssertEqual(brain.description, "7 + 7")
        XCTAssertEqual(brain.result, 14.0)
        
        // k. 4 x π =
        brain.setOperand(4)
        brain.performOperation("×")
        brain.performOperation("π")
        brain.performOperation("=")
        XCTAssertEqual(brain.description, "4 × π")
        // Doubles can always have a degree of inaccuracy so we test them with this: 
        XCTAssertEqualWithAccuracy(brain.result, 12.5663706143592, accuracy: 0.000000001)
        
        // l. 4 + 5 x 3
        brain.setOperand(4)
        brain.performOperation("+")
        brain.setOperand(5)
        brain.performOperation("×")
        brain.setOperand(3)
        brain.performOperation("=")
        XCTAssertEqual(brain.description, "4 + 5 × 3")
        XCTAssertEqual(brain.result, 27.0)
    }
}
