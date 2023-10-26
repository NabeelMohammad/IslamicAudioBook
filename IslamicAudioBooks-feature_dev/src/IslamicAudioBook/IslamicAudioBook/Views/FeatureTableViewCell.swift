//
//  FeatureTableViewCell.swift
//  IslamicAudioBook
//
//  Created by Ameer Shaikh on 08/08/2020.
//  Copyright © 2020 Ameer. All rights reserved.
//

import UIKit

class FeatureTableViewCell: UITableViewCell {

//    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionTitle: UILabel!
    
    var audioCollection: Audios = []
    var delegate:AudioSelectionProtocol? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func reloadCollectionView() {
        self.collectionView.reloadData()
    }
    
    /*
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        
        // With autolayout enabled on collection view's cells we need to force a collection view relayout with the shown size (width)
        self.collectionView.layoutIfNeeded()
        self.collectionView.frame = CGRect.init(origin: .zero, size: CGSize.init(width: targetSize.width, height: targetSize.height))
       // self.collectionView.layoutIfNeeded()
//        self.frame = self.collectionView.frame

        // If the cell's size has to be exactly the content
        // Size of the collection View, just return the
        // collectionViewLayout's collectionViewContentSize.
        return self.collectionView!.collectionViewLayout.collectionViewContentSize
    }
    */
 
}

extension FeatureTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return audioCollection.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let categoryIdentifier = "featureCategoryCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryIdentifier, for: indexPath) as! FeatureCollectionViewCell
        
        let audio = audioCollection[indexPath.row]
        cell.cellImage.loadAsyncImage(imageUrl: audio.logoMin)
        cell.cellTitle.text = audio.audioname
        cell.cellTitleUrdu.text =  audio.audionameurdu
        
//        cell.layer.shouldRasterize = true
//        cell.layer.rasterizationScale = UIScreen.main.scale
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.onAudioSelelction(indexPath.row, audionList: audioCollection)
    }
}


extension FeatureTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 150, height: 250)
    }
}

