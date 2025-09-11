//
//  CalendarCollectionViewCell.swift
//  RichDiary
//
//  Created by OneTen on 9/10/25.
//

import UIKit

import SnapKit
import Then

final class CalendarCollectionViewCell: UICollectionViewCell {
    
    //MARK: - UI Properties

    private let dateLabel = UILabel()
    
    
    //MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setStyle()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Private Func
    
    private func setUI() {
        contentView.addSubviews(dateLabel)
    }
    
    private func setStyle() {
        dateLabel.do {
            $0.font = .richFont(.custom(fontWeight: .regular, size: 20))
            $0.textAlignment = .center
            $0.textColor = .gray12
        }
    }
    
    private func setLayout() {
        dateLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    
    //MARK: - Func

    func configure(date: Date?, selectedDate: Date?, calendar: Calendar, hasDiary: Bool) {
        guard let date = date else {
            dateLabel.text = ""
            contentView.backgroundColor = .clear
            return
        }
        
        let day = calendar.component(.day, from: date)
        dateLabel.text = "\(day)"
        
        // 요일별 색상
        let weekday = calendar.component(.weekday, from: date)
        
        if weekday == 1 {                       // 일요일
            dateLabel.textColor = .red
        } else if weekday == 7 {                // 토요일
            dateLabel.textColor = .blue
        } else {
            dateLabel.textColor = .gray12
        }
        
        // 기본 배경 (가계부 여부 반영)
        if hasDiary {
            contentView.backgroundColor = UIColor.systemTeal.withAlphaComponent(0.2)
            contentView.layer.cornerRadius = 8
        } else {
            contentView.backgroundColor = .clear
        }
        
        // 선택된 날짜 하이라이트
        if let selectedDate = selectedDate, calendar.isDate(date, inSameDayAs: selectedDate) {
            contentView.backgroundColor = .systemPink.withAlphaComponent(0.5)
            contentView.layer.cornerRadius = frame.width / 2
        }
    }
    
}
