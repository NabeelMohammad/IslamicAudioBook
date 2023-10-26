//
//  SplashViewController.swift
//  IslamicAudioBook
//
//  Created by Ameer Shaikh on 28/09/2020.
//  Copyright © 2020 Ameer. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var appLogoImage: UIImageView!
    var scaleFactor : CGFloat = 0.8
    var sliderTimer : Timer?
    
    var booksLoaded = false
    var chaptersLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AudioRealm.deleteAllUncategorisedRealmAudios()
        loadAllBookData()
        loadAllChapterData()

        // Do any additional setup after loading the view.
        animateLogo()
        sliderTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(animateLogo), userInfo: nil, repeats: true)
    }
    
    @objc func animateLogo() {
        UIView.animate(withDuration: 2) {
            self.appLogoImage.transform = CGAffineTransform(scaleX: self.scaleFactor, y: self.scaleFactor)
        }
        scaleFactor = scaleFactor == 0.8 ? 1.2 : 0.8
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if(sliderTimer != nil) {
            sliderTimer!.invalidate()
        }
    }
    
    func realmDataCleanUp() {
        
    }
    
    func loadAllChapterData() {
        ServerCommunications.getAllChapterData(completion: { [self](result) in
            guard let res = result else {
                self.chaptersLoaded = true
                self.launchMainApp()
                return
            }
            DataManager.shared.saveRealmArray(res)
            
            self.chaptersLoaded = true
            self.launchMainApp()
        })
    }
    
    func loadAllBookData() {
        ServerCommunications.getAllBookData(completion: {(result) in
            
            guard let res = result else {
                self.booksLoaded = true
                self.launchMainApp()
                return
            }
            DataManager.shared.saveRealmArray(res)
            self.booksLoaded = true
            self.launchMainApp()
        })
    }
    
    func launchMainApp()  {
        if (booksLoaded && chaptersLoaded) {
            let sceneDelegate = UIApplication.shared.connectedScenes
                    .first!.delegate as! SceneDelegate

            guard let tabVC = storyboard?.instantiateViewController(identifier: "AppTabViewController") as? AppTabViewController else {
                return
            }
            sceneDelegate.window!.rootViewController = tabVC
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
