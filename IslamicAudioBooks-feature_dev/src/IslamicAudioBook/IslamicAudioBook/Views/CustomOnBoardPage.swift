//
//  CustomOnBoardPage.swift
//  IslamicAudioBook
//
//  Created by Ameer Shaikh on 28/09/2020.
//  Copyright © 2020 Ameer. All rights reserved.
//

import UIKit

class CustomOnBoardPage: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "CustomOnBoardPage", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
}
