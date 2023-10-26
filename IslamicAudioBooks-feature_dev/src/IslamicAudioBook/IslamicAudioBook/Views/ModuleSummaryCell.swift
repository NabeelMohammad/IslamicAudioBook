//
//  ModuleSummaryCell.swift
//  IslamicAudioBook
//
//  Created by Ameer Shaikh on 03/08/2020.
//  Copyright © 2020 Ameer. All rights reserved.
//

import UIKit

class ModuleSummaryCell: UITableViewCell {
    
    @IBOutlet weak var radicalView: RadialGradientView!
    @IBOutlet weak var moduleImage: UIImageView!
    @IBOutlet weak var engTitle: UILabel!
    @IBOutlet weak var urduTitle: UILabel!
    @IBOutlet weak var chapterCount: UILabel!
    @IBOutlet weak var engSynopsis: UILabel!
    @IBOutlet weak var urduSynopsis: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
