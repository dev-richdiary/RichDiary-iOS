//
//  DiaryTile.swift
//  RichDiary
//
//  Created by OneTen on 9/9/25.
//

import UIKit

import SnapKit
import Then

final class DiaryTile: BaseUIView {

    //MARK: - Properties

    var onTap: (() -> Void)?
    
    private var model: DiaryModel?
    
    
    //MARK: - UI Properties

    private let categoryImageContainerView = UIView()
    private let categoryImageView = UIImageView()
    private let descriptionLabel = UILabel()
    private let categoryLabel = UILabel()
    private let moneyLabel = UILabel()
    
    
    //MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setGesture()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Func

    override func setUI() {
        self.addSubviews(categoryImageContainerView, descriptionLabel, categoryLabel, moneyLabel)
        categoryImageContainerView.addSubview(categoryImageView)
    }
    
    override func setStyle() {
        categoryImageContainerView.do {
            $0.layer.cornerRadius = 20
            $0.clipsToBounds = true
        }

        categoryImageView.do {
            $0.contentMode = .scaleAspectFit
            $0.clipsToBounds = true
        }
        
        categoryLabel.do {
            $0.textColor = .gray
        }
        
        descriptionLabel.do {
            $0.textColor = .black
            $0.numberOfLines = 1
            $0.lineBreakMode = .byTruncatingTail
            $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        }

        moneyLabel.do {
            $0.textColor = .black
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        }

    }
    
    override func setLayout() {
        categoryImageContainerView.snp.makeConstraints {
            $0.size.equalTo(40)
            $0.left.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }

        categoryImageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(4)
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(categoryImageContainerView.snp.top).offset(2)
            $0.left.equalTo(categoryImageContainerView.snp.right).offset(12)
            $0.right.lessThanOrEqualTo(moneyLabel.snp.left).offset(-12)
        }

        categoryLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(4)
            $0.left.equalTo(descriptionLabel)
        }

        moneyLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(20)
        }
    }
    
    func configure(with model: DiaryModel) {
        self.model = model
        bindData()
    }
    
}


//MARK: - Private Func

extension DiaryTile {
    private func bindData() {
        guard let model = model else { return }
        
        if model.category == .salary {
            categoryImageView.image = UIImage(resource: .iconSaving)
        } else {
            categoryImageView.image = UIImage(named: "icon_\(model.category)") ?? UIImage(resource: .iconEtc)
        }
        
        if model.type == .C {
            categoryImageContainerView.backgroundColor = .primaryRed
        } else if model.type == .B {
            categoryImageContainerView.backgroundColor = .primaryOrange
        } else {
            categoryImageContainerView.backgroundColor = .primaryLight
        }
        
        descriptionLabel.attributedText =
            .richStyle(
                model.description,
                style: .custom(
                    fontWeight: .semiBold,
                    size: 16
                )
            )
        
        categoryLabel.attributedText =
            .richStyle(
                model.category.description,
                style: .custom(
                    fontWeight: .regular,
                    size: 14
                )
            )
        
        moneyLabel.attributedText =
            .richStyle(
                model.diaryType == .expense ? "- \(model.money.asCurrencyString)" : "+ \(model.money.asCurrencyString)",
                style: .custom(
                    fontWeight: .semiBold,
                    size: 16
                )
            )
        moneyLabel.textColor = (model.diaryType == .expense) ? .black : .primaryLight
    }
    
    private func setGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
    
    @objc private func didTap() {
        onTap?()
    }
}
