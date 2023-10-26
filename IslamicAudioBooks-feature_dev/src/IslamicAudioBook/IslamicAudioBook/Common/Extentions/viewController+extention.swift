//
//  viewController+extention.swift
//  IslamicAudioBook
//
//  Created by Ameer Shaikh on 10/08/2020.
//  Copyright © 2020 Ameer. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func openShareView(text:String) {
        let linkToShare = [text]

        let activityController = UIActivityViewController(activityItems: linkToShare, applicationActivities: nil)

        self.present(activityController, animated: true, completion: nil)
    }
    
    func showShareNavigationItem() {
//        let shareImg =  UIImage.textEmbeded(image: UIImage(named: "share_plain")!, string: "Share", isImageBeforeText: true)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "share_plain"), style: .done, target: self, action: #selector(shareApp))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
    }
    
    @objc func shareApp(){
        openShareView(text: Constants.appShareText)
    }
}


extension UIView {

    enum ViewSide {
        case Left, Right, Top, Bottom
    }

    func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {

        let border = CALayer()
        border.backgroundColor = color

        switch side {
        case .Left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height); break
        case .Right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height); break
        case .Top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness); break
        case .Bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness); break
        }

        layer.addSublayer(border)
    }
    
        func layerGradient() {
            let layer : CAGradientLayer = CAGradientLayer()
            layer.frame.size = self.frame.size
            //layer.frame.origin = CGPoint()
            //layer.cornerRadius = CGFloat(frame.width / 20)
            
            let darkColor =  UIColor().hexStringToUIColor(hex: "#005493").cgColor
            let colorTop =  UIColor().hexStringToUIColor(hex: "#60C4FF").cgColor
            let colorBottom = UIColor().hexStringToUIColor(hex: "#c7eaff").cgColor

            layer.colors = [colorBottom]
//            layer.colors = [UIColor.green.cgColor, UIColor.red.cgColor, UIColor.purple.cgColor, UIColor.orange.cgColor,]
            self.layer.insertSublayer(layer, at: 0)
        }
}

extension UITextView {

    func addDoneButton(title: String, target: Any, selector: Selector) {

        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))//1
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)//2
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)//3
        toolBar.setItems([flexible, barButton], animated: false)//4
        self.inputAccessoryView = toolBar//5
    }
}

