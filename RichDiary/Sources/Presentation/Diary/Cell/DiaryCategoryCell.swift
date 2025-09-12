//
//  DiaryCategoryCell.swift
//  RichDiary
//
//  Created by OneTen on 9/12/25.
//

import UIKit

import SnapKit
import Then

final class CategoryCell: UICollectionViewCell {
    
    // MARK: - UI Components

    private let label = UILabel()
    
    
    // MARK: - Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(label)
        contentView.layer.cornerRadius = 15
        contentView.layer.borderWidth = 1
        
        label.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Func

    func configure(with category: String, isSelected: Bool) {
        label.attributedText = .richStyle(category, style: .custom(fontWeight: .medium, size: 14))
        
        if isSelected {
            contentView.backgroundColor = .gray11
            label.textColor = .white
            contentView.layer.borderColor = UIColor.gray11.cgColor
        } else {
            contentView.backgroundColor = .white
            label.textColor = .gray11
            contentView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
}
