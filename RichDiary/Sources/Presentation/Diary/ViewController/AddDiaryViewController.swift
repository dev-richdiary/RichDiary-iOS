//
//  AddDiaryViewController.swift
//  RichDiary
//
//  Created by OneTen on 9/12/25.
//

import UIKit

import SnapKit
import Then
import RealmSwift

final class AddDiaryViewController: BaseUIViewController {
    
    // MARK: - Properties
    
    private let expenseTypes = ExpenseType.allCases
    private let paymentTypes = PaymentType.allCases
    
    
    // MARK: - UI Components
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // 키보드 높이 대응을 위한 뷰
    private var activeField: UIView?
    
    // 지출 & 수입
    private let diaryTypeSegmentedControl = UISegmentedControl(items: ["지출", "수입"])
    
    // 날짜
    private let datePickerView = DiaryDatePickerView()
    
    // 금액, 설명
    private let diaryTextFieldView = DiaryTextFieldView()
    
    // 카테고리
    private let categorySelectView = DiaryCategoryView()
    
    // 결제 수단
    private let paymentLabel = UILabel()
    private lazy var paymentSegmentedControl = UISegmentedControl(items: self.paymentTypes.map { $0.description })
    
    // 지출유형 A,B,C
    private let expenseTypeLabel = UILabel()
    private lazy var expenseTypeSegmentedControl = UISegmentedControl(items: self.expenseTypes.map { $0.description })
    private lazy var expenseFieldsStackView = UIStackView(arrangedSubviews: [expenseTypeLabel, expenseTypeSegmentedControl])
    
