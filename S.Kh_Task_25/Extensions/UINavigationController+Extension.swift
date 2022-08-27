//
//  UINavigationController+Extension.swift
//  S.Kh_Task_25
//
//  Created by Saba Khitaridze on 27.08.22.
//

import UIKit

extension UINavigationController {

    var rootViewController: UIViewController? {
        return viewControllers.first
    }

}
