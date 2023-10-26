//
//  FileManager+extention.swift
//  IslamicAudioBook
//
//  Created by Ameer Shaikh on 26/09/2020.
//  Copyright © 2020 Ameer. All rights reserved.
//

import Foundation

extension FileManager {

  class func directoryUrl() -> URL? {
    let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

    let myAudioPath = documentsUrl.appendingPathComponent("Audios")
    // Copy file to document directory
    if !FileManager.default.fileExists(atPath: myAudioPath.path) {
        try! FileManager.default.createDirectory(atPath: myAudioPath.path, withIntermediateDirectories: false, attributes: nil)
    }

    return myAudioPath
  }
    
    class func localAudioPath(audio:String) -> URL? {
        if let documentsUrl = FileManager.directoryUrl() {
            let audioUrl = URL(string: audio)!
            let destinationUrl = documentsUrl.appendingPathComponent((audioUrl.lastPathComponent))
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                return destinationUrl
            }
        }
        return nil
    }

  class func allDownloadedAudios() -> [URL]? {
     if let documentsUrl = FileManager.directoryUrl() {
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            return directoryContents.filter{ $0.pathExtension == "mp3" }
        } catch {
            return nil
        }
     }
     return nil
  }
    
  class func deleteAudioFile (audio:String) {
        if let documentsUrl = FileManager.directoryUrl() {
           do {
            let audioUrl = URL(string: audio)!
            let destinationUrl = documentsUrl.appendingPathComponent((audioUrl.lastPathComponent))
            try FileManager.default.removeItem(at: destinationUrl)
           } catch {
             AppLogger.log("Failed to delete file")
           }
        }
    }
    
    
    
    class func deleteAllAudiosFromDirectory() {
        if let documentsUrl = FileManager.directoryUrl() {
           do {
             try FileManager.default.removeItem(at: documentsUrl)
           } catch {
             AppLogger.log("Failed to delete file")
           }
        }
    }
    
}
