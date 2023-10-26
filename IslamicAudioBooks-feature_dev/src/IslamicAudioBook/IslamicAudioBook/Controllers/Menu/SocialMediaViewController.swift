//
//  SocialMediaViewController.swift
//  IslamicAudioBook
//
//  Created by Ameer Shaikh on 14/09/2020.
//  Copyright © 2020 Ameer. All rights reserved.
//

import UIKit

class SocialMediaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var menuList:Menu = []
        
        let menuItems  = [
            ["Website" : "website"], //0
            ["Facebook" : "facebook"],
            ["Twitter" : "twitter"], // 2
            ["Instagram" : "instagram"],
            ["Youtube" : "youtube"],
        ]

        override func viewDidLoad() {
            super.viewDidLoad()
            self.showShareNavigationItem()
        }

        // MARK: - Table view data source
         func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return menuItems.count
         }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "socialCellIdentifier", for: indexPath) as! MenuTableViewCell

            let dict = menuItems[indexPath.row]
            cell.menuTitle.text = dict.keys.first
            cell.menuImage.image = UIImage(named: dict.values.first!)!
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            tableView.deselectRow(at: indexPath, animated: true)
            
            let index = indexPath.row
            var loadURL = ""
            switch index {
            case 0: //  Website
               loadURL = "https://islamicaudiobooks.info"
            case 1: // facebook
                loadURL = "https://m.facebook.com/islamicaudiobooks.info/"
            case 2: // tweeter
                loadURL = "https://mobile.twitter.com/AudioBooksIslam"
            case 3: // instagram
                loadURL = "https://www.instagram.com/IslamicAudioBooksInfo"

            default: // youtube
                loadURL = "https://www.youtube.com/IslamicAudioBooksInfo/"
            }
            
            guard let url = URL(string: loadURL) else { return }
            UIApplication.shared.open(url)
        }
        
    }
