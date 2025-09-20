//
//  CalendarHeaderView.swift
//  RichDiary
//
//  Created by OneTen on 9/10/25.
//

import UIKit

import SnapKit
import Then

final class CalendarHeaderView: BaseUIView {
    
    //MARK: - UI Properties
    
    private let titleLabel = UILabel()
    private(set) lazy var noticeButton = UIButton()
    private(set) lazy var helpButton = UIButton()
    
    
    //MARK: - Func
    
    override func setUI() {
        self.addSubviews(titleLabel, noticeButton, helpButton)
    }
    
    override func setStyle() {
        titleLabel.do {
            $0.attributedText = .richStyle("캘린더", style: .custom(fontWeight: .bold, size: 26))
            $0.textColor = .white
        }
        
        noticeButton.do {
            $0.setBackgroundImage(UIImage(systemName: "bell"), for: .normal)
            $0.tintColor = .white
            $0.accessibilityLabel = "알림"
        }

        helpButton.do {
            $0.setBackgroundImage(UIImage(systemName: "questionmark.circle"), for: .normal)
            $0.tintColor = .white
            $0.accessibilityLabel = "도움말"
        }
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(28)
            $0.centerY.equalToSuperview()
        }
        
        helpButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(28)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(28)
        }
        
//        noticeButton.snp.makeConstraints {
//            $0.trailing.equalTo(helpButton.snp.leading).offset(-14)
//            $0.centerY.equalToSuperview()
//            $0.size.equalTo(28)
//        }
    }
    
}
