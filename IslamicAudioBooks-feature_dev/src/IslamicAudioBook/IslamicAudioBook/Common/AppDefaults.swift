//
//  AppDefaults.swift
//  IslamicAudioBook
//
//  Created by Ameer Shaikh on 29/09/2020.
//  Copyright © 2020 Ameer. All rights reserved.
//

import Foundation

class AppDefaults {
    static let prefs = UserDefaults.standard

    static func saveBoolToUserDefaults(_ key:String, value:Bool) {
        prefs.setValue(value, forKey: key)
    }
    
    static func getBoolFromUserDefaults(_ key:String) -> Bool? {
        return prefs.bool(forKey: key)
    }
}
