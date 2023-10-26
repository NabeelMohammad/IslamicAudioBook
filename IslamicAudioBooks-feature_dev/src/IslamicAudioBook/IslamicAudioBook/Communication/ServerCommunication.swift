//
//  ServerCommunication.swift
//  IslamicAudioBook
//
//  Created by Ameer Shaikh on 28/07/2020.
//  Copyright © 2020 Ameer. All rights reserved.
//

import Foundation
import Alamofire

class ServerCommunications : NSObject
{
    static let BASE_URL      = "https://islamicaudiobooks.info/audioapp/index.php/api/"

//MARK:- Slider
    static func getActiveSliders(completion: @escaping (Slider?) -> Void) {
        let url = BASE_URL + "slider"
    
        AF.request(url,method: .get, encoding : JSONEncoding.default).responseDecodable { (response: AFDataResponse<Slider>) in
            AppLogger.log(response)
            completion(response.value)
            return
        }
    }
    
    static func getSliderAudio(audioId:String, completion: @escaping (Audios?) -> Void) {
        let url = BASE_URL + "audio?a_id=\(audioId)"
    
        AF.request(url,method: .get, encoding : JSONEncoding.default).responseDecodable { (response: AFDataResponse<Audios>) in
                AppLogger.log(response)
                completion(response.value)
                return
        }
    }
    
    //MARK:- Book, Chapter & Audio
    static func getDashboardCategories(completion: @escaping (Category?) -> Void) {
        let url = BASE_URL + "moduls"
        
        AF.request(url,method: .get, encoding : JSONEncoding.default).responseDecodable { (response: AFDataResponse<Category>) in
                AppLogger.log(response)
                completion(response.value)
                return
        }
    }
    
    static func getAllBookData(completion: @escaping (Books?) -> Void) {
        let url = BASE_URL + "books"
        
        AF.request(url,method: .get, encoding : JSONEncoding.default).responseDecodable { (response: AFDataResponse<Books>) in
                AppLogger.log(response)
                completion(response.value)
                return
        }
    }
    
    static func getCategoryDetails(moduleName:String, completion: @escaping (Books?) -> Void) {
        
        var url = BASE_URL + "books?modules=\(moduleName)"
        url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        //Al Qur'an
        AF.request(url,method: .get, encoding : JSONEncoding.default).responseDecodable { (response: AFDataResponse<Books>) in
                AppLogger.log(response)
                completion(response.value)
                return
        }
    }
    
    // Chapters :
    static func getAllChapterData(completion: @escaping (Chapters?) -> Void) {
        let url = BASE_URL + "chapters"
        
        AF.request(url,method: .get, encoding : JSONEncoding.default).responseDecodable { (response: AFDataResponse<Chapters>) in
                AppLogger.log(response)
                completion(response.value)
                return
        }
    }
       
    static func chaptersByBookID(bookId:String, completion: @escaping (Chapters?) -> Void) {
        
        let url = BASE_URL + "chapters?book_id=\(bookId)"
        
        AppLogger.log(url)
        
        AF.request(url,method: .get, encoding : JSONEncoding.default).responseDecodable { (response: AFDataResponse<Chapters>) in
                AppLogger.log(response)
                completion(response.value)
                return
        }
    }
    
    static func subTopicsOfChapters(chapterId:String, completion: @escaping (Topics?) -> Void) {
        //topic?chapter_id=788
        let url = BASE_URL + "topic?chapter_id=\(chapterId)"
        
        AF.request(url,method: .get, encoding : JSONEncoding.default).responseDecodable { (response: AFDataResponse<Topics>) in
                AppLogger.log(response)
                completion(response.value)
                return
        }
    }
    
    static func audioListOfChapters(chapterId:String,topicId:String, completion: @escaping (Audios?) -> Void) {
        //audio?chapter_id=788
        //audio?chapter_id=788&topic=2
        
        let queryUrl = topicId == "" ? ""  : "&topic=\(topicId)"
        
        let url = BASE_URL + "audio?chapter_id=\(chapterId)" + queryUrl
        
        AF.request(url,method: .get, encoding : JSONEncoding.default).responseDecodable { (response: AFDataResponse<Audios>) in
                AppLogger.log(response)
                completion(response.value)
                return
        }
    }
    
    
    //MARK:- Featured View
    static func featuredAzkar(completion: @escaping (Audios?) -> Void) {
        let url = BASE_URL + "dailyazkar"
        AF.request(url,method: .get, encoding : JSONEncoding.default).responseDecodable { (response: AFDataResponse<Audios>) in
                AppLogger.log(response)
                completion(response.value)
                return
        }
    }
    
    static func featuredTrendingAudios(completion: @escaping (Audios?) -> Void) {
        // Latest Audios
        let url = BASE_URL + "trandingaudio"
        AF.request(url,method: .get, encoding : JSONEncoding.default).responseDecodable { (response: AFDataResponse<Audios>) in
                AppLogger.log(response)
                completion(response.value)
                return
        }
    }
    
    //MARK:- Search
    static func searchText(inputText:String, completion: @escaping (Audios?) -> Void) {
        
        let urlCompatableParamStr = inputText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let url = BASE_URL + "search?q=\(urlCompatableParamStr)"
        
        AF.request(url,method: .get, encoding : JSONEncoding.default).responseDecodable { (response: AFDataResponse<Audios>) in
                AppLogger.log(response)
                completion(response.value)
                return
        }
    }
    
    //MARK:- Menu
    static func faqList(completion: @escaping (FAQ?) -> Void) {
         let url = BASE_URL + "faq"
        
        AF.request(url,method: .get, encoding : JSONEncoding.default).responseDecodable { (response: AFDataResponse<FAQ>) in
                AppLogger.log(response)
                completion(response.value)
                return
        }
    }
    
    static func testimonialList(completion: @escaping (Testimonial?) -> Void) {
         let url = BASE_URL + "testimonial"
        
        AF.request(url,method: .get, encoding : JSONEncoding.default).responseDecodable { (response: AFDataResponse<Testimonial>) in
                AppLogger.log(response)
                completion(response.value)
                return
        }
    }
    
    static func submitFeedback(paramString: String, completion: @escaping (Feedback?) -> Void) {
        // https://islamicaudiobooks.info/audioapp/index.php/api/feedback?name=ameer &email=amir@gmail.com&feedback=This is testing &app=1.1&platform=iOS
        
        let urlCompatableParamStr = paramString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        let url = BASE_URL + "feedback?\(urlCompatableParamStr)&app=\(Bundle.main.versionNumber)&platform=iOS"
        
        AF.request(url,method: .get, encoding : JSONEncoding.default).responseDecodable { (response: AFDataResponse<Feedback>) in
                AppLogger.log(response)
                completion(response.value)
                return
        }
    }
}
