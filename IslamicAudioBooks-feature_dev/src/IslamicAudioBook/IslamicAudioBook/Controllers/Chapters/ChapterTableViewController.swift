//
//  ChapterTableViewController.swift
//  IslamicAudioBook
//
//  Created by Ameer Shaikh on 06/08/2020.
//  Copyright © 2020 Ameer. All rights reserved.
//

import UIKit
import RappleProgressHUD

class ChapterTableViewController: UITableViewController {
    
    var dataSource:Chapters = []
    var navTitle:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 200
        
        self.navigationItem.title = navTitle
        //self.view.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 0.7078606592)
        
        prepareDataSource()
    }
    
    func prepareDataSource() {
        RappleActivityIndicatorView.startAnimating()
        
        let _bookId = DataManager.shared.selectedBook?.id ?? ""
        
        ServerCommunications.chaptersByBookID(bookId: _bookId , completion: {(result) in
            RappleActivityIndicatorView.stopAnimation()

            guard let res = result else {
                return
            }
            self.dataSource = res
            self.tableView.reloadData()
        })
        
    }

    @IBAction func shareChapterRowClicked(_ sender: UIButton) {
        
        let chapter = dataSource[sender.tag]

        let shareText = "To listen to more chapters from \"\(chapter.chapter ?? "")\",  \(Constants.appShareText)"
        
        openShareView(text: shareText)
    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chapterCellIdentifier", for: indexPath) as! ChapterTableViewCell
        
        /*
        if(indexPath.row % 2 == 0) {
            cell.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 0.7078606592)
        }
        else {
            cell.backgroundColor = .white
        }
        */
        
        
        let chapter = dataSource[indexPath.row]
        
        cell.chapterIndex.text = "\(indexPath.row)"
        cell.engTitle.text = chapter.chapter
        cell.urduTitle.text = chapter.chapterurdu
        
        let count = chapter.audiocount ?? "0"
        cell.audioCount.text = " \(count) Audios "
        cell.shareBtn.tag = indexPath.row
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
        tableView.deselectRow(at: indexPath, animated: true)

        let chapter = dataSource[indexPath.row]
        let count = chapter.topiccount ?? "0"

        if(count == "0") {
            let audioVC = NavHelper.requestNextScreen("AudioListViewController", currentController: self) as! AudioListViewController
            
            audioVC.chapterId = chapter.id
            audioVC.navTitle = chapter.chapter!

            self.navigationController?.pushViewController(audioVC, animated: true)
        }
        else {
            let topicVC = NavHelper.requestNextScreen("TopicListViewController", currentController: self) as! TopicListViewController
            
            topicVC.chapterId = chapter.id
            topicVC.navTitle = chapter.chapter!

            self.navigationController?.pushViewController(topicVC, animated: true)
        }
    }

}
