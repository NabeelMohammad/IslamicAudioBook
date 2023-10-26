//
//  MainDashboardVCViewController.swift
//  IslamicAudioBook
//
//  Created by Ameer Shaikh on 28/07/2020.
//  Copyright © 2020 Ameer. All rights reserved.
//

import UIKit
import SDWebImage
import RappleProgressHUD


class MainDashboardViewController: BaseViewController, UIScrollViewDelegate {

    //@IBOutlet weak var containerHeight: NSLayoutConstraint!

    @IBOutlet weak var topBannerScrollView: UIScrollView!
    @IBOutlet weak var bannerPageControl: UIPageControl!
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    var frame = CGRect.zero
    var bannerWidth : CGFloat  = 200.0
    var banners: Slider = []
    var pageCount : Int = 0
    
    var categories : Category = []
    
    var sliderTimer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
     //   self.view.layerGradient()
        self.showShareNavigationItem()
        prepareBannerView()
        prepareDashboradCategories()
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
    
    @objc override func rotated() {
        self.setupBannerScreens()
        self.categoryCollectionView.reloadData()
    }
    
    func prepareDashboradCategories() {
        RappleActivityIndicatorView.startAnimating()
        ServerCommunications.getDashboardCategories(completion: {(result) in
            self.categories = result ?? []
            self.categoryCollectionView.reloadData()
            RappleActivityIndicatorView.stopAnimation()
        })
    }
    

    
    // MARK :  Banner View
    func prepareBannerView() {

        RappleActivityIndicatorView.startAnimating()
        ServerCommunications.getActiveSliders(completion: {(result) in
            RappleActivityIndicatorView.stopAnimation()
            guard let res = result else {
                self.banners = []
                return
            }
            
            self.banners = res
            self.pageCount = self.banners.count
            self.bannerPageControl.numberOfPages = self.pageCount;
            self.setupBannerScreens()
            
        })
    }
    
    func setupBannerScreens() {
      bannerWidth = view.frame.size.width ;
        
     self.topBannerScrollView.subviews.forEach({ if($0.isKind(of: UIImageView.self)) {
                $0.removeFromSuperview()
            } })
        
        for index in 0..<pageCount { //movies.count {
            // 1.
            let start = bannerWidth * CGFloat(index) + 10
            frame = CGRect(x: start, y: 0, width: bannerWidth - 20, height: topBannerScrollView.frame.height )
 
            // 2.
            let imgView = UIImageView(frame: frame)
            imgView.contentMode = .scaleAspectFit
//            imgView.image = UIImage(named:banners[index].image ?? "")

//            loadImage(imageUrl: banners[index].image ?? "", mediaImage: imgView)
            imgView.loadAsyncImage(imageUrl:  banners[index].image ?? "")
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            imgView.tag = index
            imgView.addGestureRecognizer(tap)
            imgView.isUserInteractionEnabled = true
            
            self.topBannerScrollView.addSubview(imgView)
        }
        topBannerScrollView.isPagingEnabled = true

        topBannerScrollView.contentSize = CGSize(width: (bannerWidth * CGFloat(pageCount)), height: topBannerScrollView.frame.size.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / bannerWidth
        bannerPageControl.currentPage = Int(pageNumber)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        let slider = banners[tappedImage.tag]
        
        RappleActivityIndicatorView.startAnimating()
                
        ServerCommunications.getSliderAudio(audioId: slider.audio ?? "", completion: {(result) in
            RappleActivityIndicatorView.stopAnimation()
            
            let position = 0
            DataManager.shared.initialisePlayer(audios: result ?? [], position: position)

            self.navigateToMediaPlayer()
        })
    }
    
    @objc func moveToNextBanner () {
        let pageWidth:CGFloat = self.topBannerScrollView.frame.width
            let maxWidth:CGFloat = pageWidth * CGFloat(pageCount)
        let contentOffset:CGFloat = self.topBannerScrollView.contentOffset.x
                
        var slideToX = contentOffset + pageWidth
                
        if  contentOffset + pageWidth == maxWidth {
              slideToX = 0
        }
        self.topBannerScrollView.scrollRectToVisible(CGRect(x:slideToX, y:0, width:pageWidth, height:self.topBannerScrollView.frame.height), animated: true)
    
    }
}

extension MainDashboardViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let categoryIdentifier = "categoryCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryIdentifier, for: indexPath) as! CatgeoryCollectionViewCell
        
        let category: CategoryElement = categories[indexPath.row]
//        loadImage(imageUrl: category.logo, mediaImage: cell.imageView)
        cell.imageView.loadAsyncImage(imageUrl: category.logo)
        cell.categoryTitle.text = category.modulename
        cell.radicalView.OutsideColor = UIColor().hexStringToUIColor(hex: category.color)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category: CategoryElement = categories[indexPath.row]
        
        RappleActivityIndicatorView.startAnimating()
        
        ServerCommunications.getCategoryDetails(moduleName: category.modulename, completion: {(result) in
            RappleActivityIndicatorView.stopAnimation()
            
            guard let res = result else {
                return
            }
            if (res.count > 1) {
                
               let moduleVC = NavHelper.requestNextScreen("ModuleSummaryTVC", currentController: self) as! ModuleSummaryTVC
                
                moduleVC.moduleBooks = res
                moduleVC.navTitle = category.modulename
                
                self.navigationController?.pushViewController(moduleVC, animated: true)
            }
            else {
                let chapterVC = NavHelper.requestNextScreen("ChaptersViewController", currentController: self) as! ChaptersViewController
                
                // TODO: Pass these details in more proper way
                let book = res.first
                
                if ((book) != nil) {
                    DataManager.shared.selectedBook = book
                    chapterVC.chapterCount = "\(book?.chapters.count ?? 0)"
                }
                chapterVC.navigationItem.title = category.modulename
                self.navigationController?.pushViewController(chapterVC, animated: true)
            }
        })
    }
}


extension MainDashboardViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenWidth = view.frame.size.width / 2.5
        
        return CGSize(width: screenWidth, height: screenWidth)
    }
}
