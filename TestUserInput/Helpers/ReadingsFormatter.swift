//
//  Formatter.swift
//  TestUserInput
//
//  Created by Юрий Логинов on 20.10.2021.
//

import UIKit

class ReadingsFormatter {
    static let local: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 3
        formatter.locale = .current
        formatter.roundingMode = .floor
        return formatter
    }()
    
    static let server: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 3
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = "."
        formatter.roundingMode = .floor
        return formatter
    }()
    
    static let allowedCharacters: CharacterSet = {
        let set = "0123456789" + (local.decimalSeparator ?? "") + (local.groupingSeparator ?? "")
        return CharacterSet(charactersIn: set)
    }()
    
    static let defaultGroupingSeparator = ""
    static let defaultDecimalSeparator = "."
}
