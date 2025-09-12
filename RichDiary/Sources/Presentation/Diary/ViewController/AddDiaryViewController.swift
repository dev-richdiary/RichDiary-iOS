//
//  AddDiaryViewController.swift
//  RichDiary
//
//  Created by OneTen on 9/12/25.
//

import UIKit

import SnapKit
import Then

final class AddDiaryViewController: BaseUIViewController {
    
    // MARK: - Properties
    
    private let categories = DiaryCategoryType.allCases
    private let expenseTypes = ExpenseType.allCases
    private let paymentTypes = PaymentType.allCases
    
    private var selectedCategory: DiaryCategoryType?
    
    private lazy var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    // MARK: - UI Components
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // 지출 & 수입
    private let diaryTypeSegmentedControl = UISegmentedControl(items: ["지출", "수입"])
    
    // 날짜
    private let dateLabel = UILabel()
    private let dateTextField = UITextField()
    private let datePicker = UIDatePicker()
    
    // 가격
    private let amountLabel = UILabel()
    private let amountTextField = UITextField()
    
    // 설명
    private let descriptionLabel = UILabel()
    private let descriptionTextField = UITextField()
    
    // 카테고리
    private let categoryLabel = UILabel()
    private lazy var categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())

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

    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setDatePicker()
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
                dateLabel,
                dateTextField,
                amountLabel,
                amountTextField,
                descriptionLabel,
                descriptionTextField,
                categoryLabel,
                categoryCollectionView,
                paymentLabel,
                paymentSegmentedControl,
                expenseFieldsStackView,
                memoLabel,
                memoTextView
            )
    }
    
    override func setStyle() {
        view.backgroundColor = .white
        
        diaryTypeSegmentedControl.do {
            $0.selectedSegmentIndex = 0
            $0.backgroundColor = .gray.withAlphaComponent(0.1)
            $0.addTarget(self, action: #selector(diaryTypeDidChange), for: .valueChanged)
        }
        
        dateLabel.do {
            $0.attributedText = .richStyle("날짜", style: .custom(fontWeight: .bold, size: 16))
        }
        
        dateTextField.do {
            $0.borderStyle = .roundedRect
            $0.textAlignment = .center
        }
        
        amountLabel.do {
            $0.attributedText = .richStyle("금액", style: .custom(fontWeight: .bold, size: 16))
        }
        
        amountTextField.do {
            $0.borderStyle = .roundedRect
            $0.keyboardType = .numberPad
            $0.placeholder = "금액을 입력하세요"
            $0.delegate = self
        }
        
        descriptionLabel.do {
            $0.attributedText = .richStyle("내용", style: .custom(fontWeight: .bold, size: 16))
        }
        
        descriptionTextField.do {
            $0.borderStyle = .roundedRect
            $0.placeholder = "내용을 입력하세요"
        }
        
        categoryLabel.do {
            $0.attributedText = .richStyle("카테고리", style: .custom(fontWeight: .bold, size: 16))
        }
        
        categoryCollectionView.do {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            layout.minimumInteritemSpacing = 10
            
            $0.collectionViewLayout = layout
            $0.backgroundColor = .clear
            $0.showsHorizontalScrollIndicator = false
            $0.delegate = self
            $0.dataSource = self
            $0.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.cellIdentifier)
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
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(diaryTypeSegmentedControl.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(20)
        }
        
        dateTextField.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(44)
        }
        
        amountLabel.snp.makeConstraints {
            $0.top.equalTo(dateTextField.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        amountTextField.snp.makeConstraints {
            $0.top.equalTo(amountLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(44)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(amountTextField.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        descriptionTextField.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(44)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionTextField.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        categoryCollectionView.snp.makeConstraints {
            $0.top.equalTo(categoryLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(44)
        }
        
        paymentLabel.snp.makeConstraints {
            $0.top.equalTo(categoryCollectionView.snp.bottom).offset(20)
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
            $0.bottom.equalToSuperview().inset(20)
        }
    }
}


// MARK: - Func

extension AddDiaryViewController {
    func setNavigationBar() {
        self.title = "가계부 작성"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(didTapCancelButton))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .done, target: self, action: #selector(didTapSaveButton))
    }
    
    func setDatePicker() {
        datePicker.do {
            $0.datePickerMode = .date
            $0.preferredDatePickerStyle = .wheels
            $0.locale = Locale(identifier: "ko_KR")
        }
        
        // DatePicker 위에 툴바 추가 (선택 완료 버튼)
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(didTapDoneOnDatePicker))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexSpace, doneButton], animated: true)
        
        dateTextField.do {
            $0.inputView = datePicker   // 텍스트 필드를 탭하면 키보드 대신 DatePicker가 나오도록 설정
            $0.inputAccessoryView = toolbar
            $0.text = formatDate(date: Date())
        }
    }
    
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
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
        // 키보드 정보를 가져옴
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        // 키보드 높이만큼 스크롤뷰의 하단에 여백(inset)을 추가
        let contentInset = UIEdgeInsets(
            top: 0.0,
            left: 0.0,
            bottom: keyboardFrame.size.height,
            right: 0.0)
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        // 키보드가 사라지면 여백을 다시 0으로 설정
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
}


// MARK: - Button Action

extension AddDiaryViewController {
    @objc func didTapCancelButton() {
        self.dismiss(animated: true)
    }
    
    @objc func didTapSaveButton() {
        let diaryType: DiaryType = diaryTypeSegmentedControl.selectedSegmentIndex == 0 ? .expense : .income
        let date = datePicker.date
        let money = Int(amountTextField.text ?? "0") ?? 0
        let description = descriptionTextField.text ?? ""
        let category = selectedCategory ?? .etc
        let payment = paymentTypes[paymentSegmentedControl.selectedSegmentIndex]
        let memo = (memoTextView.text == "메모를 입력하세요 (선택)") ? "" : memoTextView.text ?? ""
        let expenseType: ExpenseType = (diaryType == .expense) ? expenseTypes[expenseTypeSegmentedControl.selectedSegmentIndex] : .A
        
        let newDiary = DiaryModel(date: date,
                                  money: money,
                                  category: category,
                                  payment: payment,
                                  description: description,
                                  memo: memo,
                                  type: expenseType,
                                  diaryType: diaryType)
        
        // TODO: - 로컬 DB에 저장 로직 추가
        print("저장될 모델: \(newDiary)")
        
        self.dismiss(animated: true)
    }
    
    @objc func didTapDoneOnDatePicker() {
        dateTextField.text = formatDate(date: datePicker.date)
        dateTextField.resignFirstResponder()
    }
    
    @objc func diaryTypeDidChange(_ sender: UISegmentedControl) {
        let isExpense = sender.selectedSegmentIndex == 0
        self.expenseFieldsStackView.isHidden = !isExpense
        self.view.layoutIfNeeded()
    }
}


// MARK: - UICollectionView Delegate & DataSource

extension AddDiaryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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


// MARK: - UITextView Delegate

extension AddDiaryViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "메모를 입력하세요 (선택)" {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "메모를 입력하세요 (선택)"
            textView.textColor = .lightGray
        }
    }
}


// MARK: - UITextField Delegate

extension AddDiaryViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == amountTextField {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            let numberString = updatedText.replacingOccurrences(of: ",", with: "")
            
            if numberString.isEmpty {
                textField.text = ""
                return false
            }
            
            guard let number = Int(numberString) else {
                return false
            }
            
            let formattedString = numberFormatter.string(from: NSNumber(value: number))
            
            textField.text = formattedString
            
            return false
        }
        
        return true
    }
}
