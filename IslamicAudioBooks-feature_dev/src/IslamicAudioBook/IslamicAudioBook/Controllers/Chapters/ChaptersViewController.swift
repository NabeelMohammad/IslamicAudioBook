//
//  ChaptersViewController.swift
//  IslamicAudioBook
//
//  Created by Ameer Shaikh on 06/08/2020.
//  Copyright © 2020 Ameer. All rights reserved.
//

import UIKit

class ChaptersViewController: BaseViewController {

    @IBOutlet weak var chapterView: UIView!
    @IBOutlet weak var detailView: UIView!

    @IBOutlet weak var segmentContol: UISegmentedControl!
    
   // @IBOutlet weak var containerHeight: NSLayoutConstraint!

    
    var chapterCount = "0"
    @IBOutlet weak var shareBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            let image1 =  UIImage.textEmbeded(image: UIImage(systemName: "book")!, string: "Chapters(\(chapterCount))", isImageBeforeText: true)
            segmentContol.setImage(image1, forSegmentAt: 0)

        } else {
            // Fallback on earlier versions
            let image1 =  UIImage.textEmbeded(image: UIImage(named: "book")!, string: "Chapters(\(chapterCount))", isImageBeforeText: true)
            segmentContol.setImage(image1, forSegmentAt: 0)
        }
        
        if #available(iOS 13.0, *) {
            let image2 =  UIImage.textEmbeded(image: UIImage(systemName: "info.circle")!, string: "Details", isImageBeforeText: true)
            segmentContol.setImage(image2, forSegmentAt: 1)

        } else {
            // Fallback on earlier versions
            let image2 =  UIImage.textEmbeded(image: UIImage(named: "info")!, string: "Details", isImageBeforeText: true)
            segmentContol.setImage(image2, forSegmentAt: 1)

        }
        
        
        let image3 =  UIImage.textEmbeded(image: UIImage(named: "share_plain")!, string: "Share", isImageBeforeText: true)
        image3.withTintColor(.red)
        shareBtn.setImage(image3, for: .normal)
        shareBtn.tintColor = .white
    }
    
    @IBAction func shareBtnClicked(_ sender: Any) {
        
        let shareText = "To listen to more chapters from \"\(DataManager.shared.selectedBook?.name ?? "")\",  \(Constants.appShareText)"
        
        openShareView(text: shareText)
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        if(sender.selectedSegmentIndex == 0) {
            chapterView.alpha = 1
            detailView.alpha = 0
        }
        else {
            chapterView.alpha = 0
            detailView.alpha = 1
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "containerViewSegue" {
            let viewController = segue.destination as! DetailViewController
            
            let book = DataManager.shared.selectedBook!
            viewController.engText = book.details
            viewController.urduText = book.detailsurdu
        }
    }
    

}
