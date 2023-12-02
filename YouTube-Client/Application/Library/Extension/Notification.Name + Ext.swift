//
//  Notification.Name + Ext.swift
//  YouTube-Client
//
//  Created by Малиль Дугулюбгов on 10.06.2023.
//

import Foundation

extension Notification.Name {
    static var YTClientOpenUserProfilePage: Self {
        .init("openUserProfilePage")
    }
    
    static var YTClientOpenSearchPage: Self {
        .init("openSearchPage")
    }
    
    static var GoogleUserSessionRestore: Self {
        .init("googleUserSessionRestore")
    }
}
