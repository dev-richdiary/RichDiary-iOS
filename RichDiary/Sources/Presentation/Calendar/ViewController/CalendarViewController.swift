//
//  CalendarViewController.swift
//  RichDiary-iOS
//
//  Created by OneTen on 9/5/25.
//

import UIKit

import SnapKit
import Then

final class CalendarViewController: BaseUIViewController, TabBarResettable {
    
    // MARK: - Properties
    
    private var dummy = DiaryModel.dummy()
    
    
    // MARK: - UI Components
    
    private let scrollview = UIScrollView()
    private let contentView = UIView()
    private let headerView = CalendarHeaderView()
    private let calendarView = CalendarView()
    private let diaryStackView = UIStackView()
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectDate()
    }
    
    
    //MARK: - Func
    
    override func setUI() {
        self.view.addSubviews(headerView, scrollview)
        scrollview.addSubview(contentView)
        contentView.addSubviews(calendarView, diaryStackView)
    }
    
    override func setStyle() {
        scrollview.do {
            $0.showsVerticalScrollIndicator = false
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 40
            $0.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
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
        
        calendarView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        diaryStackView.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    func resetToInitialState() {
        scrollview.setContentOffset(.zero, animated: true)
        
        calendarView.resetToToday()
    }
}


//MARK: - Private Func

extension CalendarViewController {
    private func selectDate() {
        calendarView.onDateSelected = { [weak self] date in
            self?.updateDiaryTiles(for: date)
        }
    }
    
    private func updateDiaryTiles(for date: Date?) {
        guard let selectedDate = date else {
            diaryStackView.arrangedSubviews.forEach {
                diaryStackView.removeArrangedSubview($0)
                $0.removeFromSuperview()
            }
            return
        }
        
        let filteredDiaries = self.dummy.filter { diary in
            Calendar.current.isDate(diary.date, inSameDayAs: selectedDate)
        }
        
        diaryStackView.arrangedSubviews.forEach {
            diaryStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        filteredDiaries.forEach { model in
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

#Preview {
    TabBarViewController()
}
