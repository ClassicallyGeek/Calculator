//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Ashley on 5/5/16.
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
    private var descriptionAccumulator = "0"
    
    enum Operation {
        case Constant(Double)
        case UnaryOperation((Double)->Double, (String)->String)
        case BinaryOperation((Double, Double)->Double, (String, String)->String)
        case Equals
    }
    
    var operations: Dictionary<String, Operation> = [
        "π" : .Constant(M_PI),
        "e" : .Constant(M_E),
        "√" : .UnaryOperation(sqrt, { (calculations: String) -> String in return "√(" + calculations + ")"}),
        "tan" : .UnaryOperation(tan, { (calculations: String) -> String in return "tan(" + calculations + ")"} ),
        "sin" : .UnaryOperation(sin, { (calculations: String) -> String in return "sin(" + calculations + ")"}),
        "cos" : .UnaryOperation(cos, { (calculations: String) -> String in return "cos(" + calculations + ")"}),
        "±" : .UnaryOperation( { (x: Double) -> Double in return x * -1 },
            { (calculations: String) -> String in return "±(" + calculations + ")"} ), // TODO This one might need some more work
        "Exp" : .BinaryOperation( { (x: Double, y: Double) -> Double in return pow(x,y) },
            { ( x: String, y: String ) -> String in return x + "^" + y}),
        "×" : .BinaryOperation( { (x: Double, y: Double) -> Double in return x*y },
            { ( x: String, y: String ) -> String in return x + " × " + y}),
        "−" : .BinaryOperation( { (x: Double, y: Double) -> Double in return x-y },
            { ( x: String, y: String ) -> String in return x + " − " + y}),
        "+" : .BinaryOperation( { (x: Double, y: Double) -> Double in return x+y },
            { ( x: String, y: String ) -> String in return x + " + " + y}),
        "÷" : .BinaryOperation( { (x: Double, y: Double) -> Double in return x/y },
            { ( x: String, y: String ) -> String in return x + " ÷ " + y}),
        "%" : .BinaryOperation( { (x: Double, y: Double) -> Double in return x%y },
            { ( x: String, y: String ) -> String in return x + " % " + y}),
        "=" : .Equals
    ]
    
    struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double)->Double
        var firstOperand: Double
        var descriptionFunction: (String, String)->String
        var descriptionOperand: String
    }
    
    var pending:PendingBinaryOperationInfo?
    
    // making result read only by making it computed & only implementing get
    var result: Double {
        get {
            return accumulator
        }
    }
    
    var isPartialResult: Bool {
        get {
            return pending != nil
        }
    }
    
    var description: String {
        get {
            if pending == nil {
                return descriptionAccumulator
            }
            return pending!.descriptionFunction(pending!.descriptionOperand,
                                                pending!.descriptionOperand != descriptionAccumulator ? descriptionAccumulator : "")
        }
    }
    
    // MARK: Math Things
    func setOperand(operand: Double) {
        accumulator = operand
        // setting operand updates the description as well
        descriptionAccumulator = String(format: "%g", operand)
    }
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let associatedConstantValue) :
                accumulator = associatedConstantValue
                descriptionAccumulator = symbol
            case .UnaryOperation(let associatedFunction, let descriptionFunction) :
                accumulator = associatedFunction(accumulator)
                descriptionAccumulator = descriptionFunction(descriptionAccumulator)
            case .BinaryOperation(let function, let descriptionFunction) :
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator,
                                                     descriptionFunction: descriptionFunction, descriptionOperand: descriptionAccumulator)
            case .Equals :
                executePendingBinaryOperation()
                print(description)
            }
        }
    }
    
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            descriptionAccumulator = pending!.descriptionFunction(pending!.descriptionOperand, descriptionAccumulator)
            pending = nil
        }
    }
}