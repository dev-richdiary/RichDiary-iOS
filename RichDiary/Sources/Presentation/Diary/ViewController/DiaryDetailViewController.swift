//
//  DiaryDetailViewController.swift
//  RichDiary
//
//  Created by OneTen on 9/9/25.
//

import UIKit

import SnapKit
import Then
import RealmSwift

final class DiaryDetailViewController: BaseUIViewController {
    
    //MARK: - Properties

    private let diaryId: ObjectId
    
    private var currentDiary: DiaryModel?
    
    
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

    init(diaryId: ObjectId) {
        self.diaryId = diaryId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setGesture()
        loadDiaryAndConfigureUI()
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
        
        dismissButton.do {
            $0.setTitle("✕ 닫기", for: .normal)
            $0.setTitleColor(.gray12, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
            $0.backgroundColor = .clear
            $0.configuration = .plain()
            $0.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
        }
        
        separatorView.do {
            $0.backgroundColor = .gray
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
            $0.trailing.lessThanOrEqualTo(dismissButton.snp.leading).offset(-12)
        }

        typeDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(typeLabel.snp.bottom)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        dismissButton.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).inset(10)
            $0.trailing.equalTo(contentView.snp.trailing).inset(10)
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
    
    private func loadDiaryAndConfigureUI() {
        do {
            let realm = try Realm()
            
            guard let diary = realm.object(ofType: DiaryModel.self, forPrimaryKey: self.diaryId) else {
                print("ID(\(self.diaryId)) 가계부 로드 에러")
                
                let alert = UIAlertController(title: "알림", message: "해당 일기가 삭제되었거나 찾을 수 없습니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default) { [weak self] _ in
                    self?.dismiss(animated: true)
                })
                self.present(alert, animated: true, completion: nil)
                return
            }
            self.currentDiary = diary
            
            typeLabel.attributedText = .richStyle(diary.type.rawValue, style: .custom(fontWeight: .bold, size: 80))
            typeLabel.textColor = diary.type == .C ? .red : .gray12
            
            typeDescriptionLabel.attributedText = .richStyle("\(diary.type.description) 지출", style: .custom(fontWeight: .regular, size: 20))
            typeDescriptionLabel.textColor = .gray
            
            moneyLabel.attributedText = .richStyle("금액 : \(diary.money.asCurrencyString)", style: .custom(fontWeight: .medium, size: 25))
            moneyLabel.textColor = .gray12
            
            dateLabel.attributedText = .richStyle("날짜 : \(diary.date.formattedWithWeekday())", style: .custom(fontWeight: .regular, size: 21))
            dateLabel.textColor = .gray12
            
            categoryLabel.attributedText = .richStyle("카테고리 : \(diary.category.description)", style: .custom(fontWeight: .regular, size: 21))
            categoryLabel.textColor = .gray12
            
            paymentLabel.attributedText = .richStyle("결제수단 : \(diary.payment.description)", style: .custom(fontWeight: .regular, size: 21))
            paymentLabel.textColor = .gray12
            
            descriptionLabel.attributedText = .richStyle("설명 : \(diary.diaryDescription)", style: .custom(fontWeight: .regular, size: 21))
            descriptionLabel.textColor = .gray12
            descriptionLabel.numberOfLines = 0
            descriptionLabel.lineBreakMode = .byWordWrapping
            
            memoLabel.attributedText = .richStyle("메모 : \(diary.memo)", style: .custom(fontWeight: .regular, size: 18))
            memoLabel.textColor = .gray12
            memoLabel.numberOfLines = 0
            memoLabel.lineBreakMode = .byWordWrapping
            
        } catch {
            print("Realm 데이터 로딩 중 에러 발생: \(error)")
            
            let alert = UIAlertController(title: "오류", message: "데이터 로딩 중 문제가 발생했습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default) { [weak self] _ in
                self?.dismiss(animated: true)
            })
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc private func deleteButtonTapped() {
        print("삭제하기 버튼 탭")
        
        let idToDelete = self.diaryId
        
        let alert = UIAlertController(title: "가계부 삭제", message: "정말로 삭제하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            
            dismissSelf()

            do {
                let realm = try Realm()
                
                if let objectToDelete = realm.object(ofType: DiaryModel.self, forPrimaryKey: idToDelete) {
                    try realm.write {
                        realm.delete(objectToDelete)
                        print("Realm에서 가계부 삭제 성공 (ID: \(idToDelete))")
                    }
                } else {
                    print("삭제할 가계부를 찾을 수 없습니다. (ID: \(idToDelete)) 이미 삭제되었을 수 있습니다.")
                }
            } catch {
                print("Realm 삭제 중 에러 발생: \(error)")
            }

        })
        self.present(alert, animated: true, completion: nil)
    }

    @objc private func editButtonTapped() {
        print("수정하기 버튼 탭")
        
        guard let diaryToEdit = currentDiary, !diaryToEdit.isInvalidated else {
            print("수정할 일기 객체가 유효하지 않습니다.")
            
            let alert = UIAlertController(title: "알림", message: "가계부 정보를 찾을 수 없습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // TODO: - 가계부 수정 로직 -> 수정화면 이동
    }
}
