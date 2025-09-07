//
//  HomeSummaryView.swift
//  RichDiary
//
//  Created by OneTen on 9/7/25.
//

import UIKit

import SnapKit
import Then

final class HomeSummaryView: BaseUIView {
    
    //MARK: - Properties
    
    private let month = 9
    private let expense = 475_180
    private let income = 100_180
    private let goal = 2_000_000
    
    
    //MARK: - UI Properties
    
    private let monthLabel = UILabel()
    private lazy var previousMonthButton = UIButton()
    private lazy var nextMonthButton = UIButton()
    
    private lazy var calendarButton = UIButton()
    
    private let expenseLabel = UILabel()
    private let expenseValueLabel = UILabel()
    private let incomeLabel = UILabel()
    private let incomeValueLabel = UILabel()
    private let goalLabel = UILabel()
    
    private lazy var progressView = UIProgressView()
    private let progressLabel = UILabel()
    
    
    //MARK: - Func
    
    override func setUI() {
        self.addSubviews(monthLabel, previousMonthButton, nextMonthButton, calendarButton, expenseLabel, expenseValueLabel, incomeLabel, incomeValueLabel, progressView, progressLabel, goalLabel)
    }
    
    override func setStyle() {
        monthLabel.do {
            $0.attributedText = .richStyle("\(month)월", style: .custom(fontWeight: .semiBold, size: 26))
            $0.textColor = .black
        }
        
        previousMonthButton.do {
            $0.setBackgroundImage(UIImage(systemName: "arrowtriangle.left.fill"), for: .normal)
            $0.tintColor = .black
            $0.addTarget(self, action: #selector(onTapPreviousMonthButton), for: .touchUpInside)
        }
        
        nextMonthButton.do {
            $0.setBackgroundImage(UIImage(systemName: "arrowtriangle.right.fill"), for: .normal)
            $0.tintColor = .black
            $0.addTarget(self, action: #selector(onTapNextMonthButton), for: .touchUpInside)
        }
        
        calendarButton.do {
            $0.setBackgroundImage(UIImage(systemName: "calendar.circle.fill"), for: .normal)
            $0.tintColor = .black
            $0.addTarget(self, action: #selector(onTapCalendarButton), for: .touchUpInside)
        }
        
        expenseLabel.do {
            $0.attributedText = .richStyle("지출", style: .custom(fontWeight: .medium, size: 20))
            $0.textColor = .gray10
        }
        
        expenseValueLabel.do {
            $0.attributedText = .richStyle(expense.asCurrencyString, style: .custom(fontWeight: .semiBold, size: 22))
            $0.textColor = .black
        }
        
        incomeLabel.do {
            $0.attributedText = .richStyle("수입", style: .custom(fontWeight: .medium, size: 20))
            $0.textColor = .gray10
        }
        
        incomeValueLabel.do {
            $0.attributedText = .richStyle(income.asCurrencyString, style: .custom(fontWeight: .semiBold, size: 22))
            $0.textColor = .black
        }
        
        progressView.do {
            let progressValue = min(Float(expense) / Float(goal), 1.0)
            $0.progress = progressValue
            $0.progressTintColor = expense > goal ? .red : .gray10
            $0.trackTintColor = .gray5
            $0.clipsToBounds = true
            $0.applyPillCornerRadius()
        }
        
        progressLabel.do {
            $0.attributedText = .richStyle("\(expense.asCurrencyString) / \(goal.asCurrencyString)", style: .custom(fontWeight: .semiBold, size: 16))
            $0.textAlignment = .center
            $0.textColor = .white
        }
        
        goalLabel.do {
            $0.attributedText = .richStyle("목표 지출금액: \(goal.asCurrencyString)", style: .caption1)
            $0.textColor = .gray8
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
        
        calendarButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(35)
            $0.size.equalTo(52)
        }
        
        expenseLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(35)
            $0.top.equalTo(monthLabel.snp.bottom).offset(25)
        }
        
        expenseValueLabel.snp.makeConstraints {
            $0.leading.equalTo(expenseLabel.snp.trailing).offset(20)
            $0.centerY.equalTo(expenseLabel)
        }
        
        incomeLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(35)
            $0.top.equalTo(expenseLabel.snp.bottom).offset(15)
        }
        
        incomeValueLabel.snp.makeConstraints {
            $0.leading.equalTo(incomeLabel.snp.trailing).offset(20)
            $0.centerY.equalTo(incomeLabel)
        }
        
        progressView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(35)
            $0.height.equalTo(30)
            $0.bottom.equalToSuperview().inset(40)
        }
        
        progressLabel.snp.makeConstraints {
            $0.center.equalTo(progressView)
        }
        
        goalLabel.snp.makeConstraints {
            $0.centerX.equalTo(progressView)
            $0.top.equalTo(progressView.snp.bottom).offset(10)
        }
    }
    
}


//MARK: - Private Func

extension HomeSummaryView {
    @objc private func onTapPreviousMonthButton() {
        print("이전 달 버튼 클릭")
    }
    
    @objc private func onTapNextMonthButton() {
        print("다음 달 버튼 클릭")
    }
    
    @objc private func onTapCalendarButton() {
        print("달력 버튼 클릭")
    }
}
