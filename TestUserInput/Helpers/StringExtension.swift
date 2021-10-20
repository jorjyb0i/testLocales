//
//  StringExtension.swift
//  TestUserInput
//
//  Created by Юрий Логинов on 20.10.2021.
//

import UIKit

extension String {
    func withDefaultSeparators() -> String {
        let result = self
            .replacingOccurrences(of: Formatter.local.groupingSeparator ?? "", with: Formatter.defaultGroupingSeparator)
            .replacingOccurrences(of: Formatter.local.decimalSeparator ?? "", with: Formatter.defaultDecimalSeparator)
        return result
    }
    
    func makeDecimalFromLocal() -> Decimal {
        let number = Formatter.local.number(from: self) ?? 0
        let string = Formatter.server.string(from: number) ?? "0"
        let decimal = Decimal(string: string) ?? Decimal(0)
        return decimal
    }
    
    func formatUserInput() -> String {
        guard !self.isEmpty else { return "" }
        let inputWithDefaultSeparators = self.withDefaultSeparators()
        let numberToFormat = Formatter.server.number(from: inputWithDefaultSeparators) ?? 0
        let formattedInput = Formatter.local.string(from: numberToFormat)
        
        guard let resultString = formattedInput else { return "" }
        
        if self.contains(Formatter.local.decimalSeparator) {
            return resultString.withFormattedDecimalPart(input: self)
        }
        
        return resultString
    }
    
    func withFormattedDecimalPart(input: String) -> String {
        guard let separator = Formatter.local.decimalSeparator else { return "" }
        guard let integerPart = self.components(separatedBy: separator).first else { return "" }
        
        let components = input.components(separatedBy: separator)
        guard components.count == 2, let decimalPart = components.last else { return "\(integerPart)\(separator)"}
        
        return "\(integerPart)\(separator)\(decimalPart)"
    }
    
    func numberInStringHasLessThanOrEqualTo(numberOfFractionalDigits: Int) -> Bool {
        guard self.contains(".") else { return true }
        let result = self.withDefaultSeparators().components(separatedBy: Formatter.local.decimalSeparator).last ?? ""
        return result.count <= numberOfFractionalDigits
    }
    
}
