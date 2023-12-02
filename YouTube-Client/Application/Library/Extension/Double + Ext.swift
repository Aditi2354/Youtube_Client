//
//  Double + Ext.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 21.05.2023.
//

extension Double {
    var valueToDisplay: String {
        var valueStr = String(
            format: self.truncatingRemainder(dividingBy: 2.0) == 0 ? "%.0f" : "%.1f",
            self
        )
        
        if valueStr.hasSuffix(".0") {
            valueStr.removeLast(2)
        }
        
        return valueStr
    }
}
