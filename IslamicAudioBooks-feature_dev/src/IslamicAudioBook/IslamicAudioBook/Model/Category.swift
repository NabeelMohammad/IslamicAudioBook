//
//  Category.swift
//  IslamicAudioBook
//
//  Created by Ameer Shaikh on 29/07/2020.
//  Copyright © 2020 Ameer. All rights reserved.
//

import Foundation

// MARK: - CategoryElement
struct CategoryElement: Codable {
    let id, modulename, status, uploaddate: String
    let logo, logoMin: String
    let color: String

    enum CodingKeys: String, CodingKey {
        case id, modulename, status, uploaddate, logo
        case logoMin = "logo_min"
        case color
    }
}

typealias Category = [CategoryElement]
