//
//  CalendarView.swift
//  RichDiary
//
//  Created by OneTen on 9/10/25.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

final class CalendarView: BaseUIView {
    
    // MARK: - Properties
    
    private var disposeBag = DisposeBag()
    
    private var currentCalendarDayData: CalendarDayData = CalendarDayData(days: [], diaryDates: [])
    private var currentSelectedDate: Date?
    private var currentMonthText: String = ""
    private var currentYearText: String = ""
    
    private var calendarCollectionViewHeightConstraint: Constraint?
    
    
    // MARK: - UI Components
    
    private let monthLabel = UILabel()
    private lazy var previousMonthButton = UIButton()
    private lazy var nextMonthButton = UIButton()
    private let yearLabel = UILabel()
    private lazy var weekStackView = UIStackView()
    private lazy var calendarCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    
    // MARK: - Func
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCollectionViewHeight()
    }
    
    override func setUI() {
        self.addSubviews(monthLabel, previousMonthButton, nextMonthButton, yearLabel, weekStackView, calendarCollectionView)
        
        let dayOfTheWeek = ["일", "월", "화", "수", "목", "금", "토"]
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
            $0.attributedText = .richStyle("", style: .custom(fontWeight: .semiBold, size: 26))
        }
        
        previousMonthButton.do {
            $0.setBackgroundImage(UIImage(systemName: "arrowtriangle.left.fill"), for: .normal)
            $0.tintColor = .black
            $0.accessibilityLabel = "이전 달"
        }
        
        nextMonthButton.do {
            $0.setBackgroundImage(UIImage(systemName: "arrowtriangle.right.fill"), for: .normal)
            $0.tintColor = .black
            $0.accessibilityLabel = "다음 달"
        }
        
        yearLabel.do {
            $0.attributedText = .richStyle("", style: .custom(fontWeight: .semiBold, size: 26))
            $0.textColor = .black
        }
        
        weekStackView.do {
            $0.distribution = .fillEqually
            $0.axis = .horizontal
        }
        
        calendarCollectionView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: CalendarCollectionViewCell.cellIdentifier)
            $0.backgroundColor = .clear
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
        
        yearLabel.snp.makeConstraints {
            $0.centerY.equalTo(monthLabel)
            $0.trailing.equalToSuperview().inset(30)
        }
        
        weekStackView.snp.makeConstraints {
            $0.top.equalTo(monthLabel.snp.bottom).offset(30)
            $0.horizontalEdges.equalToSuperview().inset(22)
        }
        
        calendarCollectionView.snp.makeConstraints {
            $0.top.equalTo(weekStackView.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(25)
            $0.bottom.equalToSuperview()
            
            self.calendarCollectionViewHeightConstraint = $0.height.equalTo(0).constraint
        }
    }
    
    func bind(to viewModel: CalendarViewModel) {
        previousMonthButton.rx.tap
            .bind(to: viewModel.input.previousMonthButtonTapped)
            .disposed(by: disposeBag)
        
        nextMonthButton.rx.tap
            .bind(to: viewModel.input.nextMonthButtonTapped)
            .disposed(by: disposeBag)
        
        calendarCollectionView.rx.itemSelected
            .compactMap { [weak self] indexPath -> Date? in
                guard let self = self,
                      let date = self.currentCalendarDayData.days[indexPath.item] else { return nil }
                return date
            }
            .bind(to: viewModel.input.dateCellTapped)
            .disposed(by: disposeBag)
        
        viewModel.output.currentMonthText
            .drive(onNext: { [weak self] monthString in
                self?.currentMonthText = monthString
                self?.monthLabel.attributedText = .richStyle(monthString, style: .custom(fontWeight: .semiBold, size: 26))
            })
            .disposed(by: disposeBag)
        
        viewModel.output.currentYearText
            .drive(onNext: { [weak self] yearString in
                self?.currentYearText = yearString
                self?.yearLabel.attributedText = .richStyle(yearString, style: .custom(fontWeight: .semiBold, size: 26))
            })
            .disposed(by: disposeBag)
        
        viewModel.output.calendarDayData
            .drive(onNext: { [weak self] calendarDayData in
                self?.currentCalendarDayData = calendarDayData
                self?.calendarCollectionView.reloadData()
                self?.updateCollectionViewHeight()
            })
            .disposed(by: disposeBag)
        
        viewModel.output.selectedDate
            .drive(onNext: { [weak self] date in
                self?.currentSelectedDate = date
                self?.calendarCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    func updateMonthLabel(_ monthText: String) {
        self.currentMonthText = monthText
    }
    
    func updateYearLabel(_ yearText: String) {
        self.currentYearText = yearText
    }
    
    
    // MARK: - Private Func
    
    private func updateCollectionViewHeight() {
        calendarCollectionView.layoutIfNeeded()
        let height = calendarCollectionView.collectionViewLayout.collectionViewContentSize.height
        calendarCollectionViewHeightConstraint?.update(offset: height)
    }
    
}


// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension CalendarView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentCalendarDayData.days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.cellIdentifier, for: indexPath) as? CalendarCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let calendar = Calendar.current
        let date = currentCalendarDayData.days[indexPath.item]
        var hasDiary = false
        var isFutureDate = false
        
        if let date = date {
            let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
            hasDiary = currentCalendarDayData.diaryDates.contains(dateComponents)
            
            if calendar.compare(date, to: Date(), toGranularity: .day) == .orderedDescending {
                isFutureDate = true
            }
        }
        
        cell.configure(date: date, selectedDate: self.currentSelectedDate, calendar: calendar, hasDiary: hasDiary, isFuture: isFutureDate)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right)
        let spacing: CGFloat = 3
        let totalSpacing = spacing * 6
        let cellWidth = floor((availableWidth - totalSpacing) / 7)
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
