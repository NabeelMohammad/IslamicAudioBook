//
//  AppLogger.swift
//  IslamicAudioBook
//
//  Created by Ameer Shaikh on 15/09/2020.
//  Copyright © 2020 Ameer. All rights reserved.
//

import Foundation

class AppLogger : NSObject {
    // To desable prints in production
    static let logEnabled = false
    
    static func log(_ message: Any) {
        if logEnabled {
            print(message)
        }
    }
}
