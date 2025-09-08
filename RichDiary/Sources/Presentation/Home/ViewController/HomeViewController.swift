//
//  HomeViewController.swift
//  RichDiary-iOS
//
//  Created by OneTen on 9/5/25.
//

import UIKit

import SnapKit
import Then

final class HomeViewController: BaseUIViewController {
    
    // MARK: - UI Components
    
    private let scrollview = UIScrollView()
    private let contentView = UIView()
    private let headerView = HomeHeaderView()
    private let summaryView = HomeSummaryView()
    private let separator = UIView()
    private let diaryStackView = UIStackView()
    
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 예시 데이터를 생성합니다. 실제 앱에서는 API 통신 등으로 데이터를 가져옵니다.
        let sampleData = DiaryModel.dummy()
        
        setupDiaryTiles(with: sampleData)
    }
    
    
    //MARK: - Func
    
    override func setUI() {
        self.view.addSubviews(headerView, scrollview)
        scrollview.addSubview(contentView)
        contentView.addSubviews(summaryView, separator, diaryStackView)
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
        
        diaryStackView.do {
            $0.axis = .vertical
            $0.spacing = 0
            $0.distribution = .fill
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
        
        diaryStackView.snp.makeConstraints {
            $0.top.equalTo(separator.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
}


//MARK: - Private Func

extension HomeViewController {
    private func setupDiaryTiles(with models: [DiaryModel]) {
        // 기존에 추가된 뷰가 있다면 모두 제거 (데이터 업데이트 시 중복 방지)
        diaryStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        models.forEach { model in
            let tile = DiaryTile()
            tile.configure(with: model)
            
            tile.snp.makeConstraints {
                $0.height.equalTo(72)
            }
            
            diaryStackView.addArrangedSubview(tile)
        }
    }
}

#Preview {
    TabBarViewController()
}
