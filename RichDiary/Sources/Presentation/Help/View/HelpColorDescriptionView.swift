//
//  HelpColorDescriptionView.swift
//  RichDiary
//
//  Created by OneTen on 9/18/25.
//

import UIKit

import SnapKit
import Then

final class HelpColorDescriptionView: BaseUIView {
    
    // MARK: - UI Components
    
    private let containerView = UIView()
    private let sectionTitleLabel = UILabel()
    private let categoryStackView = UIStackView()
    
    
    // MARK: - Override Func
    
    override func setUI() {
        self.addSubview(containerView)
        containerView.addSubviews(sectionTitleLabel, categoryStackView)
        
        categoryStackView.addArrangedSubviews(
            createColorItem(
                image: UIImage(resource: .iconFood),
                text: "A 식비",
                backgroundColor: .primaryLight
            ),
            createColorItem(
                image: UIImage(resource: .iconEtc),
                text: "B 카페/간식",
                backgroundColor: .primaryOrange
            ),
            createColorItem(
                image: UIImage(resource: .iconShopping),
                text: "C 패션/쇼핑",
                backgroundColor: .primaryRed
            )
        )
    }
    
    override func setStyle() {
        self.backgroundColor = .clear
        
        containerView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 12
            $0.clipsToBounds = true
        }
        
        sectionTitleLabel.do {
            $0.attributedText = .richStyle("가계부 작성이 완료된 소비는 다음과 같이 카테고리의 배경색으로 타입이 표시됩니다.", style: .custom(fontWeight: .semiBold, size: 16))
            $0.textColor = .black
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
        
        categoryStackView.do {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.spacing = 10
            $0.alignment = .center
            $0.backgroundColor = .gray9
            $0.layer.cornerRadius = 12
            $0.clipsToBounds = true
        }
        
    }
    
    override func setLayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        sectionTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        categoryStackView.snp.makeConstraints {
            $0.top.equalTo(sectionTitleLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(120)
        }
    }
    
    
    // MARK: - Private Func
    
    private func createColorItem(image: UIImage?, text: String, backgroundColor: UIColor) -> UIView {
           let itemContainer = UIStackView().then {
               $0.axis = .vertical
               $0.alignment = .center
               $0.spacing = 8
           }
           
           let imageViewContainer = UIView().then {
               $0.backgroundColor = backgroundColor
               $0.layer.cornerRadius = 30
               $0.clipsToBounds = true
           }
           
           let imageView = UIImageView().then {
               $0.image = image
               $0.contentMode = .scaleAspectFit
           }
           
           let textLabel = UILabel().then {
               $0.attributedText = .richStyle(text, style: .custom(fontWeight: .medium, size: 14))
               $0.textColor = .white
               $0.textAlignment = .center
           }
           
           imageViewContainer.addSubview(imageView)
           itemContainer.addArrangedSubviews(imageViewContainer, textLabel)
           
           imageViewContainer.snp.makeConstraints {
               $0.size.equalTo(60)
           }
           
           imageView.snp.makeConstraints {
               $0.edges.equalToSuperview().inset(12)
           }
           
           return itemContainer
       }
}
