//
//  HomeViewController.swift
//  RichDiary-iOS
//
//  Created by OneTen on 9/5/25.
//

import UIKit

import SnapKit

final class HomeViewController: BaseUIViewController {
    
    // MARK: - UI Components
    
    private let scrollview = UIScrollView()
    private let contentView = UIView()
    private let headerView = HomeHeaderView()
    private let summaryView = HomeSummaryView()
    private let separator = UIView()
    
    
    //MARK: - Func
    
    override func setUI() {
        self.view.addSubviews(headerView, scrollview)
        scrollview.addSubview(contentView)
        contentView.addSubviews(summaryView, separator)
    }
    
    override func setStyle() {
        scrollview.do {
            $0.showsVerticalScrollIndicator = false
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 40
            $0.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        }
        
        separator.do {
            $0.backgroundColor = .gray5
        }
    }
    
    override func setLayout() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(52)
        }
        
        scrollview.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(25)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(view.frame.height + 100)
        }
        
        summaryView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(250)
        }
        
        separator.snp.makeConstraints {
            $0.top.equalTo(summaryView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(10)
        }
    }
}

#Preview {
    TabBarViewController()
}
