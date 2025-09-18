//
//  HomeHeaderView.swift
//  RichDiary
//
//  Created by OneTen on 9/7/25.
//

import UIKit

import SnapKit
import Then

final class HomeHeaderView: BaseUIView {
    
    //MARK: - Properties
    
    var onTapNoticeButton: (() -> Void)?
    var onTapHelpButton: (() -> Void)?
    
    
    //MARK: - UI Properties
    
    private let titleLabel = UILabel()
    private lazy var noticeButton = UIButton()
    private lazy var helpButton = UIButton()
    
    
    //MARK: - Func
    
    override func setUI() {
        self.addSubviews(titleLabel, noticeButton, helpButton)
    }
    
    override func setStyle() {
        titleLabel.do {
            $0.attributedText = .richStyle("부자 가계부", style: .custom(fontWeight: .bold, size: 26))
            $0.textColor = .white
        }
        
        noticeButton.do {
            $0.setBackgroundImage(UIImage(systemName: "bell"), for: .normal)
            $0.tintColor = .white
            $0.addTarget(self, action: #selector(noticeButtonTapped), for: .touchUpInside)
            $0.accessibilityLabel = "알림"
        }

        helpButton.do {
            $0.setBackgroundImage(UIImage(systemName: "questionmark.circle"), for: .normal)
            $0.tintColor = .white
            $0.addTarget(self, action: #selector(helpButtonTapped), for: .touchUpInside)
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
        
        noticeButton.snp.makeConstraints {
            $0.trailing.equalTo(helpButton.snp.leading).offset(-14)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(28)
        }
    }
    

    //MARK: - Private Func

    @objc private func noticeButtonTapped() {
        print("알림 버튼 클릭")
        onTapNoticeButton?()
    }
    
    @objc private func helpButtonTapped() {
        print("도움말 버튼 클릭")
        onTapHelpButton?()
    }
    
}
