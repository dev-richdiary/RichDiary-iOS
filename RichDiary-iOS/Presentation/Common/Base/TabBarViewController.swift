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
        
        let calendarVC = CalendarViewController()
        calendarVC.tabBarItem = UITabBarItem(title: "캘린더", image: UIImage(systemName: "calendar.fill"), selectedImage: UIImage(systemName: "calendar"))
        
        viewControllers = [homeVC, calendarVC]
    }
}

