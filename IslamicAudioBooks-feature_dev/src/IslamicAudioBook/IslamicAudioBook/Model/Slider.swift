//
//  Slider.swift
//  IslamicAudioBook
//
//  Created by Ameer Shaikh on 28/07/2020.
//  Copyright © 2020 Ameer. All rights reserved.
//

import Foundation

// MARK: - SliderElement
struct SliderElement: Codable {
    let id: String
    let image, imageMin: String?
    let date, status: String?
    let bookID, chapterID, topic, audio: String?

    enum CodingKeys: String, CodingKey {
        case id, image
        case imageMin = "image_min"
        case date, status
        case bookID = "book_id"
        case chapterID = "chapter_id"
        case topic, audio
    }
}

typealias Slider = [SliderElement]
