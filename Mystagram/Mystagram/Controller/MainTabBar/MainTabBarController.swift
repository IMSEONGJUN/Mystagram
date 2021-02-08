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
        configureControllers()
    }
    
    func configureControllers() {
        let feedVC = wrapInNavigationVC(unselectedImage: #imageLiteral(resourceName: "home_unselected"),selectedImage: #imageLiteral(resourceName: "home_selected"),roovViewController: FeedController.create(with: FeedViewModel()))
        
        let searchVC = wrapInNavigationVC(unselectedImage: #imageLiteral(resourceName: "search_unselected"),selectedImage: #imageLiteral(resourceName: "search_selected"),roovViewController: SearchController.create(with: SearchViewModel()))
        
        let imageSelectVC = wrapInNavigationVC(unselectedImage: #imageLiteral(resourceName: "plus_unselected"),selectedImage: #imageLiteral(resourceName: "plus_unselected"),roovViewController: ImageSelectController.create(with: ImageSelectViewModel()))
        
        let notiVC = wrapInNavigationVC(unselectedImage: #imageLiteral(resourceName: "like_unselected"),selectedImage: #imageLiteral(resourceName: "like_selected"),roovViewController: NotiController.create(with: NotiViewModel()))
        
        let profileVC = wrapInNavigationVC(unselectedImage: #imageLiteral(resourceName: "profile_unselected"),selectedImage: #imageLiteral(resourceName: "profile_selected"),roovViewController: ProfileController.create(with: ProfileViewModel()))
        
        viewControllers = [feedVC, searchVC, imageSelectVC, notiVC, profileVC]
        tabBar.tintColor = .black
    }
    
    func wrapInNavigationVC(unselectedImage: UIImage,
                            selectedImage: UIImage,
                            roovViewController: UIViewController) -> UINavigationController {
        let navi = UINavigationController(rootViewController: roovViewController)
        navi.tabBarItem.selectedImage = selectedImage
        navi.tabBarItem.image = unselectedImage
        navi.navigationBar.tintColor = .black
        
        return navi
    }
}
