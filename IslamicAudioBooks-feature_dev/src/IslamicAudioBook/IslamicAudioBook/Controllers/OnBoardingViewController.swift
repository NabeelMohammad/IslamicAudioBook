//
//  OnBoardingViewController.swift
//  IslamicAudioBook
//
//  Created by Ameer Shaikh on 28/09/2020.
//  Copyright © 2020 Ameer. All rights reserved.
//

import UIKit


class OnBoardingViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var skipBtn: UIButton!
    
    @IBOutlet weak var onBoardingScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
   
    var frame = CGRect.zero
    var bannerWidth : CGFloat  = 200.0
    
    let banners  = [
        OnBoarding("onboard_1.png", "Swipe to chekout \n our features", ""),
        OnBoarding("onboard_2.png",  "Four Main Categories","چار اہم اقسام"),
        OnBoarding("onboard_3.png", "Search in Urdu & English", "اردو یا انگریزی میں تلاش کریں"),
        OnBoarding("onboard_4.png", "Downloaded audios can be accessed from menu", "ڈاؤنلوڈ کئے گئے آڈیوز دستیاب ہے مینو سے رسائی حاصل کریں"),
        OnBoarding("onboard_5.png", "Share on social media", "سوشل میڈیا پر شیئر کریں"),
        OnBoarding("onboard_6.png", "Access Menu for more options ", "مزید اختیارات کے لئے مینو سے رسائی حاصل کریں")
    ]
    
    var pageCount : Int = 0
    var sliderTimer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        self.navigationController?.navigationBar.isHidden = true
        
        let flag = AppDefaults.getBoolFromUserDefaults(DefaultKeys.showOnBorading) ?? false
        
        flag ?  skipClicked() : prepareBannerView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sliderTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(moveToNextBanner), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if(sliderTimer != nil) {
            sliderTimer!.invalidate()
        }
    }
    
    @objc func rotated() {
        self.setupBannerScreens()
    }
    
    func prepareBannerView() {
        self.pageCount = self.banners.count
        self.pageControl.numberOfPages = self.pageCount;
        self.setupBannerScreens()
    }
        
    func setupBannerScreens() {
      bannerWidth = view.frame.size.width ;
        
     self.onBoardingScrollView.subviews.forEach({ if($0.isKind(of: UIImageView.self)) {
                $0.removeFromSuperview()
            } })
        
        for index in 0..<pageCount {
            // 1.
            let start = bannerWidth * CGFloat(index)
            frame = CGRect(x: start, y: 0, width: bannerWidth , height: onBoardingScrollView.frame.height )
 
            // 2.
            let onBoard = banners[index]
            let customView = CustomOnBoardPage.instanceFromNib() as? CustomOnBoardPage
            customView?.frame = frame
            
            customView?.image.image = UIImage(named: onBoard.imageName)
            customView?.titleLabel.text = onBoard.englisgTitle
            customView?.subTitleLabel.text = onBoard.urduTitle
            
            self.onBoardingScrollView.addSubview(customView!)
            
        }
        self.onBoardingScrollView.layoutSubviews()
        onBoardingScrollView.isPagingEnabled = true

        onBoardingScrollView.contentSize = CGSize(width: (bannerWidth * CGFloat(pageCount)), height: onBoardingScrollView.frame.size.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / bannerWidth
        pageControl.currentPage = Int(pageNumber)
        
        updateButtonUI()
    }
    
    func updateButtonUI() {
        let currentPage = pageControl.currentPage
        continueBtn.tag = currentPage
        if currentPage != (pageCount - 1)  {
           // continueBtn.setTitle("  Continue  ", for: .normal)
            skipBtn.setTitle("  Skip  ", for: .normal)
            continueBtn.isHidden = true
            skipBtn.isHidden = false
        } else {
            continueBtn.setTitle(" Get Started! ", for: .normal)
            skipBtn.isHidden = true
            continueBtn.isHidden = false
        }
    }
    
    @objc func moveToNextBanner () {
        let pageWidth:CGFloat = self.onBoardingScrollView.frame.width
        let maxWidth:CGFloat = pageWidth * CGFloat(pageCount)
        let contentOffset:CGFloat = self.onBoardingScrollView.contentOffset.x
                
        var slideToX = contentOffset + pageWidth
                
        if  contentOffset + pageWidth == maxWidth {
              slideToX = 0
        } else if  slideToX + pageWidth == maxWidth {
            if(sliderTimer != nil) {
                sliderTimer!.invalidate()
            }
        }
        
        let pageNumber = slideToX / pageWidth
        pageControl.currentPage = Int(pageNumber)
        updateButtonUI()
        
        self.onBoardingScrollView.scrollRectToVisible(CGRect(x:slideToX, y:0, width:pageWidth, height:self.onBoardingScrollView.frame.height), animated: true)
    }
    
    @IBAction func skipClicked() {
        // Move to Splash screen        
        guard let vc = storyboard?.instantiateViewController(identifier: "SplashViewController") as? SplashViewController else {
            return
        }
        
        AppDefaults.saveBoolToUserDefaults(DefaultKeys.showOnBorading, value: true)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func continueClicked() {
        let currentPage = pageControl.currentPage
        if currentPage == (pageCount - 1) {
            // Move to Splash screen
            skipClicked()
        }
        else {
            // Move to next onBoarding screen
            moveToNextBanner()
        }
    }
}

struct OnBoarding {
    let imageName, urduTitle, englisgTitle: String
    
    init(_ imageNm:String,  _ enTitle:String, _ urTitle:String) {
        self.imageName = imageNm
        self.urduTitle = urTitle
        self.englisgTitle = enTitle
    }
}
