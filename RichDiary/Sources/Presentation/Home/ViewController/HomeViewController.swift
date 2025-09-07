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
    
    
    //MARK: - Func
    
    override func setUI() {
        self.view.backgroundColor = .gray11
        self.view.addSubview(scrollview)
        scrollview.addSubview(contentView)
        contentView.addSubviews(headerView)
    }
    
    override func setStyle() {
        scrollview.do {
            $0.showsVerticalScrollIndicator = false
        }
        
    }
    
    override func setLayout() {
        scrollview.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(view.frame.height + 100)
        }
        
        headerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(52)
            
        }
    }
}

#Preview {
    HomeViewController()
}
