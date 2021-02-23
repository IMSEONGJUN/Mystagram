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
        let topColor = #colorLiteral(red: 0.6474329829, green: 0.315310955, blue: 0.8544284701, alpha: 1).cgColor
        let bottomColor = #colorLiteral(red: 0.0755487904, green: 0.458819747, blue: 0.9912772775, alpha: 1).cgColor
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