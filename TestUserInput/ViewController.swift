//
//  ViewController.swift
//  TestUserInput
//
//  Created by Юрий Логинов on 11.10.2021.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    let localityLabel: UILabel = {
        let label = UILabel()
        label.text = "Locality example:"
        return label
    }()
    let label: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textAlignment = .center
        return label
    }()
    let textFieldLabel: UILabel = {
        let label = UILabel()
        label.text = "Text Field:"
        return label
    }()
    let textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.keyboardType = .decimalPad
        return textField
    }()
    let sendLabel: UILabel = {
        let label = UILabel()
        label.text = "Will be sent on server:"
        return label
    }()
    let buttonLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textAlignment = .center
        return label
    }()
    let button: UIButton = {
        let button = UIButton()
        button.setTitle("Send to server", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(didPressOnButton), for: .touchUpInside)
        return button
    }()
    
    let number = "100200.34567"
    
    let appFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 3
        formatter.locale = .current
        formatter.roundingMode = .floor
        return formatter
    }()
    
    let serverFormatter: NumberFormatter = {
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
        view.addSubview(localityLabel)
        view.addSubview(label)
        view.addSubview(textFieldLabel)
        view.addSubview(textField)
        view.addSubview(sendLabel)
        view.addSubview(buttonLabel)
        view.addSubview(button)
        localityLabel.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        textFieldLabel.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        sendLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonLabel.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            localityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            localityLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textFieldLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textFieldLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            sendLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            sendLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            localityLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            label.topAnchor.constraint(equalTo: localityLabel.bottomAnchor, constant: 4),
            label.heightAnchor.constraint(equalToConstant: 40),
            textFieldLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 30),
            textField.topAnchor.constraint(equalTo: textFieldLabel.bottomAnchor, constant: 4),
            textField.heightAnchor.constraint(equalToConstant: 36),
            sendLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 80),
            buttonLabel.topAnchor.constraint(equalTo: sendLabel.bottomAnchor, constant: 4),
            buttonLabel.heightAnchor.constraint(equalToConstant: 40),
            button.topAnchor.constraint(equalTo: buttonLabel.bottomAnchor, constant: 20),
            button.heightAnchor.constraint(equalToConstant: 40)
        ])
        view.backgroundColor = .lightGray
        textField.delegate = self
        
        let number = serverFormatter.number(from: self.number) ?? 0
        label.text = appFormatter.string(from: number)
    }
    
    @objc func didPressOnButton() {
        let text = textField.text ?? "nil"
        let number = appFormatter.number(from: text) ?? -1
        let numberToSend = serverFormatter.string(from: number) ?? "nil"
        buttonLabel.text = numberToSend
    }
    
    var lastEnteredText: String = ""
    let allowedCharacters = CharacterSet(charactersIn: "0123456789., ")
    
    func formatUserInput(with: String) {
        guard with != lastEnteredText else { return }
        let text = with.replacingOccurrences(of: Locale.current.groupingSeparator ?? "nil", with: "").replacingOccurrences(of: Locale.current.decimalSeparator ?? "nil", with: ".")
        
        let number = appFormatter.number(from: text) ?? 0
        var formattedValue = appFormatter.string(from: number) ?? ""
        
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

