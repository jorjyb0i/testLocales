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
        content.textField.pasteDelegate = self
        content.button.addTarget(self, action: #selector(didPressOnButton), for: .touchUpInside)
        
        let number = formatterManager.server.number(from: self.serverData) ?? 0
        content.label.text = formatterManager.local.string(from: number)
    }
    
    @objc func didPressOnButton() {
        let text = content.textField.text ?? "nil"
        let number = formatterManager.local.number(from: text) ?? -1
        let numberToSend = formatterManager.server.string(from: number) ?? "nil"
        content.buttonLabel.text = numberToSend
    }
    
    //MARK: -- Formatter Section
    var lastEnteredText: String = ""
    let formatterManager = ReadingsFormatter.default
    
    private func isInputValid(input: String) -> Bool {
        let isAllowedCharacters = formatterManager.allowedCharacters.isSuperset(of: CharacterSet(charactersIn: input))
        let onlyOneDecimalSeparator = input.components(separatedBy: formatterManager.local.decimalSeparator).count < 3
        let hasAllowedAmountOfDecimalDigits = decimalPartIsNotLonger(than: formatterManager.local.maximumFractionDigits, in: input)
        return isAllowedCharacters && onlyOneDecimalSeparator && hasAllowedAmountOfDecimalDigits
    }
    
    private func decimalPartIsNotLonger(than numberOfDigits: Int, in input: String) -> Bool {
        guard input.contains(formatterManager.local.decimalSeparator) else { return true }
        let result = inputWithDefaultSeparators(input: input).components(separatedBy: formatterManager.local.decimalSeparator).last ?? ""
        return result.count <= numberOfDigits
    }
    
    private func inputWithDefaultSeparators(input: String) -> String {
        let result = input
            .replacingOccurrences(of: formatterManager.local.groupingSeparator ?? "", with: formatterManager.defaultGroupingSeparator)
            .replacingOccurrences(of: formatterManager.local.decimalSeparator ?? "", with: formatterManager.defaultDecimalSeparator)
        return result
    }
    
    private func isDeletingGroupingSeparator(input: String) -> Bool {
        guard let separator = formatterManager.local.groupingSeparator else { return false }
        let isDeletingSingleSymbol = (lastEnteredText.count - input.count) == 1
        let isDeletingGroupingSeparator = (lastEnteredText.components(separatedBy: separator).count - input.components(separatedBy: separator).count) == 1
        return isDeletingSingleSymbol && isDeletingGroupingSeparator
    }
    
    private func format(userInput: String) -> String {
        guard !userInput.isEmpty else { return "" }
        let inputWithDefaultSeparators = inputWithDefaultSeparators(input: userInput)
        let numberToFormat = formatterManager.server.number(from: inputWithDefaultSeparators) ?? 0
        let formattedInput = formatterManager.local.string(from: numberToFormat)
        
        guard var resultString = formattedInput else { return "" }
        
        if userInput.contains(formatterManager.local.decimalSeparator) {
            guard
                let separator = formatterManager.local.decimalSeparator,
                let integerPart = resultString.components(separatedBy: separator).first
            else { return "" }
            
            let components = userInput.components(separatedBy: separator)
            guard components.count == 2, let decimalPart = components.last else { return "\(integerPart)\(separator)"}
            
            resultString = "\(integerPart)\(separator)\(decimalPart)"
        }
        
        return resultString
    }
    
    //MARK: -- Cursor section
    private func getPosition(for textField: UITextField, offset: Int) -> UITextRange {
        guard let newPosition = textField.position(from: textField.beginningOfDocument, offset: offset) else { return UITextRange() }
        return textField.textRange(from: newPosition, to: newPosition) ?? UITextRange()
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let hasComeFromUserInput = !(range.length == 0 && string.isEmpty)
        guard
            hasComeFromUserInput,
            let userInput = (textField.text as NSString?)?.replacingCharacters(in: range, with: string),
            isInputValid(input: userInput)
        else { return false }
        
        if isDeletingGroupingSeparator(input: userInput) {
            if let selectedRange = textField.selectedTextRange {
                let cursorPosition = textField.offset(from: textField.beginningOfDocument, to: selectedRange.start)
                if let newPosition = textField.position(from: textField.beginningOfDocument, offset: cursorPosition - 1) {
                    textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
                }
                return false
            }
        }
        
        let formattedInput = format(userInput: userInput)
        var offset = formattedInput.count - (lastEnteredText.count - (range.location + range.length))
        offset = offset >= 0 ? offset : 0
        
        guard lastEnteredText != formattedInput else {
            textField.selectedTextRange = getPosition(for: textField, offset: offset)
            return false
        }
    
        lastEnteredText = formattedInput
        textField.text = formattedInput
        
        textField.selectedTextRange = getPosition(for: textField, offset: offset)
        return false
    }
}

extension ViewController: UITextPasteDelegate {
    func textPasteConfigurationSupporting(_ textPasteConfigurationSupporting: UITextPasteConfigurationSupporting, transform item: UITextPasteItem) {
///        Tells the delegate to transform the pasted or dropped text item.

        item.setDefaultResult()
        return
    }

    func textPasteConfigurationSupporting(_ textPasteConfigurationSupporting: UITextPasteConfigurationSupporting, combineItemAttributedStrings itemStrings: [NSAttributedString], for textRange: UITextRange) -> NSAttributedString {
///        Asks the delegate to combine multiple strings into a single attributed string.
        
        let string = itemStrings.first?.string ?? ""
        return NSAttributedString(string: string)
    }

    func textPasteConfigurationSupporting(_ textPasteConfigurationSupporting: UITextPasteConfigurationSupporting, performPasteOf attributedString: NSAttributedString, to textRange: UITextRange) -> UITextRange {
///        Asks the delegate to explicitly handle the final incorporation of a pasted or dropped string of text into the text view.
        
        guard let textField = textPasteConfigurationSupporting as? UITextField,
              let text = textField.text,
              let selectedRange = textField.selectedTextRange
        else { return textRange }
        
        let string = attributedString.string
        
        let location = textField.offset(from: textField.beginningOfDocument, to: selectedRange.start)
        let length = textField.offset(from: selectedRange.start, to: selectedRange.end)
        let range = NSRange(location: location, length: length)
        
        
        let hasComeFromUserInput = !(range.length == 0 && string.isEmpty)
        guard
            hasComeFromUserInput,
            let userInput = (text as NSString?)?.replacingCharacters(in: range, with: string),
            isInputValid(input: userInput)
        else { return textRange }
        
///        Here was path for deleting single grouping separator
        
        let formattedInput = format(userInput: userInput)
        var offset = formattedInput.count - (lastEnteredText.count - (range.location + range.length))
        offset = offset >= 0 ? offset : 0
        
///        Here was path for input of similar text
        
        lastEnteredText = formattedInput
        textField.text = formattedInput
        
        return getPosition(for: textField, offset: offset)
    }
}
