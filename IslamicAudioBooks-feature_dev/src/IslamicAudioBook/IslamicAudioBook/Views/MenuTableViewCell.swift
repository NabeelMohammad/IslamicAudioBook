//
//  MenuTableViewCell.swift
//  IslamicAudioBook
//
//  Created by Ameer Shaikh on 09/08/2020.
//  Copyright © 2020 Ameer. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var menuTitle: UILabel!
    @IBOutlet weak var menuImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
