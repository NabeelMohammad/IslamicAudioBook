//
//  Books.swift
//  IslamicAudioBook
//
//  Created by Ameer Shaikh on 30/07/2020.
//  Copyright © 2020 Ameer. All rights reserved.
//

import Foundation
import RealmSwift

//   let books = try? newJSONDecoder().decode(Books.self, from: jsonData)
//https://islamicaudiobooks.info/audioapp/index.php/api/books
//https://islamicaudiobooks.info/audioapp/index.php/api/books?modules=Hadith
//https://islamicaudiobooks.info/audioapp/index.php/api/book?id=5

// MARK: - Book
class Book: Object, Codable {
    @objc dynamic var id = ""
    @objc dynamic var name, nameurdu, creadted: String
    @objc dynamic var uploaddate = "", status, synopsys, synopsysurdu: String
    @objc dynamic var details, detailsurdu: String
    @objc dynamic var profileImage, profileImageMin: String
    @objc dynamic var  modules: String
    @objc dynamic var  horizontalImg: String? = nil
    @objc dynamic var  color: String
    var  chapters: [BookChapter] = []
    
    override class func primaryKey() -> String {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["chapters"]
    }
    
//    override static func indexedProperties() -> [String] {
//        return ["name"]
//    }

    enum CodingKeys: String, CodingKey {
        case id, name, nameurdu, creadted, uploaddate, status, synopsys, synopsysurdu, details, detailsurdu
        case profileImage = "profile_image"
        case profileImageMin = "profile_image_min"
        case modules
        case horizontalImg = "horizontal_img"
        case color, chapters
    }
    
    static func searchBooks(searchStr:String) -> Books {
        let realm = DataManager.shared.realm
        let predicate = NSPredicate(format: "details CONTAINS %@", searchStr)
        let books = realm.objects(Book.self).filter(predicate)
        return books.toArray()
    }
}

// MARK: - Chapter
struct BookChapter: Codable {
    var id : String
    // Commenting rest of code to make it light weight as object is NOT used anywhere except for getting chapter count
    /*
    let  bookID, chapterno, chapter: String
    let chapterurdu, status: String
    let logo, logoMin: String
    let horizontalImg: String?
*/
    enum CodingKeys: String, CodingKey {
        case id
        /*
        case bookID = "book_id"
        case chapterno, chapter, chapterurdu, status, logo
        case logoMin = "logo_min"
        case horizontalImg = "horizontal_img"
 */
    }
}

typealias Books = [Book]

