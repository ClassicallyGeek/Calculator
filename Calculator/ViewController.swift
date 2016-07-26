//
//  ViewController.swift
//  Calculator
//
//  Created by Ashley on 4/25/16.
//

import UIKit // This is a module (not a file)-- a group of classes.

// All MVC controllers will inherit from UIViewController either directly or indirectly
class ViewController: UIViewController {
    
    // MARK: Properties
    
    // ! and ? both mean Optional when declaring a var
    // ! means after first set it's always set-- implicitly unwrapped optional
    @IBOutlet private weak var display: UILabel!
    @IBOutlet weak var calculationsDisplay: UILabel!
    
    // All vars have to be initialized and swift is inferring the type is Bool
    private var userIsInTheMiddleOfTyping = false
    // We'll grab a reference to the "." button if used
    var period : UIButton?

    // Every time you create a new class you get 1 free no-arg initializer
    private var brain = CalculatorBrain()

    // Automatically track what is in the display to avoid type conversions everywhere
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private func updateCalculationsDisplay() {
        calculationsDisplay.text = brain.description +
            (brain.isPartialResult ? " ... " : " = ")
        
    }
    
    // MARK: Button Actions
    
    // Reset the value
    @IBAction func clear(sender: UIButton) {
        brain = CalculatorBrain()
        display.text=" "
        calculationsDisplay.text=" "
        userIsInTheMiddleOfTyping = false
        if let periodButton = period {
            periodButton.enabled = true
        }
    }
    
    // IBAction is an XCode special thing so we can see what in the storyboard is connected to this
    @IBAction private func touchDigit(sender: UIButton) {
        /* Optionals
         Optional is a type (like String, Array, etc.)
         Only has 2 values: (1) Not Set - not 0 or anything else (nil)
         (2) Set (with an associated value- can be any other type)
         currentTitle - type is Optional and its associated value is a String.
        */
        let digit = sender.currentTitle!

        // If they've already typed a ".", we cannot let them do this again in the same number
        if digit == "." {
            period = sender
            period!.enabled = false // '!' means unwrap this thing and give me the associated value
        }

        if (userIsInTheMiddleOfTyping) {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
    }

    @IBAction private func performOperation(sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
            // An operator will clear the "." availability for the next digit
            period?.enabled = true
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        displayValue = brain.result
        updateCalculationsDisplay()
    }
}

