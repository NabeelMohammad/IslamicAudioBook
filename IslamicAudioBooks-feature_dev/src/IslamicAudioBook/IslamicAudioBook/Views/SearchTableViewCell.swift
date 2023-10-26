//
//  SearchTableViewCell.swift
//  IslamicAudioBook
//
//  Created by Ameer Shaikh on 13/09/2020.
//  Copyright © 2020 Ameer. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var urduTitle: UILabel!
    @IBOutlet weak var engTitle: UILabel!
    @IBOutlet weak var searchImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
