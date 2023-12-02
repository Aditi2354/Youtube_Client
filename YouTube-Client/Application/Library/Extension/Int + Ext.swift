//
//  Int + Ext.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 21.05.2023.
//

extension Int {
    func formatPositiveNumberToDisplay() -> String {
        guard self >= 0 else { return "" }
        
        switch self {
        case 0..<1000:
            return String(self)
        case 1000..<1_000_000:
            let valueToDisplay = Double(self) / 1000.0
            return "\(valueToDisplay.valueToDisplay)K"
        case 1_000_000..<1_000_000_000:
            let valueToDisplay = Double(self) / 1_000_000.0
            return "\(valueToDisplay.valueToDisplay)M"
        case 1_000_000_000..<1_000_000_000_000:
            let valueToDisplay = Double(self) / 1_000_000_000.0
            return "\(valueToDisplay.valueToDisplay)B"
        default:
            return String(self)
        }
    }
}
