//
//  ViewController.swift
//  Calculator+storyboard
//
//  Created by Rdm on 29/06/2020.
//  Copyright © 2020 Rdm. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet var buttonsPad: [CalculatorButton]!
    
    var firstOperand: Double = 0
    var resultNumber: Double = 0
    var currentOperation: Operation?
    
    enum Operation {
        case add, subtract, multiply, divide
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    setupView()
    }
    
    @IBAction func numberPadButtonTapped(_ sender: CalculatorButton) {
   
        let tag = sender.tag
        
        if resultLabel.text == "0" {
            
            resultLabel.text = "\(tag)"
            
        } else if let label = resultLabel.text {
            
            resultLabel.text = "\(label)\(tag)"
        }
    }
    
    @IBAction func binaryOperatorTapped(_ sender: CalculatorButton) {
        
        let tag = sender.tag
       
        if let text = resultLabel.text, let value = Double(text), firstOperand == 0 {
            firstOperand = value
            resultLabel.text = "0"
        }
        
        if tag == 14 {
            
            if let operation = currentOperation {
                
                var secondOperand: Double = 0
                
                if let text = resultLabel.text, let value = Double(text) {
                    secondOperand = value
                }
                
                switch operation {
                case .add:
                    let result = firstOperand + secondOperand
                    resultLabel.text = "\(result)"
                    break
                    
                case .subtract:
                    let result = firstOperand - secondOperand
                    resultLabel.text = "\(result)"
                    break
                    
                case .multiply:
                    let result = firstOperand * secondOperand
                    resultLabel.text = "\(result)"
                    break
                    
                case .divide:
                    let result = firstOperand / secondOperand
                    resultLabel.text = "\(result)"
                    break
                }
            }
        }
        else if tag == 10 {
            currentOperation = .add
        }
        
        else if tag == 11 {
            currentOperation = .subtract
        }
        
        else if tag == 12 {
            currentOperation = .multiply
        }
        
        else if tag == 13 {
            currentOperation = .divide
        }
    }
    
    @IBAction func addComma(_ sender: CalculatorButton) {
       
        let comma = ","
        if let text = resultLabel.text {
            resultLabel.text = "\(text)\(comma)"
       
        }
    }
    
    @IBAction func clearResult(_ sender: CalculatorButton) {
        
        resultLabel.text = "0"
        currentOperation = nil
        firstOperand = 0
    
    }

    fileprivate func setupView() {
        
        resultLabel.text = "0"
        resultLabel.font = UIFont.systemFont(ofSize: 70)
        resultLabel.numberOfLines = 0
        
        for button in buttonsPad {
            
            // button.layer.cornerRadius = button.frame.width / 2   -> Invalid corner radius?
            button.layer.cornerRadius = 41.5
            button.titleLabel?.font = .boldSystemFont(ofSize: 27)
            
        }
    }
}

