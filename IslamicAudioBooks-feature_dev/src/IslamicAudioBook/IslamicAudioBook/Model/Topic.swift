//
//  Topic.swift
//  IslamicAudioBook
//
//  Created by Ameer Shaikh on 06/08/2020.
//  Copyright © 2020 Ameer. All rights reserved.
//


import Foundation

// MARK: - Topic
struct Topic: Codable {
    let id, bookID, chapterID, topic: String
    let topicurdu, topicno: String
    let logo: String
    let status: String

    enum CodingKeys: String, CodingKey {
        case id
        case bookID = "book_id"
        case chapterID = "chapter_id"
        case topic, topicurdu, topicno, logo, status
    }
}

typealias Topics = [Topic]
