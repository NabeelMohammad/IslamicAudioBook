//
//  DetailViewController.swift
//  IslamicAudioBook
//
//  Created by Ameer Shaikh on 06/08/2020.
//  Copyright © 2020 Ameer. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailTextView: UITextView!
    
    var engText = ""
    var urduText = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.detailTextView.layer.borderWidth = 1.0
        detailTextView.layer.borderColor = UIColor().hexStringToUIColor(hex: "#005493").cgColor
        detailTextView.layer.cornerRadius = 5

        detailTextView.text = engText
    }
    
    @IBAction func langChanged(_ sender: UISegmentedControl) {
        
        if(sender.selectedSegmentIndex == 0) {
            detailTextView.text = engText
            detailTextView.textAlignment = .left
        }
        else {
            detailTextView.text = urduText
            detailTextView.textAlignment = .right
        }
    }
}
