//
//  HelpTypeDescriptionView.swift
//  RichDiary
//
//  Created by OneTen on 9/18/25.
//

import UIKit

import SnapKit
import Then

final class HelpTypeDescriptionView: BaseUIView {
    
    // MARK: - UI Components
    
    private let headerView = UIView()
    private let typeLabel = UILabel()
    private let descriptionLabel = UILabel()
    

    // MARK: - Override Func
    
    override func setUI() {
        self.addSubviews(headerView, descriptionLabel)
        headerView.addSubview(typeLabel)
    }
    
    override func setStyle() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        
        headerView.do {
            $0.layer.cornerRadius = 12
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            $0.clipsToBounds = true
        }
        
        typeLabel.do {
            $0.textColor = .white
            $0.textAlignment = .left
        }
        
        descriptionLabel.do {
            $0.textColor = .black
            $0.numberOfLines = 0
            $0.textAlignment = .left
        }
    }
    
    override func setLayout() {
        headerView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(56)
        }
        
        typeLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
    
    // MARK: - Public Methods
    
    func configure(type: String, title: String, description: String, backgroundColor: UIColor) {
        headerView.backgroundColor = backgroundColor
        typeLabel.attributedText = .richStyle("\(type) - \(title)", style: .custom(fontWeight: .bold, size: 22))
        descriptionLabel.attributedText = .richStyle(description, style: .custom(fontWeight: .regular, size: 16))
    }
}
