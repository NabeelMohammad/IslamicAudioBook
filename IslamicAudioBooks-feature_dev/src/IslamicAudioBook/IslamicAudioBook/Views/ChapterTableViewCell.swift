//
//  ChapterTableViewCell.swift
//  IslamicAudioBook
//
//  Created by Ameer Shaikh on 06/08/2020.
//  Copyright © 2020 Ameer. All rights reserved.
//

import UIKit

class ChapterTableViewCell: UITableViewCell {

    @IBOutlet weak var urduTitle: UILabel!
    @IBOutlet weak var engTitle: UILabel!
    @IBOutlet weak var audioCount: UILabel!
    @IBOutlet weak var chapterIndex: UILabel!
    @IBOutlet weak var shareBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class RecordTableViewCell: ChapterTableViewCell {

    @IBOutlet weak var chapterTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
