//
//  ModuleSummaryTVC.swift
//  IslamicAudioBook
//
//  Created by Ameer Shaikh on 02/08/2020.
//  Copyright © 2020 Ameer. All rights reserved.
//

import UIKit

class ModuleSummaryTVC: UITableViewController {
    
    var moduleBooks:Books = []
    var navTitle:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 450
        
        self.navigationItem.title = navTitle
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moduleBooks.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moduleSummaryCellIdentifier", for: indexPath) as! ModuleSummaryCell
        
        let module = moduleBooks[indexPath.row]
        
        cell.radicalView.OutsideColor = UIColor().hexStringToUIColor(hex: module.color)

        cell.moduleImage.loadAsyncImage(imageUrl: module.profileImage)
        cell.engTitle.text = module.name
        
        cell.urduTitle.text = module.nameurdu
        cell.chapterCount.text = "Chapetrs(\(module.chapters.count))"
        
        cell.engSynopsis.text = module.synopsys
        cell.urduSynopsis.text = module.synopsysurdu
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let module = moduleBooks[indexPath.row]
        let chapterVC = NavHelper.requestNextScreen("ChaptersViewController", currentController: self) as! ChaptersViewController
        
        DataManager.shared.selectedBook = module
        
        chapterVC.chapterCount = "\(module.chapters.count)"
            
        chapterVC.navigationItem.title = module.name
            
        self.navigationController?.pushViewController(chapterVC, animated: true)
        
    }
}
