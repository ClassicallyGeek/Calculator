//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Ashley on 5/5/16.
//  Copyright © 2016 Stanford Unversity CS 193P. All rights reserved.
//

import Foundation

// This is a global function not a method of the class
//func multiply(x: Double, y: Double) -> Double {
//    return x * y
//}
//func add(x: Double, y: Double) -> Double {
//    return x + y
//}
//func subtract(x: Double, y: Double) -> Double {
//    return x - y;
//}

class CalculatorBrain {
    // MARK: Properties
    private var accumulator = 0.0
    var description = [String]()
    var isPartialResult = true
    
    enum Operation {
        case Constant(Double)
        case UnaryOperation((Double)->Double)
        case BinaryOperation((Double, Double)->Double)
        case Equals
    }
    
    var operations: Dictionary<String, Operation> = [
        "π" : .Constant(M_PI),
        "e" : .Constant(M_E),
        "√" : .UnaryOperation(sqrt),
        "tan" : .UnaryOperation(tan),
        "sin" : .UnaryOperation(sin),
        "cos" : .UnaryOperation(cos),
        "±" : .UnaryOperation( { (x: Double) -> Double in return x * -1 } ),
        "Exp" : .BinaryOperation( { (x: Double, y: Double) -> Double in return pow(x,y) } ),
        "×" : .BinaryOperation( { (x: Double, y: Double) -> Double in return x*y }),
        "−" : .BinaryOperation( { (x: Double, y: Double) -> Double in return x-y } ),
        "+" : .BinaryOperation( { (x: Double, y: Double) -> Double in return x+y } ),
        "÷" : .BinaryOperation( { (x: Double, y: Double) -> Double in return x/y } ),
        "%" : .BinaryOperation( { (x: Double, y: Double) -> Double in return x%y } ),
        "=" : .Equals
    ]
    
    struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double)->Double
        var firstOperand: Double
    }
    
    var pending:PendingBinaryOperationInfo?
    
    // making result read only by making it computed & only implementing get
    var result: Double {
        get {
            return accumulator
        }
    }
    
    // MARK: Math Things
    func setOperand(operand: Double) {
        accumulator = operand
        // If you pressed "=" and you start typing a number we are no longer working on the same calculation-- reset it
        if !isPartialResult {
            description = []
        }
        description.append(String(operand))
    }
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let associatedConstantValue) :
                description.append(String(symbol))
                accumulator = associatedConstantValue
            case .UnaryOperation(let associatedFunction) :
                if isPartialResult {
                    description.insert(String(symbol) + " (", atIndex: description.count-1)
                } else {
                    description.insert(String(symbol) + "(", atIndex: 0)
                }
                description.insert(")", atIndex:description.count)
                accumulator = associatedFunction(accumulator)
            case .BinaryOperation(let function) :
                // There is  test case that allows for continued binary operation after "="
                isPartialResult = true
                
                description.append(String(symbol))
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals :
                executePendingBinaryOperation()
                isPartialResult = false
            }
        }
    }


    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
}