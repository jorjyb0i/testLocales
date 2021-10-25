//
//  IntExtension.swift
//  TestUserInput
//
//  Created by Юрий Логинов on 24.10.2021.
//

import UIKit

extension Int {
    func includingSeparators(previousInput: String, currentInput: String) -> Int {
        guard let separator = ReadingsFormatter.local.groupingSeparator, separator.count != 0 else { return self }
        let prevSeparators = previousInput.components(separatedBy: separator).count - 1
        let currSeparators = currentInput.components(separatedBy: separator).count - 1
        //учесть группу
        return self + currSeparators - prevSeparators
    }
}
