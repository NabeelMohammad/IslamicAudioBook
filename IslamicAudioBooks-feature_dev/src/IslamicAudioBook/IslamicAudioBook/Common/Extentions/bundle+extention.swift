//
//  bundle+extention.swift
//  IslamicAudioBook
//
//  Created by Ameer Shaikh on 09/10/2020.
//  Copyright © 2020 Ameer. All rights reserved.
//

import Foundation

extension Bundle {

    var appName: String {
        return infoDictionary?["CFBundleName"] as! String
    }

    var bundleId: String {
        return bundleIdentifier!
    }

    var versionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as! String
    }

    var buildNumber: String {
        return infoDictionary?["CFBundleVersion"] as! String
    }

}
