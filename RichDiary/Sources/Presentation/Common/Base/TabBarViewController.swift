//
//  TabBarViewController.swift
//  RichDiary-iOS
//
//  Created by OneTen on 7/24/25.
//

import UIKit

protocol TabBarResettable {
    func resetToInitialState()
}

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabBar()
    }

    private func setTabBar() {
        self.delegate = self
        
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        homeVC.view.backgroundColor = .gray11
        
        let calendarVC = CalendarViewController()
        calendarVC.tabBarItem = UITabBarItem(title: "캘린더", image: UIImage(systemName: "calendar"), selectedImage: UIImage(systemName: "calendar"))
        calendarVC.view.backgroundColor = .gray11
        
        self.tabBar.tintColor = .gray11
        self.tabBar.unselectedItemTintColor = .lightGray
        self.tabBar.backgroundColor = .gray2
        
        viewControllers = [calendarVC, homeVC]
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let resettableVC = viewController as? TabBarResettable {
            resettableVC.resetToInitialState()
        }
    }
}

