//
//  CalendarView.swift
//  RichDiary
//
//  Created by OneTen on 9/10/25.
//

import UIKit

import SnapKit
import Then
import RealmSwift

final class CalendarView: BaseUIView {
    
    // MARK: - Properties
    
    var onDateSelected: ((Date?) -> Void)? {
        didSet {
            onDateSelected?(self.selectedDate)
        }
    }
    
    let dayOfTheWeek = ["일", "월", "화", "수", "목", "금", "토"]
    private var diaryList: Results<DiaryModel>?
    
    private var currentDate = Date() {
        didSet { reloadCalendar() }
    }
    private var days: [Date?] = []
    private var diaryDates: Set<DateComponents> = []
    
    var selectedDate: Date? {
        didSet {
            onDateSelected?(selectedDate)
            calendarCollectionView.reloadData()
        }
    }
    
    private let calendarManager = CalendarManager()
    private var calendarCollectionViewHeightConstraint: Constraint?
    
    private lazy var monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월"
        return formatter
    }()
    
    private lazy var yearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy"
        return formatter
    }()
    
    
    // MARK: - UI Components
    
    private let monthLabel = UILabel()
    private lazy var previousMonthButton = UIButton()
    private lazy var nextMonthButton = UIButton()
    private let yearLabel = UILabel()
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
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Func
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCollectionViewHeight()
    }
    
    override func setUI() {
        self.addSubviews(monthLabel, previousMonthButton, nextMonthButton, yearLabel, weekStackView, calendarCollectionView)
        
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
        
        yearLabel.do {
            let yearString = yearFormatter.string(from: currentDate)
            $0.attributedText = .richStyle(yearString, style: .custom(fontWeight: .semiBold, size: 26))
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
    
    func resetToToday() {
        let today = Date()
        
        // 선택된 날짜를 오늘로 변경
        self.selectedDate = today
        
        // 현재 달력이 오늘이 속한 달이 아니라면, 오늘이 속한 달로 변경
        if !Calendar.current.isDate(currentDate, inSameDayAs: today) {
            self.currentDate = today
        }
    }
    
    public func reloadData(with diaries: Results<DiaryModel>) {
        self.diaryList = diaries
        prepareDiaryDates()
        reloadCalendar()
    }
    
    // MARK: - Private Func
    
    private func prepareDiaryDates() {
        guard let diaryList = diaryList else {
            diaryDates = []
            return
        }
        
        let calendar = Calendar.current
        diaryDates = Set(diaryList.map { calendar.dateComponents([.year, .month, .day], from: $0.date) })
    }
    
    private func reloadCalendar() {
        let monthString = monthFormatter.string(from: currentDate)
        monthLabel.attributedText = .richStyle(monthString, style: .custom(fontWeight: .semiBold, size: 26))
        
        let yearString = yearFormatter.string(from: currentDate)
        yearLabel.attributedText = .richStyle(yearString, style: .custom(fontWeight: .semiBold, size: 26))
        
        days = calendarManager.daysInMonth(for: currentDate)
        calendarCollectionView.reloadData()
    }
    
    private func updateCollectionViewHeight() {
        let height = calendarCollectionView.collectionViewLayout.collectionViewContentSize.height
        calendarCollectionViewHeightConstraint?.update(offset: height)
    }
    
    @objc private func onTapPreviousMonth() {
        selectedDate = nil
        currentDate = calendarManager.previousMonth(from: currentDate)
    }
    
    @objc private func onTapNextMonth() {
        selectedDate = nil
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
        var isFutureDate = false
        
        if let date = date {
            let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
            hasDiary = diaryDates.contains(dateComponents)
            
            if calendar.compare(date, to: Date(), toGranularity: .day) == .orderedDescending {
                isFutureDate = true
            }
        }
        
        cell.configure(date: date, selectedDate: self.selectedDate, calendar: calendar, hasDiary: hasDiary, isFuture: isFutureDate)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedDay = days[indexPath.item] else { return }
        
        if Calendar.current.compare(selectedDay, to: Date(), toGranularity: .day) == .orderedDescending {
            return
        }
        
        self.selectedDate = selectedDay
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
