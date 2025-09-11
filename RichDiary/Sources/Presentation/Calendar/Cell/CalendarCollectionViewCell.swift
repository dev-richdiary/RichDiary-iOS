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

    func configure(date: Date?, selectedDate: Date?, calendar: Calendar, hasDiary: Bool, isFuture: Bool) {
        guard let date = date else {
            dateLabel.text = ""
            contentView.backgroundColor = .clear
            return
        }
        
        let day = calendar.component(.day, from: date)
        dateLabel.text = "\(day)"
        
        if isFuture {
            dateLabel.textColor = .gray6
        } else {
            dateLabel.textColor = .gray12
        }
        
        // 기본 배경 (가계부 여부 반영)
        if hasDiary {
            contentView.backgroundColor = .primaryLight
            dateLabel.textColor = .white
            contentView.layer.cornerRadius = 8
        } else {
            contentView.backgroundColor = .clear
        }
        
        if let selectedDate = selectedDate, calendar.isDate(date, inSameDayAs: selectedDate) {
            contentView.backgroundColor = .gray11
            dateLabel.textColor = .white
            contentView.layer.cornerRadius = self.bounds.width / 2
            contentView.clipsToBounds = true
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if contentView.backgroundColor != .gray11 {
            contentView.clipsToBounds = false
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dateLabel.text = nil
        dateLabel.textColor = .gray12
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 0
        contentView.clipsToBounds = false
    }
}
