//
//  Formatter.swift
//  TestUserInput
//
//  Created by Юрий Логинов on 20.10.2021.
//

import UIKit

class ReadingsFormatter {
    
    static let `default` = ReadingsFormatter()
    
    init() {
        let localFormatter = NumberFormatter()
        localFormatter.numberStyle = .decimal
        localFormatter.maximumFractionDigits = 3
        localFormatter.locale = .current
        localFormatter.roundingMode = .floor
        
        self.local = localFormatter
        
        let serverFormatter = NumberFormatter()
        serverFormatter.numberStyle = .decimal
        serverFormatter.maximumFractionDigits = 3
        serverFormatter.groupingSeparator = defaultGroupingSeparator
        serverFormatter.decimalSeparator = defaultDecimalSeparator
        serverFormatter.roundingMode = .floor
        
        self.server = serverFormatter
        
        let set = "0123456789" + (local.decimalSeparator ?? "") + (local.groupingSeparator ?? "")
        
        self.allowedCharacters = CharacterSet(charactersIn: set)
    }
    
    var local: NumberFormatter
    var server: NumberFormatter
    
    var allowedCharacters: CharacterSet
    
    var defaultGroupingSeparator = ""
    var defaultDecimalSeparator = "."
}
