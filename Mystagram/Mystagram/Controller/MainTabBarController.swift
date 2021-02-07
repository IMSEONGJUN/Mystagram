//
//  MainTabBarController.swift
//  Mystagram
//
//  Created by SEONGJUN on 2021/02/07.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configureControllers() {
        let feed = FeedController.create(with: FeedViewModel())
    }
}
