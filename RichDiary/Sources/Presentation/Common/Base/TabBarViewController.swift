//
//  TabBarViewController.swift
//  RichDiary-iOS
//
//  Created by OneTen on 7/24/25.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabBar()
    }

    private func setTabBar() {
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
}

