//
//  NavigationHelper.swift
//  IslamicAudioBook
//
//  Created by Ameer Shaikh on 03/08/2020.
//  Copyright © 2020 Ameer. All rights reserved.
//

import Foundation
import UIKit

class NavHelper: NSObject {
    
    static func  moveToScreen(_ destinationControllerId:String, currentController:UIViewController) {
           let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
           let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: destinationControllerId) as UIViewController
           
           NavHelper.addTransitionAnimationToController(currentController: vc)
           currentController.navigationController?.pushViewController(vc, animated: false)
       }
       
       static func requestNextScreen(_ destinationControllerId:String, currentController:UIViewController) -> UIViewController {
           let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
           let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: destinationControllerId) as UIViewController
           
           NavHelper.addTransitionAnimationToController(currentController: currentController)
           return vc
       }
    
    static func addTransitionAnimationToController(currentController:UIViewController) {
        let transition = CATransition()
         transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal

        transition.subtype = CATransitionSubtype.fromRight
         
         currentController.navigationController?.view.layer.add(transition, forKey: kCATransition)
    }
}
