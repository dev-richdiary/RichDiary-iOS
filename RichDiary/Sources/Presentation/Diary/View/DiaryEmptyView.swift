//
//  DiaryEmptyView.swift
//  RichDiary
//
//  Created by OneTen on 9/15/25.
//

import UIKit

import SnapKit
import Then

final class DiaryEmptyView: BaseUIView {
    
    // MARK: - UI Components

    private let stackView = UIStackView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    
    // MARK: - override Func

    override func setUI() {
        self.addSubview(stackView)
        stackView.addArrangedSubviews(imageView, titleLabel, subtitleLabel)
    }
    
    override func setStyle() {
        stackView.do {
            $0.axis = .vertical
            $0.spacing = 12
            $0.alignment = .center
        }
        
        imageView.do {
            $0.image = UIImage(resource: .iconRichdiary)
            $0.contentMode = .scaleAspectFit
        }
        
        titleLabel.do {
            $0.attributedText = .richStyle("텅 비었어요", style: .custom(fontWeight: .bold, size: 20))
            $0.textColor = .gray11
        }
        
        subtitleLabel.do {
            $0.attributedText = .richStyle("오른쪽 아래의 + 버튼을 눌러\n첫 가계부를 작성해보세요!", style: .custom(fontWeight: .regular, size: 15))
            $0.textColor = .gray
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
    }
    
    override func setLayout() {
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(40)
        }
        
        imageView.snp.makeConstraints {
            $0.size.equalTo(250)
        }
    }
}
