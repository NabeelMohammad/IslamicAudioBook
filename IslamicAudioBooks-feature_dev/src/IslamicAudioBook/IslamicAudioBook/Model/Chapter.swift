//
//  Chapter.swift
//  IslamicAudioBook
//
//  Created by Ameer Shaikh on 01/08/2020.
//  Copyright © 2020 Ameer. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: - Chapter
class Chapter: Object, Codable {
    @objc dynamic var  id = "", bookID, chapterno, chapter: String?
    @objc dynamic var  chapterurdu, status: String?
    @objc dynamic var  logo, logoMin,color, horizontalImg: String?
    @objc dynamic var  audiocount, topiccount: String?

    override class func primaryKey() -> String {
        return "id"
    }
    
        override static func indexedProperties() -> [String] {
            return ["chapterno"]
        }
    
    enum CodingKeys: String, CodingKey {
        case id
        case bookID = "book_id"
        case chapterno, chapter, chapterurdu, status, logo
        case logoMin = "logo_min"
        case horizontalImg = "horizontal_img"
        case color, audiocount, topiccount
    }
    
    static func searchChapters(searchStr:String) -> Chapters {
        let realm = DataManager.shared.realm
        let predicate = NSPredicate(format: "chapter CONTAINS %@", searchStr)
        let chapters = realm.objects(Chapter.self).filter(predicate)
        return chapters.toArray()
    }
}

typealias Chapters = [Chapter]
