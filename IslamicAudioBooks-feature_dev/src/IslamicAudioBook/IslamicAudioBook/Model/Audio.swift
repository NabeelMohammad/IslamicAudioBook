//
//  Audio.swift
//  IslamicAudioBook
//
//  Created by Ameer Shaikh on 06/08/2020.
//  Copyright © 2020 Ameer. All rights reserved.
//


import Foundation
import RealmSwift

// MARK: - Audio
class Audio: Object, Codable {
    @objc dynamic var  logoMin: String
    @objc dynamic var  id, chapter, chapterurdu: String
    @objc dynamic var  content: String
    @objc dynamic var  slno, bookID, status, audioname: String
    @objc dynamic var  audionameurdu: String
    @objc dynamic var  url: String
    @objc dynamic var  bookname, chapterID, audioTag, booknameurdu: String
    @objc dynamic var  topic,booksynopsysenglish, booksynopsysurdu: String?
    
    @objc dynamic var favorite: Bool = false
    @objc dynamic var downloaded: Bool = false
    @objc dynamic var historyTimeStamp = 0
    
    override class func primaryKey() -> String {
        return "url"
    }
    
    enum CodingKeys: String, CodingKey {
        case logoMin = "logo_min"
        case id, chapter, chapterurdu, content, slno
        case bookID = "book_id"
        case status, audioname, audionameurdu, url, bookname
        case chapterID = "chapter_id"
        case audioTag = "audio_tag"
        case topic,booknameurdu, booksynopsysenglish, booksynopsysurdu
    }
    
//    static func favoriteAudios() -> Audios {
//        let realm = DataManager.shared.realm
//        let audios = realm.objects(Audio.self).filter("favorite == true")
//        return audios.toArray()
//    }
}

class AudioRealm {
    static let realm = DataManager.shared.realm
    
    //MARK:- Favorite Audios
    static func favoriteAudios() -> Audios {
        let audios = realm.objects(Audio.self).filter("favorite == true")
        return audios.toArray()
    }
    
    static func updateFavoriteFlag(_ object: Audio, favFlag: Bool) {
        try! AudioRealm.realm.write {
            object.favorite = favFlag
            AudioRealm.realm.add(object, update: .all)
            /*
            // TODO : timestamp flag need to add
            if(!object.downloaded && !favFlag) {
                AudioRealm.realm.delete(object)
            }
            else {
                object.favorite = favFlag
                AudioRealm.realm.add(object, update: .all)
            }
           */
        }
    }
    
    static func resetAllFavoriteAudio() {
        let audios = realm.objects(Audio.self).filter("favorite == true")
        for audio in audios {
            try! AudioRealm.realm.write {
                audio.favorite = false
                AudioRealm.realm.add(audio, update: .all)
            }
        }
    }
    
    //MARK:- History
    static func historyAudios() -> Audios {
        let audios = realm.objects(Audio.self).filter("historyTimeStamp != 0 ").sorted(byKeyPath: "historyTimeStamp", ascending: false)
        return audios.toArray()
    }
    
    static func updateHistory(_ object: Audio, shouldReset: Bool) {
        try! AudioRealm.realm.write {
            object.historyTimeStamp = shouldReset ? 0 : Int(Date().timeIntervalSince1970)
            AudioRealm.realm.add(object, update: .all)
        }
    }
    
    static func resetAllAudioHistory() {
        let audios = realm.objects(Audio.self).filter("historyTimeStamp != 0")
        for audio in audios {
            try! AudioRealm.realm.write {
                audio.historyTimeStamp = 0
                AudioRealm.realm.add(audio, update: .all)
            }
        }
    }
    
    //MARK:- Download
    static func downloadedAudios() -> Audios {
        let audios = realm.objects(Audio.self).filter("downloaded == true")
        return audios.toArray()
    }
    
    static func updateDownloadedFlag(_ object: Audio, flag: Bool) {
        DispatchQueue.main.async {
            try! AudioRealm.realm.write {
                object.downloaded = flag
                AudioRealm.realm.add(object, update: .all)
            }
        }
    }
    
    static func resetAllDownloadedAudioFlag() {
        let audios = realm.objects(Audio.self).filter("downloaded == true")
        for audio in audios {
            try! AudioRealm.realm.write {
                audio.downloaded = false
                AudioRealm.realm.add(audio, update: .all)
            }
        }
    }
    
    
    //MARK:- Common Audio Realm
    static func saveAudio(_ object: Audio, favFlag: Bool?, dwnloadFlag: Bool?) {
        try! AudioRealm.realm.write {
            object.favorite = favFlag ?? object.favorite
            object.downloaded = dwnloadFlag ?? object.downloaded
            AudioRealm.realm.add(object, update: .all)
        }
    }
    
    static func audioFromURL(_ urlStr: String) -> Audio? {
        let audio = AudioRealm.realm.objects(Audio.self).first { (rlmAudio) -> Bool in
            rlmAudio.url == urlStr
        }
        return audio
        //filter("url == '\(urlStr)'")
       // return audios.count > 0 ? audios.first : nil
    }
    
    static func deleteRealmAudio(_ audio: Audio) {
        let objectToDelete = AudioRealm.realm.objects(Audio.self).filter("url == '\(audio.url)'")
        try! AudioRealm.realm.write {
            AudioRealm.realm.delete(objectToDelete)
        }
    }
    
    static func deleteAllUncategorisedRealmAudios() {
        let audios = AudioRealm.realm.objects(Audio.self).filter("downloaded != true && historyTimeStamp == 0 && favorite != true")
        try! AudioRealm.realm.write {
            AudioRealm.realm.delete(audios)
        }
    }
}


typealias Audios = [Audio]
