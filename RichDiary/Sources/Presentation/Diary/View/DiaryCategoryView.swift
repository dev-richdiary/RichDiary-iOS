//
//  DiaryCategoryView.swift
//  RichDiary
//
//  Created by OneTen on 9/12/25.
//

import UIKit

import SnapKit
import Then

final class DiaryCategoryView: BaseUIView {

    // MARK: - Properties

    public var selectedCategory: DiaryCategoryType?
    
    private let categories = DiaryCategoryType.allCases
    

    // MARK: - UI Components
    
    private let categoryLabel = UILabel()
    private lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()

    
    // MARK: - override Func
    
    override func setUI() {
        self.addSubviews(categoryLabel, categoryCollectionView)
    }

    override func setStyle() {
        categoryLabel.do {
            $0.attributedText = .richStyle("카테고리", style: .custom(fontWeight: .bold, size: 16))
        }
        
        categoryCollectionView.do {
            $0.backgroundColor = .clear
            $0.showsHorizontalScrollIndicator = false
            $0.delegate = self
            $0.dataSource = self
            $0.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.cellIdentifier)
        }
    }

    override func setLayout() {
        categoryLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        categoryCollectionView.snp.makeConstraints {
            $0.top.equalTo(categoryLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
            $0.bottom.equalToSuperview()
        }
    }
}


// MARK: - UICollectionView Delegate & DataSource

extension DiaryCategoryView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.cellIdentifier, for: indexPath) as? CategoryCell else {
            return UICollectionViewCell()
        }
        let category = categories[indexPath.item]
        cell.configure(with: category.description, isSelected: category == selectedCategory)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.item]
        collectionView.reloadData()
    }
}
