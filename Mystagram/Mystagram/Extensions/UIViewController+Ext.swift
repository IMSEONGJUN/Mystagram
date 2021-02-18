//
//  UIViewController+Ext.swift
//  Mystagram
//
//  Created by SEONGJUN on 2021/02/18.
//

import UIKit
import JGProgressHUD

extension UIViewController {
    
    static let hud = JGProgressHUD(style: .dark)
    
    func configureGradientLayer() {
        let gradient = CAGradientLayer()
        let topColor = #colorLiteral(red: 1, green: 0.9944892197, blue: 0.7521914475, alpha: 1).cgColor
        let bottomColor = #colorLiteral(red: 0.6196078431, green: 0.4235294118, blue: 0.1254901961, alpha: 1).cgColor
        gradient.colors = [topColor, bottomColor]
        gradient.locations = [0, 1]
        view.layer.addSublayer(gradient)
        gradient.frame = view.frame
    }
    
    func showActivityIndicator(_ show: Bool, withText text: String? = "Loading") {
        view.endEditing(true)
        UIViewController.hud.textLabel.text = text
        
        if show {
            UIViewController.hud.show(in: view)
        } else {
            UIViewController.hud.dismiss()
        }
    }
    
    func switchToHomeVC() {
        if #available(iOS 13.0, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                let window = UIWindow(windowScene: windowScene)
                window.backgroundColor = .systemBackground
                let mainVC = MainTabBarController()
                let rootVC = UINavigationController(rootViewController: mainVC)
                window.rootViewController = rootVC

                let sceneDelegate = windowScene.delegate as? SceneDelegate
                window.makeKeyAndVisible()
                sceneDelegate?.window = window
            }
        } else {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.backgroundColor = .systemBackground
            let mainVC = MainTabBarController()
            let rootVC = UINavigationController(rootViewController: mainVC)
            window.rootViewController = rootVC
            
            window.makeKeyAndVisible()
            appDelegate.window = window
        }

    }
}
