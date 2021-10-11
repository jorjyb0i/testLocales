//
//  ViewController.swift
//  TestUserInput
//
//  Created by Юрий Логинов on 11.10.2021.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    let label = UILabel()
    let textField = UITextField()
    let buttonLabel = UILabel()
    let button: UIButton = {
        let button = UIButton()
        button.setTitle("Send to server", for: .normal)
        button.backgroundColor = .white
        return button
    }()
    
    let number = "100200.34567"
    
    let outputFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 3
        formatter.locale = .current
        formatter.roundingMode = .floor
        return formatter
    }()
    
    let inputFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 3
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = "."
        formatter.roundingMode = .floor
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)
        view.addSubview(textField)
        view.addSubview(buttonLabel)
        view.addSubview(button)
        label.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        buttonLabel.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 40)
        ])
        view.backgroundColor = .lightGray
        label.backgroundColor = .white
        textField.backgroundColor = .white
        textField.keyboardType = .decimalPad
        textField.delegate = self
        
        let number = inputFormatter.number(from: self.number) ?? 0
        label.text = outputFormatter.string(from: number)
    }
    
    let validationFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 3
        return formatter
    }()
    
    var lastEnteredText: String = ""
    let allowedCharacters = CharacterSet(charactersIn: "0123456789., ")
    
    func formatUserInput(with: String) {
        guard with != lastEnteredText else { return }
        let text = with.replacingOccurrences(of: Locale.current.groupingSeparator ?? "nil", with: "").replacingOccurrences(of: Locale.current.decimalSeparator ?? "nil", with: ".")
        
        let number = validationFormatter.number(from: text) ?? 0
        var formattedValue = outputFormatter.string(from: number) ?? ""
        
        if with.suffix(1) == Locale.current.decimalSeparator ?? "nil" {
            formattedValue += with.suffix(1)
        }
        if formattedValue == "0" {
            formattedValue = ""
        }
        
        lastEnteredText = formattedValue
        textField.text = formattedValue
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let characterSet = CharacterSet(charactersIn: string)
        
        if allowedCharacters.isSuperset(of: characterSet) {
            let enteredTextValue = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? "0"
            guard enteredTextValue == lastEnteredText else {
                formatUserInput(with: enteredTextValue)
                return false
            }
            return true
        } else {
            return false
        }
    }
}

