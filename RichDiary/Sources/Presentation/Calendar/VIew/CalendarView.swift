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
    
    // MARK: - Properties
    
    let dayOfTheWeek = ["일", "월", "화", "수", "목", "금", "토"]
    let diaryList = DiaryModel.dummy()
    
    private var currentDate = Date() {
        didSet { reloadCalendar() }
    }
    private var days: [Date?] = []
    private var diaryDates: Set<DateComponents> = []
    private var selectedDate: Date?
    
    private let calendarManager = CalendarManager()
    private var calendarCollectionViewHeightConstraint: Constraint?
    
    private lazy var monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR") // Style enum 대신 직접 값 사용
        formatter.dateFormat = "M월"
        return formatter
    }()
    
    
    // MARK: - UI Components
    
    private let monthLabel = UILabel()
    private lazy var previousMonthButton = UIButton()
    private lazy var nextMonthButton = UIButton()
    private lazy var weekStackView = UIStackView()
    private lazy var calendarCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.selectedDate = self.currentDate
        prepareDiaryDates()
        reloadCalendar()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.selectedDate = self.currentDate
        prepareDiaryDates()
        reloadCalendar()
    }
    
    
    // MARK: - Func
    
    override func setUI() {
        self.addSubviews(monthLabel, previousMonthButton, nextMonthButton, weekStackView, calendarCollectionView)
        
        dayOfTheWeek.forEach {
            let label = UILabel()
            label.attributedText = .richStyle($0, style: .custom(fontWeight: .bold, size: 20))
            label.textAlignment = .center
            label.textColor = .gray12 // Style enum 대신 직접 값 사용
            self.weekStackView.addArrangedSubview(label)
        }
    }
    
    override func setStyle() {
        monthLabel.do {
            let monthString = monthFormatter.string(from: currentDate)
            $0.attributedText = .richStyle(monthString, style: .custom(fontWeight: .semiBold, size: 26))
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
    
    
    // MARK: - Private Func
    
    private func prepareDiaryDates() {
        let calendar = Calendar.current
        diaryDates = Set(diaryList.map { calendar.dateComponents([.year, .month, .day], from: $0.date) })
    }
    
    private func reloadCalendar() {
        let monthString = monthFormatter.string(from: currentDate)
        monthLabel.attributedText = .richStyle(monthString, style: .custom(fontWeight: .semiBold, size: 26))
        
        days = calendarManager.daysInMonth(for: currentDate)
        calendarCollectionView.reloadData()
        
        DispatchQueue.main.async {
            self.updateCollectionViewHeight()
        }
    }
    
    private func updateCollectionViewHeight() {
        let height = calendarCollectionView.collectionViewLayout.collectionViewContentSize.height
        calendarCollectionViewHeightConstraint?.update(offset: height)
    }
    
    @objc private func onTapPreviousMonth() {
        currentDate = calendarManager.previousMonth(from: currentDate)
    }
    
    @objc private func onTapNextMonth() {
        currentDate = calendarManager.nextMonth(from: currentDate)
    }
}


// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension CalendarView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.cellIdentifier, for: indexPath) as? CalendarCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let calendar = Calendar.current
        let date = days[indexPath.item]
        var hasDiary = false
        
        if let date = date {
            let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
            hasDiary = diaryDates.contains(dateComponents)
        }
        
        cell.configure(date: date, selectedDate: self.selectedDate, calendar: calendar, hasDiary: hasDiary)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedDay = days[indexPath.item] else { return }
        self.selectedDate = selectedDay
        self.calendarCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right)
        let cellWidth = (availableWidth / 7 - 4).rounded(.down)
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
