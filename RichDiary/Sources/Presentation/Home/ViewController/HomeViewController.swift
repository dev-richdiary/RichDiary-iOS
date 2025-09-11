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
    
    // MARK: - Properties

    let dummy = DiaryModel.dummy()
    
    
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
        
        setDiaryTiles(with: dummy)
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
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(-20)
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
    private func createDateHeaderLabel(for date: Date) -> UIView {
        let label = UILabel()
        let container = UIView()
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일 EEEE" // ex) 9월 11일 목요일
        
        label.do {
            $0.text = formatter.string(from: date)
            $0.font = .systemFont(ofSize: 14, weight: .medium)
            $0.textColor = .gray
        }
        
        container.addSubviews(label)
        
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
        
        return container
    }
    
    private func setDiaryTiles(with models: [DiaryModel]) {
        // 기존 뷰 제거
        diaryStackView.arrangedSubviews.forEach {
            diaryStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        let groupedByDate = Dictionary(grouping: models) { model in
            return Calendar.current.startOfDay(for: model.date)
        }
        
        let sortedDates = groupedByDate.keys.sorted(by: >)
        
        sortedDates.forEach { date in
            // 날짜 헤더 추가
            let header = createDateHeaderLabel(for: date)
            diaryStackView.addArrangedSubview(header)
            
            header.snp.makeConstraints {
                $0.height.equalTo(40)
            }
            
            // 해당 날짜의 다이어리 타일들 추가
            if let diariesForDate = groupedByDate[date] {
                diariesForDate.forEach { model in
                    let tile = DiaryTile()
                    tile.configure(with: model)
                    tile.snp.makeConstraints {
                        $0.height.equalTo(72)
                    }
                    
                    tile.onTap = { [weak self] in
                        let detailVC = DiaryDetailViewController(diary: model)
                        detailVC.modalPresentationStyle = .overFullScreen
                        detailVC.modalTransitionStyle = .crossDissolve
                        self?.present(detailVC, animated: true)
                    }
                    
                    diaryStackView.addArrangedSubview(tile)
                }
            }
            
        }
    }
}

#Preview {
    TabBarViewController()
}
