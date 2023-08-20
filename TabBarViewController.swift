//
//  TabBarViewController.swift
//  TrackHabitApp
//
//  Created by iAlesha уличный on 06.04.2023.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = UIColor(named: "Purple")
        setupVC()
        
        
    }
    
    func setupVC() {
        viewControllers = [
            createNavigationControllers(rootVC: HabitsListViewController(), title: "Привычки", image: UIImage(named: "TabBarLeftIcon")!),
            createNavigationControllers(rootVC: InfoViewController(), title: "Информация", image: UIImage(systemName: "info.circle.fill")!)
        ]
    }
    
    func createNavigationControllers(rootVC: UIViewController, title: String, image: UIImage) -> UINavigationController {
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.tabBarItem.title = title
        navVC.tabBarItem.image = image
        return navVC
    }


}
