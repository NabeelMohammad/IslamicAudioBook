//
//  RadicalGradientView.swift
//  IslamicAudioBook
//
//  Created by Ameer Shaikh on 29/07/2020.
//  Copyright © 2020 Ameer. All rights reserved.
//

import UIKit

class RadialGradientView: UIView {

    @IBInspectable var InsideColor: UIColor = UIColor.white
    @IBInspectable var OutsideColor: UIColor = UIColor.clear

    override func draw(_ rect: CGRect) {
        let colors = [InsideColor.cgColor,InsideColor.cgColor,InsideColor.cgColor, OutsideColor.cgColor, OutsideColor.cgColor] as CFArray
       // let endRadius = min(frame.width, frame.height) / 2
         let endRadius = sqrt(pow(frame.width/2, 2) + pow(frame.height/2, 2))
        let center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        let gradient = CGGradient(colorsSpace: nil, colors: colors, locations: nil)
        UIGraphicsGetCurrentContext()!.drawRadialGradient(gradient!, startCenter: center, startRadius: 0.0, endCenter: center, endRadius: endRadius, options: CGGradientDrawingOptions.drawsBeforeStartLocation)
    }
}
