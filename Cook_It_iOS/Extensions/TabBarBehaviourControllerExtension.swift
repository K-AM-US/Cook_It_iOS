//
//  TabBarBehaviourExtension.swift
//  Cook_It_iOS
//
//  Created by Mauricio Casillas on 15/08/23.
//

import Foundation
import UIKit

extension UITabBarController: UITabBarControllerDelegate {
    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController is UINavigationController {
            if let navController = viewController as? UINavigationController {
                navController.popViewController(animated: false)
            }
        }
    }
}
