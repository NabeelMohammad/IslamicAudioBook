//
//  AboutUsViewController.swift
//  IslamicAudioBook
//
//  Created by Ameer Shaikh on 09/08/2020.
//  Copyright © 2020 Ameer. All rights reserved.
//

import UIKit
import WebKit

class AboutUsViewController: UIViewController,WKNavigationDelegate {
    @IBOutlet weak var contentWebView: WKWebView!
    
    var selectedFileName = "about_us_eng"

    override func viewDidLoad() {
        super.viewDidLoad()
        reloadWebContent()
    }
    
    @IBAction func languageChanged(_ sender: UISegmentedControl) {
        
        selectedFileName = sender.selectedSegmentIndex == 0 ? "about_us_eng" : "about_us_urdu"
        
        reloadWebContent()
    }
    
    func reloadWebContent() {
        
        if let url = Bundle.main.url(forResource: selectedFileName, withExtension:"html")
        {
//            let urlRequest = URLRequest(url: url)
            self.contentWebView.load(URLRequest(url: url))
        }
        
    }

}
