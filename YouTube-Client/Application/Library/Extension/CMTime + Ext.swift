//
//  CMTime + Ext.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 03.06.2023.
//

import AVFoundation

extension CMTime {
    func convertToTimeString() -> String {
        let totalSeconds = CMTimeGetSeconds(self)
        let timeInterval = TimeInterval(totalSeconds)
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        
        switch totalSeconds {
        case let seconds where seconds <= 0:
            return "0:00"
        case let seconds where seconds < 60:
            formatter.allowedUnits = [.minute, .second]
            formatter.zeroFormattingBehavior = .dropTrailing
            return formatter.string(from: timeInterval) ?? "0:00"
        case let seconds where seconds < 3600:
            formatter.allowedUnits = [.minute, .second]
            formatter.zeroFormattingBehavior = .pad
            return formatter.string(from: timeInterval) ?? "0:00"
        default:
            formatter.allowedUnits = [.hour, .minute, .second]
            return formatter.string(from: timeInterval) ?? "0:00:00"
        }
    }
}
