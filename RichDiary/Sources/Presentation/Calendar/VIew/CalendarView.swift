//
//  CalendarView.swift
//  RichDiary
//
//  Created by OneTen on 9/10/25.
//

import UIKit

import SnapKit
import Then

final class CalendarView: BaseUIView {
    
    //MARK: - Properties
    
    let dayOfTheWeek = ["일", "월", "화", "수", "목", "금", "토"]
    
    
    //MARK: - UI Properties
    
    private let monthLabel = UILabel()
    private lazy var previousMonthButton = UIButton()
    private lazy var nextMonthButton = UIButton()
    private lazy var weekStackView = UIStackView()
    private lazy var calendarCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    
    //MARK: - Func

    override func setUI() {
        self.addSubviews(monthLabel, previousMonthButton, nextMonthButton, weekStackView, calendarCollectionView)
        
        dayOfTheWeek.forEach {
            let label = UILabel()
            label.attributedText = .richStyle($0, style: .custom(fontWeight: .bold, size: 20))
            label.textAlignment = .center
            label.textColor = .gray12
            self.weekStackView.addArrangedSubview(label)
        }
    }
    
    override func setStyle() {
        monthLabel.do {
            $0.attributedText = .richStyle("9월", style: .custom(fontWeight: .semiBold, size: 26))
        }
        
        previousMonthButton.do {
            $0.setBackgroundImage(UIImage(systemName: "arrowtriangle.left.fill"), for: .normal)
            $0.tintColor = .black
            $0.addTarget(self, action: #selector(onTapPreviousMonth), for: .touchUpInside)
            $0.accessibilityLabel = "이전 달"
        }
        
        nextMonthButton.do {
            $0.setBackgroundImage(UIImage(systemName: "arrowtriangle.right.fill"), for: .normal)
            $0.tintColor = .black
            $0.addTarget(self, action: #selector(onTapNextMonth), for: .touchUpInside)
            $0.accessibilityLabel = "다음 달"
        }
        
        weekStackView.do {
            $0.distribution = .fillEqually
            $0.axis = .horizontal
        }
        
        calendarCollectionView.do {
            $0.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: CalendarCollectionViewCell.cellIdentifier)
        }
    }
    
    override func setLayout() {
        previousMonthButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(35)
            $0.leading.equalToSuperview().inset(30)
            $0.size.equalTo(20)
        }
        
        monthLabel.snp.makeConstraints {
            $0.centerY.equalTo(previousMonthButton)
            $0.leading.equalTo(previousMonthButton.snp.trailing).offset(10)
        }
        
        nextMonthButton.snp.makeConstraints {
            $0.centerY.equalTo(previousMonthButton)
            $0.leading.equalTo(monthLabel.snp.trailing).offset(10)
            $0.size.equalTo(20)
        }
        
        weekStackView.snp.makeConstraints {
            $0.top.equalTo(monthLabel.snp.bottom).offset(30)
            $0.horizontalEdges.equalToSuperview().inset(25)
        }
        
        calendarCollectionView.snp.makeConstraints {
            $0.top.equalTo(weekStackView.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(25)
            $0.bottom.equalToSuperview()
        }
    }
}

//MARK: - Private Func

extension CalendarView {
    @objc private func onTapPreviousMonth() {
        print("이전 달 클릭")
    }
    
    @objc private func onTapNextMonth() {
        print("다음 달 클릭")
    }
}
