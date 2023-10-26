//
//  BaseViewController.swift
//  IslamicAudioBook
//
//  Created by Ameer Shaikh on 10/09/2020.
//  Copyright © 2020 Ameer. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.layerGradient()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)

        NotificationCenter.default.addObserver(self, selector: #selector(self.showHideMiniPlayer), name: Notification.Name("HideContainerIdentifier"), object: nil)
        
            NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showHideMiniPlayer()
    }
    
    @objc func rotated() {
        
    }
    
    @objc func showHideMiniPlayer() {
                
        if (DataManager.shared.audioBookPlayer == nil) {
            self.containerHeight.constant = 0
        } else {
            self.containerHeight.constant = 150
        }
        self.view.layoutIfNeeded()
    }
    
    func navigateToMediaPlayer() {
        if #available(iOS 13.0, *) {
            guard let vc = storyboard?.instantiateViewController(identifier: "MediaPlayerViewController") as? MediaPlayerViewController else {
                return
            }
            self.navigationController?.pushViewController(vc, animated: true)

        } else {
            // Fallback on earlier versions
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "MediaPlayerViewController") as? MediaPlayerViewController else {
                return
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
        
    deinit {
        AppLogger.log("Remove NotificationCenter Deinit")
        NotificationCenter.default.removeObserver(self)
    }
}