    // 메모
    private let memoLabel = UILabel()
    private let memoTextView = UITextView()
    private let memoCountLabel = UILabel()
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setKeyboardObserver()
    }
    
    deinit {
        removeKeyboardObserver()
    }
    
    // MARK: - override Func
    
    override func setUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(
            diaryTypeSegmentedControl,
            datePickerView,
            diaryTextFieldView,
            categorySelectView,
            paymentLabel,
            paymentSegmentedControl,
            expenseFieldsStackView,
            memoLabel,
            memoTextView,
            memoCountLabel
        )
    }
    
    override func setStyle() {
        view.backgroundColor = .white
        
        scrollView.keyboardDismissMode = .onDrag
        
        diaryTypeSegmentedControl.do {
            $0.selectedSegmentIndex = 0
            $0.backgroundColor = .gray.withAlphaComponent(0.1)
            $0.addTarget(self, action: #selector(diaryTypeDidChange), for: .valueChanged)
        }
        
        paymentLabel.do {
            $0.attributedText = .richStyle("결제 수단", style: .custom(fontWeight: .bold, size: 16))
        }
        
        paymentSegmentedControl.do {
            $0.selectedSegmentIndex = 0
        }
        
        expenseFieldsStackView.do {
            $0.axis = .vertical
            $0.spacing = 10
            $0.alignment = .fill
        }
        
        expenseTypeLabel.do {
            $0.attributedText = .richStyle("지출 유형", style: .custom(fontWeight: .bold, size: 16))
        }
        
        expenseTypeSegmentedControl.do {
            $0.selectedSegmentIndex = 0
        }
        
        memoLabel.do {
            $0.attributedText = .richStyle("메모", style: .custom(fontWeight: .bold, size: 16))
        }
        
        memoTextView.do {
            $0.attributedText = .richStyle("메모를 입력하세요 (선택)", style: .custom(fontWeight: .regular, size: 14))
            $0.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 5
            $0.textColor = .lightGray
            $0.delegate = self
        }
        
        memoCountLabel.do {
            $0.attributedText = .richStyle("(0/400)", style: .custom(fontWeight: .regular, size: 12))
            $0.textColor = .lightGray
            $0.textAlignment = .right
        }
    }
    
    override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        diaryTypeSegmentedControl.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        
        datePickerView.snp.makeConstraints {
            $0.top.equalTo(diaryTypeSegmentedControl.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        diaryTextFieldView.snp.makeConstraints {
            $0.top.equalTo(datePickerView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        categorySelectView.snp.makeConstraints {
            $0.top.equalTo(diaryTextFieldView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        paymentLabel.snp.makeConstraints {
            $0.top.equalTo(categorySelectView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        paymentSegmentedControl.snp.makeConstraints {
            $0.top.equalTo(paymentLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        expenseFieldsStackView.snp.makeConstraints {
            $0.top.equalTo(paymentSegmentedControl.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        memoLabel.snp.makeConstraints {
            $0.top.equalTo(expenseFieldsStackView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        memoTextView.snp.makeConstraints {
            $0.top.equalTo(memoLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(100)
        }
        
        memoCountLabel.snp.makeConstraints {
            $0.top.equalTo(memoTextView.snp.bottom).offset(4)
            $0.trailing.equalTo(memoTextView.snp.trailing)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
    func setNavigationBar() {
        self.title = "가계부 작성"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(didTapCancelButton))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .done, target: self, action: #selector(didTapSaveButton))
    }
}


// MARK: - Button Action

extension AddDiaryViewController {
    private func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        self.present(alert, animated: true)
    }
    
    @objc func didTapCancelButton() {
        self.dismiss(animated: true)
    }
    
    @objc func didTapSaveButton() {
        let money = diaryTextFieldView.amount
        let description = diaryTextFieldView.diaryDescription
        
        // 금액이 0원일 경우 입력 방지 메세지
        if money == 0 {
            presentAlert(title: "알림", message: "금액을 입력해주세요.")
            return
        }
        
        // 내용이 비어있을 경우 입력 방지 메세지
        if description.isEmpty {
            presentAlert(title: "알림", message: "내용을 입력해주세요.")
            return
        }
        
        let diaryType: DiaryType = diaryTypeSegmentedControl.selectedSegmentIndex == 0 ? .expense : .income
        let date = datePickerView.date
        let category = categorySelectView.selectedCategory ?? .etc
        let payment = paymentTypes[paymentSegmentedControl.selectedSegmentIndex]
        let memo = (memoTextView.text == "메모를 입력하세요 (선택)") ? "" : memoTextView.text ?? ""
        let expenseType: ExpenseType = (diaryType == .expense) ? expenseTypes[expenseTypeSegmentedControl.selectedSegmentIndex] : .A
        
        let newDiary = DiaryModel(date: date, money: money, category: category, payment: payment,
                                  description: description, memo: memo, type: expenseType, diaryType: diaryType)
        
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(newDiary)
                print("Realm에 데이터 저장 성공")
            }
        } catch {
            print("Realm 저장 중 에러 발생: \(error)")
        }
        
        self.dismiss(animated: true)
    }
    
    @objc func diaryTypeDidChange(_ sender: UISegmentedControl) {
        let isExpense = sender.selectedSegmentIndex == 0
        self.expenseFieldsStackView.isHidden = !isExpense
        self.view.layoutIfNeeded()
    }
}


// MARK: - Keyboard Setting

extension AddDiaryViewController {
    private func setKeyboardObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        // 키보드 정보
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        // 키보드 높이만큼 스크롤뷰의 하단에 여백 추가
        let contentInset = UIEdgeInsets(
            top: 0.0,
            left: 0.0,
            bottom: keyboardFrame.size.height,
            right: 0.0)
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
        
        if let activeField = self.activeField {
            scrollView.scrollRectToVisible(activeField.frame, animated: true)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        // 키보드가 사라지면 여백을 다시 0으로 설정
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
}


// MARK: - UITextView Delegate

extension AddDiaryViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.activeField = textView
        
        if textView.text == "메모를 입력하세요 (선택)" {
            textView.text = ""
            textView.textColor = .black
            
            textViewDidChange(textView)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.activeField = nil
        
        if textView.text.isEmpty {
            textView.text = "메모를 입력하세요 (선택)"
            textView.textColor = .lightGray
            
            textViewDidChange(textView)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let currentCount = textView.text.count
        let maxLength = 400
        memoCountLabel.text = "(\(currentCount)/\(maxLength))"
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let newText = currentText.replacingCharacters(in: stringRange, with: text)
        
        // 400자 제한
        return newText.count <= 400
    }
}
