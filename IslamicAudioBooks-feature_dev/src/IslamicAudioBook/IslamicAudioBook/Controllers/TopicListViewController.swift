//
//  TopicListViewController.swift
//  IslamicAudioBook
//
//  Created by Ameer Shaikh on 06/08/2020.
//  Copyright © 2020 Ameer. All rights reserved.
//

import UIKit
import RappleProgressHUD

class TopicListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var topicTableView: UITableView!

    var dataSource:Topics = []
    var chapterId:String = ""
    var navTitle = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.topicTableView.tableFooterView = UIView()
        self.topicTableView.rowHeight = UITableView.automaticDimension
        self.topicTableView.estimatedRowHeight = 200
        
        self.navigationItem.title = navTitle
        
        prepareDataSource()
    }
    
     func prepareDataSource() {
        RappleActivityIndicatorView.startAnimating()
                
        ServerCommunications.subTopicsOfChapters(chapterId: chapterId, completion: {(result) in
            RappleActivityIndicatorView.stopAnimation()

            guard let res = result else {
                return
            }
            self.dataSource = res
            self.topicTableView.reloadData()
        })
        
    }

    @IBAction  func shareChapterRowClicked(_ sender: UIButton) {
        let topic = dataSource[sender.tag]

        let shareText = "To listen to more chapters from \"\(topic.topic )\",  \(Constants.appShareText)"
        
        openShareView(text: shareText)
        
    }
    // MARK: - Table view data source
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "topicCellIdentifier", for: indexPath) as! ChapterTableViewCell
    
        
        let topic = dataSource[indexPath.row]
        
        cell.chapterIndex.text = "\(indexPath.row)"
        cell.engTitle.text = topic.topic
        cell.urduTitle.text = topic.topicurdu
        
        cell.shareBtn.tag = indexPath.row
        
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let topic = dataSource[indexPath.row]
        let audioVC = NavHelper.requestNextScreen("AudioListViewController", currentController: self) as! AudioListViewController
        
        audioVC.chapterId = chapterId
        audioVC.navTitle = topic.topic
        audioVC.topicId = topic.topicno

        self.navigationController?.pushViewController(audioVC, animated: true)
        
    }

}
