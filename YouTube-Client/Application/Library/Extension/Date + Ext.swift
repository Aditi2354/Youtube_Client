//
//  Date + Ext.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 09.05.2023.
//

import Foundation

extension Date {
    var passedTimeRelativeToNowString: String {
        let relativeDateFormatter = RelativeDateTimeFormatter()
        relativeDateFormatter.unitsStyle = .full
        
        return relativeDateFormatter.localizedString(
            for: self,
            relativeTo: Date()
        )
    }
}
