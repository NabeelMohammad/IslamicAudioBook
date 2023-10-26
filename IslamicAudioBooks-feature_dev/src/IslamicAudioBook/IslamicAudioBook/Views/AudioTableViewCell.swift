//
//  AudioTableViewCell.swift
//  IslamicAudioBook
//
//  Created by Ameer Shaikh on 07/08/2020.
//  Copyright © 2020 Ameer. All rights reserved.
//

import UIKit

class AudioTableViewCell: UITableViewCell {
    @IBOutlet weak var audioIndex: UILabel!
    @IBOutlet weak var audioTitle: UILabel!
    @IBOutlet weak var downloadBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
