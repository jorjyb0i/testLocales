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
        
        let number = Formatter.server.number(from: self.serverData) ?? 0
        content.label.text = Formatter.local.string(from: number)
    }
    
    @objc func didPressOnButton() {
        let text = content.textField.text ?? "nil"
        let number = Formatter.local.number(from: text) ?? -1
        let numberToSend = Formatter.server.string(from: number) ?? "nil"
        content.buttonLabel.text = numberToSend
    }
    
    //MARK: -- Formatter Section
    var lastEnteredText: String = ""
    
    @objc func manageInputFormat() {
        guard
            let userInput = content.textField.text,
            Formatter.allowedCharacters.isSuperset(of: CharacterSet(charactersIn: userInput)),
            userInput.components(separatedBy: Formatter.local.decimalSeparator).count < 3,
            userInput.numberInStringHasLessThanOrEqualTo(numberOfFractionalDigits: Formatter.local.maximumFractionDigits)
        else {
            content.textField.text = lastEnteredText
            return
        }
        
        let formattedInput = userInput.formatUserInput()
        
        guard lastEnteredText != formattedInput else { return }
        
        lastEnteredText = formattedInput
        content.textField.text = formattedInput
    }
    
    //MARK: -- Cursor Section
    var lastPosition: UITextPosition = UITextPosition()
    
    func setPosition() {
        
    }
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}

