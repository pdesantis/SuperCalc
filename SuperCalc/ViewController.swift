//
//  ViewController.swift
//  SuperCalc
//
//  Created by Patrick DeSantis on 6/3/15.
//  Copyright (c) 2015 Patrick DeSantis. All rights reserved.
//

import UIKit

// "extension" allows you to add properties and methods to existing classes
// Here, we're adding a "floatValue" property to the String type that converts it to a Float
// To find this, I google'd "swift convert string to float"
// first result is:
// http://stackoverflow.com/questions/24034043/how-do-i-check-if-a-string-contains-another-string-in-swift
// 🍹
extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}

class ViewController: UIViewController {

    var runningTotal: Float?
    var input: String?
    var operation: String?

    let numberFormatter = NSNumberFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        numberFormatter.numberStyle = .DecimalStyle
    }

    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!

    @IBAction func clearPressed(sender: AnyObject) {
        if input == nil {
            runningTotal = nil
            operation = nil
        } else {
            input = nil
        }
        evaluate()
    }

    @IBAction func positiveNegativePressed(sender: AnyObject) {
        if let i = input {
            let inverse = i.floatValue * -1
            input = numberFormatter.stringFromNumber(inverse)
        } else if runningTotal != nil {
            runningTotal! *= -1
        }
        updateDisplay()
    }

    @IBAction func percentPressed(sender: AnyObject) {
        if let i = input {
            let percent = i.floatValue / 100
            input = numberFormatter.stringFromNumber(percent)
        } else if let r = runningTotal {
            runningTotal = r / 100
        }
        updateDisplay()
    }

    // Connected to buttons 1 - 9 and .
    @IBAction func digitPressed(sender: UIButton) {
        let number = sender.titleLabel?.text

        // If we already have input
        if let i = input {
            // If the user pressed a decimal, only allow entry if we don't already have a decimal
            if number != "." || i.rangeOfString(".") == nil {
                input! += number!
            }
        } else {
            input = number
        }
        updateDisplay()
    }

    // Connected to + - / x
    @IBAction func operationPressed(sender: UIButton) {
        evaluate()
        operation = sender.titleLabel?.text
    }

    // Connected to =
    @IBAction func equalsPressed(sender: AnyObject) {
        evaluate()
    }

    func evaluate() {
        // If we have input
        if let i = input {

            // If we have a running total, then perform the calculation!
            if let r = runningTotal {
                switch (operation!) {
                case "+":
                    runningTotal! += i.floatValue
                case "-":
                    runningTotal! -= i.floatValue
                case "x":
                    runningTotal! *= i.floatValue
                case "/":
                    runningTotal! /= i.floatValue
                default:
                    println("nothing to do here...")
                }
            // Otherwise, store the input in running total
            } else {
                runningTotal = i.floatValue
            }
        }

        // Clear the input
        input = nil

        updateDisplay()
    }

    func updateDisplay() {
        if input == nil {
            clearButton.setTitle("AC", forState: .Normal)
        } else {
            clearButton.setTitle("C", forState: .Normal)
        }

        if let i = input {
            outputLabel.text = i
        } else if let total = runningTotal {
            outputLabel.text = numberFormatter.stringFromNumber(total)
        } else {
            outputLabel.text = numberFormatter.stringFromNumber(0)
        }
    }
}

