//
//  QATableViewCell.swift
//  IslamicAudioBook
//
//  Created by Ameer Shaikh on 14/09/2020.
//  Copyright © 2020 Ameer. All rights reserved.
//

import UIKit

class QATableViewCell: UITableViewCell {

    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var titleLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
