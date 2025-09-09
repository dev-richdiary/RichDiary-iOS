//
//  DiaryDetailViewController.swift
//  RichDiary
//
//  Created by OneTen on 9/9/25.
//

import UIKit

import SnapKit
import Then

final class DiaryDetailViewController: BaseUIViewController {
    
    //MARK: - Properties

    private let diary: DiaryModel
    
    
    // MARK: - UI Components

    private let backgroundView = UIView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let typeLabel = UILabel()
    private let typeDescriptionLabel = UILabel()
    private let moneyLabel = UILabel()
    private let separatorView = UIView()
    private let dateLabel = UILabel()
    private let categoryLabel = UILabel()
    private let paymentLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let memoLabel = UILabel()
    private lazy var deleteButton = UIButton()
    private lazy var editButton = UIButton()
    private lazy var dismissButton = UIButton()
    
    
    // MARK: - init

    init(diary: DiaryModel) {
        self.diary = diary
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setGesture()
    }
    
    
    //MARK: - Func
    
    override func setUI() {
        self.view.addSubviews(backgroundView, scrollView, deleteButton, editButton)
        scrollView.addSubviews(contentView)
        contentView.addSubviews(typeLabel, dismissButton, typeDescriptionLabel, moneyLabel, separatorView, dateLabel, categoryLabel, paymentLabel, descriptionLabel, memoLabel)
    }
    
    override func setStyle() {
        self.view.backgroundColor = .gray12.withAlphaComponent(0.3)
        
        scrollView.do {
            $0.showsVerticalScrollIndicator = false
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 20
        }
        
        typeLabel.do {
            $0.attributedText = .richStyle(diary.type.type, style: .custom(fontWeight: .bold, size: 80))
            $0.textColor = diary.type == .C ? .red : .gray12
        }

        typeDescriptionLabel.do {
            $0.attributedText = .richStyle("\(diary.type.description) 지출", style: .custom(fontWeight: .regular, size: 20))
            $0.textColor = .gray
        }
        
        dismissButton.do {
            $0.setTitle("✕ 닫기", for: .normal)
            $0.setTitleColor(.gray12, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
            $0.backgroundColor = .clear
            $0.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
        }

        moneyLabel.do {
            $0.attributedText = .richStyle("금액 : \(diary.money.asCurrencyString)", style: .custom(fontWeight: .medium, size: 25))
            $0.textColor = .gray12
        }

        separatorView.do {
            $0.backgroundColor = .gray
        }

        dateLabel.do {
            $0.attributedText = .richStyle("날짜 : \(diary.date.formattedWithWeekday())", style: .custom(fontWeight: .regular, size: 21))
            $0.textColor = .gray12
        }

        categoryLabel.do {
            $0.attributedText = .richStyle("카테고리 : \(diary.category.description)", style: .custom(fontWeight: .regular, size: 21))
            $0.textColor = .gray12
        }

        paymentLabel.do {
            $0.attributedText = .richStyle("결제수단 : \(diary.payment.description)", style: .custom(fontWeight: .regular, size: 21))
            $0.textColor = .gray12
        }

        descriptionLabel.do {
            $0.attributedText = .richStyle("설명 : \(diary.description)", style: .custom(fontWeight: .regular, size: 18))
            $0.textColor = .gray12
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
        }

        memoLabel.do {
            $0.attributedText = .richStyle("메모 : \(diary.memo)", style: .custom(fontWeight: .regular, size: 18))
            $0.textColor = .gray12
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
        }
        
        deleteButton.do {
            $0.setTitle("삭제하기", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
            $0.backgroundColor = .primaryRed
            $0.layer.cornerRadius = 12
            $0.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        }

        editButton.do {
            $0.setTitle("수정하기", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .gray11
            $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
            $0.layer.cornerRadius = 12
            $0.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        }
    }
    
    override func setLayout() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        scrollView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-40)
            $0.width.equalToSuperview().inset(30)
            $0.height.equalToSuperview().inset(130)
        }

        contentView.snp.makeConstraints {
            $0.top.equalTo(scrollView.contentLayoutGuide.snp.top)
            $0.leading.equalTo(scrollView.contentLayoutGuide.snp.leading)
            $0.trailing.equalTo(scrollView.contentLayoutGuide.snp.trailing)
            $0.bottom.equalTo(scrollView.contentLayoutGuide.snp.bottom)
            $0.width.equalTo(scrollView.frameLayoutGuide.snp.width)
        }

        typeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(20)
        }

        typeDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(typeLabel.snp.bottom)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        dismissButton.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).inset(10)
            $0.trailing.equalTo(contentView.snp.trailing).inset(20)
            $0.size.equalTo(48)
        }

        moneyLabel.snp.makeConstraints {
            $0.top.equalTo(typeDescriptionLabel.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(20)
        }

        separatorView.snp.makeConstraints {
            $0.top.equalTo(moneyLabel.snp.bottom).offset(10)
            $0.width.equalToSuperview().multipliedBy(0.9)
            $0.height.equalTo(1)
            $0.centerX.equalToSuperview()
        }

        dateLabel.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(20)
        }

        categoryLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(15)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(20)
        }

        paymentLabel.snp.makeConstraints {
            $0.top.equalTo(categoryLabel.snp.bottom).offset(15)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(20)
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(paymentLabel.snp.bottom).offset(15)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(20)
        }

        memoLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(15)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.lessThanOrEqualTo(contentView.snp.bottom).inset(20)
        }
        
        deleteButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
            $0.height.equalTo(50)
            $0.width.equalTo(editButton.snp.width)
        }

        editButton.snp.makeConstraints {
            $0.leading.equalTo(deleteButton.snp.trailing).offset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(deleteButton.snp.bottom)
            $0.height.equalTo(deleteButton.snp.height)
        }
    }
}


//MARK: - Private Func

extension DiaryDetailViewController {
    private func setGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissSelf))
        backgroundView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: false)
    }
    
    @objc private func deleteButtonTapped() {
        // 삭제 기능 구현 예정
        print("삭제하기 버튼 탭")
    }

    @objc private func editButtonTapped() {
        // 수정 화면 전환 기능 구현 예정
        print("수정하기 버튼 탭")
    }
}

#Preview {
    DiaryDetailViewController(diary: DiaryModel.dummy().first!)
}
