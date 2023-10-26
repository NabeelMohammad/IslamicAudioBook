//
//  FAQTableViewController.swift
//  IslamicAudioBook
//
//  Created by Ameer Shaikh on 14/09/2020.
//  Copyright © 2020 Ameer. All rights reserved.
//

import UIKit
import RappleProgressHUD

class FAQTableViewController: UITableViewController {
    
    var faqDataSource:FAQ = []

    override func viewDidLoad() {
        super.viewDidLoad()
       // self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)

        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 200
        
        getFAQFromServer()
    }
    
    func getFAQFromServer() {
        RappleActivityIndicatorView.startAnimating()
                
        ServerCommunications.faqList(completion: {(result) in
            RappleActivityIndicatorView.stopAnimation()
            self.faqDataSource = result ?? []
            self.tableView.reloadData()
        })
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqDataSource.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "faqCellIdentifier", for: indexPath) as! QATableViewCell
    
        // Configure the cell...
        let index = indexPath.row
        let faq = faqDataSource[index]
        cell.titleLable.text = "\(index+1). " + faq.question
        cell.detailLabel.text =  faq.ans

        cell.backgroundColor = (index % 2) == 0 ? UIColor.clear : UIColor.white
        
        return cell
    }

}
