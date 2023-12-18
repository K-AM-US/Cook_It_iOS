//
//  TabBarBehaviourController.swift
//  Cook_It_iOS
//
//  Created by Mauricio Casillas on 15/08/23.
//

import UIKit

class TabBarBehaviourController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
}
