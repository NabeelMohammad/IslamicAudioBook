//
//  MiniPlayerViewController.swift
//  IslamicAudioBook
//
//  Created by Ameer Shaikh on 09/09/2020.
//  Copyright © 2020 Ameer. All rights reserved.
//

import UIKit

class MiniPlayerViewController: MediaPlayerViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // # 005493
        let color = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 105.0/255.0, alpha: 1.0)
        self.view.addBorder(toSide: .Top, withColor: color.cgColor, andThickness: 2)
    }
    override func initialiseSetUp() {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AppLogger.log("viewWillAppear : MiniPlayerViewController")
        updateUI()
    }
        
    func updateUI() {
        myPlayer = DataManager.shared.audioBookPlayer
        if(myPlayer != nil) {
            self.view.isHidden = false
            myPlayer?.delegate = self
            myPlayer?.mapAudioPlayerWithMiniPlayerUI()
        }
        else {
            self.view.isHidden = true
        }
    }
    
    @IBAction override func closePlayer(_ sender: UIButton) {
        super.closePlayer(sender)
        
        NotificationCenter.default.post(name: Notification.Name("HideContainerIdentifier"), object: nil)

        updateUI()
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
