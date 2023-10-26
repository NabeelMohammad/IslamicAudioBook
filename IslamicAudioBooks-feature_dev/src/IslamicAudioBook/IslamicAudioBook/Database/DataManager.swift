//
//  DataManager.swift
//  IslamicAudioBook
//
//  Created by Ameer Shaikh on 06/08/2020.
//  Copyright © 2020 Ameer. All rights reserved.
//

import Foundation
import RealmSwift

class DataManager: NSObject {
    static let shared = DataManager()
    
    var audioBookPlayer : AudioBookPlayer?
    
    var selectedBook: Book? = nil

    var selectedChapterId : String = ""
    
    func initialisePlayer(audios:Audios, position:Int) {
        resetAudioPlayer()
        audioBookPlayer = AudioBookPlayer(audioDataSource: audios, selectedPosition: position)
    }
    
    func resetAudioPlayer()  {
        if let player = audioBookPlayer {
            player.closePlayer()
        }
        audioBookPlayer = nil
        NotificationCenter.default.post(name: Notification.Name("HideContainerIdentifier"), object: nil)
    }
    
    lazy var realm = try! Realm()

    fileprivate override init() {
        super.init()
        self.initializeRealmDB()
    }

    //MARK:- Realm Support
    func saveRealmArray(_ objects: [Object]) {
        try! realm.write {
            self.realm.add(objects, update: .all)  
        }
    }
    
    func saveRealmObject(_ object: Object) {
        try! realm.write {
            self.realm.add(object, update: .all)
        }
    }
    
    
    
    func initializeRealmDB() {
        var config = Realm.Configuration(
            
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            
            schemaVersion: 2,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            
            migrationBlock: { migration, oldSchemaVersion in
                
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                
                if (oldSchemaVersion < 1) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })
        
        Realm.Configuration.defaultConfiguration = config
        //print("config")
        let realmURL = Realm.Configuration.defaultConfiguration.fileURL!
        //print(realmURL)
        config = Realm.Configuration()
        config.deleteRealmIfMigrationNeeded = true
    }
}



extension Results {
    func toArray() -> [Results.Element] {
        return self.map{$0}
    }
}
