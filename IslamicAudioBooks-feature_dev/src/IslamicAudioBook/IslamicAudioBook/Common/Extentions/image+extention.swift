//
//  image+extention.swift
//  IslamicAudioBook
//
//  Created by Ameer Shaikh on 03/08/2020.
//  Copyright © 2020 Ameer. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

extension UIImageView {
    func loadAsyncImage(imageUrl:String ) {
        let imageURL = URL(string: imageUrl)
        self.sd_imageIndicator?.startAnimatingIndicator()
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.sd_setImage(with: imageURL)
    }
}

extension UIImage {
    static func textEmbededLinear(image: UIImage,
                           string: String,
                isImageBeforeText: Bool,
                          segFont: UIFont? = nil) -> UIImage {
        let font = segFont ?? UIFont.systemFont(ofSize: 14)
        let expectedTextSize = (string as NSString).size(withAttributes: [.font: font])
        let width = expectedTextSize.width + image.size.width + 5
        let height = max(expectedTextSize.height, image.size.width)
        let size = CGSize(width: width, height: height)

        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            let fontTopPosition: CGFloat = (height - expectedTextSize.height) / 2
            let textOrigin: CGFloat = isImageBeforeText
                ? image.size.width + 5
                : 0
            let textPoint: CGPoint = CGPoint.init(x: textOrigin, y: fontTopPosition)
            string.draw(at: textPoint, withAttributes: [.font: font])
            let alignment: CGFloat = isImageBeforeText
                ? 0
                : expectedTextSize.width + 5
            let rect = CGRect(x: alignment,
                              y: (height - image.size.height) / 2,
                          width: image.size.width,
                         height: image.size.height)
            image.draw(in: rect)
        }
    }
    
    static func textEmbeded(image: UIImage,
                           string: String,
                isImageBeforeText: Bool,
                          segFont: UIFont? = nil) -> UIImage {
        let font = segFont ?? UIFont.systemFont(ofSize: 14)
        let expectedTextSize = (string as NSString).size(withAttributes: [.font: font])
        
        let imgSize = CGSize(width: 20, height: 20)
        let  updatedImage = image.imageResize(sizeChange: imgSize)

        
        let height  = expectedTextSize.height + updatedImage.size.height + 5
        let width = max(expectedTextSize.width, updatedImage.size.width)
        
        
        let size = CGSize(width: width, height: height)

        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            let fontTopPosition: CGFloat = (height - expectedTextSize.height) / 2
            let textOrigin: CGFloat = isImageBeforeText
                ? updatedImage.size.height + 5
                : 0
            let textPoint: CGPoint = CGPoint.init(x:0 , y: textOrigin )
            
            let textFontAttributes = [
                NSAttributedString.Key.font: font,
               // NSAttributedString.Key.foregroundColor: UIColor.red
                ]
            
            string.draw(at: textPoint, withAttributes: textFontAttributes)
            
            let rect = CGRect(x: (width - updatedImage.size.width) / 2,
                              y: 3,//(height - image.size.height) / 2,
                              width: updatedImage.size.width,
                              height: updatedImage.size.height)
            
            updatedImage.draw(in: rect)
        }
    }
    
    func imageResize (sizeChange:CGSize)-> UIImage{

        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen

        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))

        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
    }
}
