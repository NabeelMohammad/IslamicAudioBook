//
//  TestimonialTableViewController.swift
//  IslamicAudioBook
//
//  Created by Ameer Shaikh on 14/09/2020.
//  Copyright © 2020 Ameer. All rights reserved.
//

import UIKit
import RappleProgressHUD

class TestimonialTableViewController: UITableViewController {
        var testimonialDataSource:Testimonial = []

        override func viewDidLoad() {
            super.viewDidLoad()
           // self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)

            self.tableView.tableFooterView = UIView()
            self.tableView.rowHeight = UITableView.automaticDimension
            self.tableView.estimatedRowHeight = 200
            
            getTestimonialFromServer()
        }
        
        func getTestimonialFromServer() {
            RappleActivityIndicatorView.startAnimating()
                    
            ServerCommunications.testimonialList(completion: {(result) in
                RappleActivityIndicatorView.stopAnimation()
                self.testimonialDataSource = result ?? []
                self.tableView.reloadData()
            })
        }

        // MARK: - Table view data source

        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return testimonialDataSource.count
        }

        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "testimonialCellIdentifier", for: indexPath) as! QATableViewCell

            // Configure the cell...
            let index = indexPath.row
            let testimonial = testimonialDataSource[index]
            cell.titleLable.text =  testimonial.name
            cell.detailLabel.text =  testimonial.message

            cell.backgroundColor = (index % 2) == 0 ? UIColor.clear : UIColor.white

            return cell
        }

    }
