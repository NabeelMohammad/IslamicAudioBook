//
//  MenuTableViewController.swift
//  IslamicAudioBook
//
//  Created by Ameer Shaikh on 09/08/2020.
//  Copyright © 2020 Ameer. All rights reserved.
//

import UIKit
import StoreKit

struct MenuItem {
    let menuImage : UIImage
    let menuTitle : String
}
typealias Menu = [MenuItem]

class MenuViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var versionLabel: UILabel!
    var menuList:Menu = []
    
    let menuItems  = [
        ["About Us" : "info.circle.fill"], //0
        ["Favourite" : "heart.circle"],
        ["History" : "circle.grid.3x3.fill"], // 2
        ["Download List" : "icloud.and.arrow.down.fill"],
        ["Feedback" : "text.quote"],
        ["FAQ" : "questionmark.circle.fill"],//5
        ["Social Network" : "shuffle"],
        ["Testimonial" : "doc.append"], //7
        ["Rate us on App Store" : "hand.thumbsup.fill"]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showShareNavigationItem()
        
        versionLabel.text =  "v \(Bundle.main.versionNumber).\(Bundle.main.buildNumber)"
    }

    // MARK: - Table view data source
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
     }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCellIdentifier", for: indexPath) as! MenuTableViewCell

        let dict = menuItems[indexPath.row]
        cell.menuTitle.text = dict.keys.first
        if #available(iOS 13.0, *) {
            cell.menuImage.image = UIImage(systemName: dict.values.first!)!
        } else {
            // Fallback on earlier versions
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let index = indexPath.row
        let dict = menuItems[index]
        
        switch index {
        case 0: //  About uS
           let nextVC  = NavHelper.requestNextScreen("AboutUsViewController", currentController: self) as! AboutUsViewController
            self.navigationController?.pushViewController(nextVC, animated: true)
        case 1:
            let nextVC  = NavHelper.requestNextScreen("RecordListViewController", currentController: self) as! RecordListViewController
            nextVC.recordMode = .favorite
            self.navigationController?.pushViewController(nextVC, animated: true)
        case 2:
            let nextVC  = NavHelper.requestNextScreen("RecordListViewController", currentController: self) as! RecordListViewController
            nextVC.recordMode = .history
            self.navigationController?.pushViewController(nextVC, animated: true)
        case 3:
            let nextVC  = NavHelper.requestNextScreen("RecordListViewController", currentController: self) as! RecordListViewController
            nextVC.recordMode = .download
            self.navigationController?.pushViewController(nextVC, animated: true)
        case 4:
            let nextVC  = NavHelper.requestNextScreen("FeedbackViewController", currentController: self) as! FeedbackViewController
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        case 5: // FAQ
            let nextVC = NavHelper.requestNextScreen("FAQTableViewController", currentController: self) as! FAQTableViewController
            self.navigationController?.pushViewController(nextVC, animated: true)
        case 6: // Social Media
            let nextVC = NavHelper.requestNextScreen("SocialMediaViewController", currentController: self) as! SocialMediaViewController
            self.navigationController?.pushViewController(nextVC, animated: true)

        case 7: // FAQ
            let nextVC = NavHelper.requestNextScreen("TestimonialTableViewController", currentController: self) as! TestimonialTableViewController
            self.navigationController?.pushViewController(nextVC, animated: true)

        default:
            SKStoreReviewController.requestReview()

        }
    }
    
}
