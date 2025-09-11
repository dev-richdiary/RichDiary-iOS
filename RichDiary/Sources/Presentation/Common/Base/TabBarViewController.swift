//
//  TabBarViewController.swift
//  RichDiary-iOS
//
//  Created by OneTen on 7/24/25.
//

import UIKit

import SnapKit
import Then

protocol TabBarResettable {
    func resetToInitialState()
}

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    // MARK: - UI Components

    private lazy var floatingButton = UIButton()
    
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabBar()
        setUI()
        setStyle()
        setLayout()
    }

    
    //MARK: - Private Func

    private func setUI() {
        self.view.addSubview(floatingButton)
    }
    
    private func setStyle() {
        floatingButton.do {
            var config = UIButton.Configuration.filled()
            config.baseBackgroundColor = .gray10
            config.cornerStyle = .capsule
            config.image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
            
            $0.configuration = config
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOpacity = 0.3
            $0.layer.shadowOffset = CGSize(width: 0, height: 2)
            $0.layer.shadowRadius = 4
            $0.addTarget(self, action: #selector(didTapFloatingButton), for: .touchUpInside)
        }
    }
    
    private func setLayout() {
        floatingButton.snp.makeConstraints { make in
            make.size.equalTo(56)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(self.tabBar.snp.top).offset(-16)
        }
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
        
        viewControllers = [homeVC, calendarVC]
    }
    
    
    //MARK: - Func

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let resettableVC = viewController as? TabBarResettable {
            resettableVC.resetToInitialState()
        }
    }
    
}


//MARK: - Button Event

extension TabBarViewController {
    @objc private func didTapFloatingButton() {
        print("가계부 작성 버튼 클릭")
    }
}
