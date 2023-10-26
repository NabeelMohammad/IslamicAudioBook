//
//  FeaturedViewController.swift
//  IslamicAudioBook
//
//  Created by Ameer Shaikh on 03/08/2020.
//  Copyright © 2020 Ameer. All rights reserved.
//

import UIKit
import RappleProgressHUD

protocol AudioSelectionProtocol {
    func onAudioSelelction(_ position: Int, audionList: Audios)
}

class FeaturedViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, AudioSelectionProtocol {

    @IBOutlet weak var featuredTavleView: UITableView!

    var azkarList: Audios = []
    var latestAudioList: Audios = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  self.view.layerGradient()

        self.showShareNavigationItem()

        self.featuredTavleView.tableFooterView = UIView()
        self.featuredTavleView.rowHeight = UITableView.automaticDimension
        self.featuredTavleView.estimatedRowHeight = 250
        
        prepareAzkarDataSource()
        prepareLatestAudioDataSource()
    }
    
    func prepareAzkarDataSource() {
        RappleActivityIndicatorView.startAnimating()
        
        ServerCommunications.featuredAzkar { (result) in
            RappleActivityIndicatorView.stopAnimation()
            guard let res = result else { return }
            
            self.azkarList = res
            self.featuredTavleView.reloadData()
        }
    }
    
    func prepareLatestAudioDataSource() {
        RappleActivityIndicatorView.startAnimating()
        
        ServerCommunications.featuredTrendingAudios { (result) in
            RappleActivityIndicatorView.stopAnimation()
            guard let res = result else {  return }
            
            self.latestAudioList = res
            self.featuredTavleView.reloadData()
        }
    }

    
    // TableView Delegate/DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "featureCellIdentifier", for: indexPath) as! FeatureTableViewCell
        
        if(indexPath.row == 0 ) {
            cell.collectionTitle.text = azkarList.count > 0 ? "Azkar Of The Day" : ""
            cell.audioCollection = azkarList
            
        } else {
            cell.collectionTitle.text = latestAudioList.count > 0 ? "Latest Audio" : ""
            cell.audioCollection = latestAudioList
        }
        cell.reloadCollectionView()
        cell.delegate = self
      
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height/2.5
    }
    

    func onAudioSelelction(_ position: Int, audionList: Audios) {
        DataManager.shared.initialisePlayer(audios: audionList, position: position)
        // present the player
        self.navigateToMediaPlayer()
    }
}

/*
extension FeaturedViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(section == 0) {
           return azkarList.count
        }
        return latestAudioList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let categoryIdentifier = "featureCategoryCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryIdentifier, for: indexPath) as! FeatureCollectionViewCell
        
        var audio : Audio
        if(indexPath.section == 0) {
            audio = azkarList[indexPath.row]
        }
        else {
            audio = latestAudioList[indexPath.row]
        }
        cell.cellImage.loadAsyncImage(imageUrl: audio.logoMin)
        cell.cellTitle.text = audio.audioname
        cell.cellTitleUrdu.text = audio.audionameurdu
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //delegate?.onAudioSelelction(indexPath.row, audionList: audioCollection)
    }
}
*/
