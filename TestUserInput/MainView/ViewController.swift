//
//  ViewController.swift
//  TestUserInput
//
//  Created by Юрий Логинов on 11.10.2021.
//

import UIKit

class ViewController: UIViewController {
    let content = MainView()
    
    let serverData = "100200.34567"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            content.topAnchor.constraint(equalTo: view.topAnchor),
            content.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            content.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            content.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        view.backgroundColor = .lightGray
        
        content.textField.delegate = self
        content.textField.addTarget(self, action: #selector(manageInputFormat), for: .editingChanged)
        content.button.addTarget(self, action: #selector(didPressOnButton), for: .touchUpInside)
        
        let number = ReadingsFormatter.server.number(from: self.serverData) ?? 0
        content.label.text = ReadingsFormatter.local.string(from: number)
    }
    
    @objc func didPressOnButton() {
        let text = content.textField.text ?? "nil"
        let number = ReadingsFormatter.local.number(from: text) ?? -1
        let numberToSend = ReadingsFormatter.server.string(from: number) ?? "nil"
        content.buttonLabel.text = numberToSend
    }
    
    //MARK: -- Formatter Section
    var lastEnteredText: String = ""
    
    @objc func manageInputFormat() {
        guard
            let userInput = content.textField.text,
            ReadingsFormatter.allowedCharacters.isSuperset(of: CharacterSet(charactersIn: userInput)),
            userInput.components(separatedBy: ReadingsFormatter.local.decimalSeparator).count < 3,
            userInput.numberInStringHasLessThanOrEqualTo(numberOfFractionalDigits: ReadingsFormatter.local.maximumFractionDigits)
        else {
            content.textField.text = lastEnteredText
            setPosition(isInputValid: false)
            return
        }
        
        let formattedInput = userInput.formatUserInput()
        
        guard lastEnteredText != formattedInput else { return }
        
        lastEnteredText = formattedInput
        content.textField.text = formattedInput
        setPosition(isInputValid: true)
    }
    
    //MARK: -- Cursor Section
    enum TextFieldChangeType {
        case insert
        case deleteOne
        case deleteSelection
    }
    
    var changeType: TextFieldChangeType = .deleteOne
    var lastPosition: Int = 0
    var lengthOfInput: Int = 0
    var previousInput: String = ""
    
    func setPosition(isInputValid: Bool) {
        let textField = content.textField
        
        guard isInputValid else {
            if let samePosition = textField.position(from: textField.beginningOfDocument, offset: lastPosition) {
                textField.selectedTextRange = textField.textRange(from: samePosition, to: samePosition)
            }
            return
        }
        
        var offset: Int = 0
        
        guard let currentInput = textField.text else { return }
        
        switch changeType {
        case .insert:
            offset = (lastPosition + lengthOfInput).includingSeparators(previousInput: previousInput, currentInput: currentInput)
        case .deleteOne:
            offset = (lastPosition - 1).includingSeparators(previousInput: previousInput, currentInput: currentInput)
        case .deleteSelection:
            offset = (lastPosition - lengthOfInput).includingSeparators(previousInput: previousInput, currentInput: currentInput)
        }
        
        if let newPosition = textField.position(from: textField.beginningOfDocument, offset: offset) {
            textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if let selectedRange = textField.selectedTextRange {
            let cursorPosition = textField.offset(from: textField.beginningOfDocument, to: selectedRange.start)
            
            lastPosition = cursorPosition
            lengthOfInput = string.count
            
            if string.count > 0 {
                changeType = .insert
            } else if range.length == 1 {
                changeType = .deleteOne
            } else {
                changeType = .deleteSelection
            }
            
            previousInput = textField.text ?? ""
        }
        
        return true
    }
}

