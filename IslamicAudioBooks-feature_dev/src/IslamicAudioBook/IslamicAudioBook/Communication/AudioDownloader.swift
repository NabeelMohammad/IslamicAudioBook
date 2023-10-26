//
//  AudioDownloader.swift
//  IslamicAudioBook
//
//  Created by Ameer Shaikh on 26/09/2020.
//  Copyright © 2020 Ameer. All rights reserved.
//

import Foundation

class AudioDownloader: NSObject {
    static let shared = AudioDownloader()

    let documentsUrl = FileManager.directoryUrl()
    
//    let musicArray:[String] = []//["url1", "url2","url3"]
//    var musicUrls:[URL?]!

    fileprivate override init() {
        super.init()
    }
    // create a function to start the audio data download
//    func getAudioDataFromUrl(audioUrl:URL, completion: @escaping (URL?, Error?)-> Void) {
    func downloadAudio(audio:Audio, completion: @escaping (Bool)-> Void) {
        
        let audioUrl = URL(string: audio.url)!
        let destinationUrl = documentsUrl?.appendingPathComponent((audioUrl.lastPathComponent))
        if FileManager().fileExists(atPath: destinationUrl!.path) {
            AppLogger.log("The file \"\(destinationUrl?.lastPathComponent ?? "~~~")\" already exists at path.")
            completion(true)
        } else {
            AppLogger.log("Started downloading \"\(String(describing: audioUrl.lastPathComponent))\".")
            

            URLSession.shared.downloadTask(with: audioUrl, completionHandler: { (URLData, response, error) -> Void in
            do {
                let isFileExists: Bool? = FileManager.default.fileExists(atPath: destinationUrl!.path)
                if isFileExists == true{
                    // For safer side, in case DB not updated correctly while previous download
                    AudioRealm.updateDownloadedFlag(audio, flag: true)
                    AppLogger.log("Alreasy exists \(destinationUrl!)")
                } else {
                    try FileManager.default.copyItem(at: URLData!, to: destinationUrl!)
                    AudioRealm.updateDownloadedFlag(audio, flag: true)
                    AppLogger.log("Saving file at  \(destinationUrl!)")
                }
                completion(true)
            } catch let error {
                AppLogger.log(error.localizedDescription)
                completion(false)
            }
        }).resume()
            
        }
    }

}
    // create a loop to start downloading your urls

