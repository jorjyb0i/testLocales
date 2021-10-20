//
// swift
//  TestUserInput
//
//  Created by Юрий Логинов on 20.10.2021.
//

import UIKit

class MainView: UIView {
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
        textField.textAlignment = .center
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
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviewsAndDisableMasks(views: [
            localityLabel,
            label,
            textFieldLabel,
            textField,
            sendLabel,
            buttonLabel,
            button
        ])
        activateConstraints()
        configureView()
    }
    
    func addSubviewsAndDisableMasks(views: [UIView]) {
        for view in views {
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            localityLabel.leadingAnchor.constraint(equalTo:leadingAnchor, constant: 20),
            localityLabel.trailingAnchor.constraint(equalTo:trailingAnchor, constant: -20),
            label.leadingAnchor.constraint(equalTo:leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo:trailingAnchor, constant: -20),
            textFieldLabel.leadingAnchor.constraint(equalTo:leadingAnchor, constant: 20),
            textFieldLabel.trailingAnchor.constraint(equalTo:trailingAnchor, constant: -20),
            textField.leadingAnchor.constraint(equalTo:leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo:trailingAnchor, constant: -20),
            sendLabel.leadingAnchor.constraint(equalTo:leadingAnchor, constant: 20),
            sendLabel.trailingAnchor.constraint(equalTo:trailingAnchor, constant: -20),
            buttonLabel.leadingAnchor.constraint(equalTo:leadingAnchor, constant: 20),
            buttonLabel.trailingAnchor.constraint(equalTo:trailingAnchor, constant: -20),
            button.leadingAnchor.constraint(equalTo:leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo:trailingAnchor, constant: -20),
            
            localityLabel.topAnchor.constraint(equalTo:topAnchor, constant: 200),
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
    }
    
    func configureView() {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
