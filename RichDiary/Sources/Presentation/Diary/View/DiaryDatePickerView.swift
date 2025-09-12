//
//  DiaryDatePickerView.swift
//  RichDiary
//
//  Created by OneTen on 9/12/25.
//

import UIKit

import SnapKit
import Then

final class DiaryDatePickerView: BaseUIView {
    
    // MARK: - Properties

    public var date: Date = Date() {
        didSet {
            dateTextField.text = formatDate(date: date)
        }
    }

    
    // MARK: - UI Components

    private let dateLabel = UILabel()
    private let dateTextField = UITextField()
    private let datePicker = UIDatePicker()
    
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDatePicker()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - override Func

    override func setUI() {
        self.addSubviews(dateLabel, dateTextField)
    }
    
    override func setStyle() {
        dateLabel.do {
            $0.attributedText = .richStyle("날짜", style: .custom(fontWeight: .bold, size: 16))
        }
        
        dateTextField.do {
            $0.borderStyle = .roundedRect
            $0.textAlignment = .center
            $0.delegate = self
            $0.tintColor = .clear
        }
    }
    
    override func setLayout() {
        dateLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        dateTextField.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
            $0.bottom.equalToSuperview()
        }
    }
}


// MARK: - Private Func

extension DiaryDatePickerView {
    private func setupDatePicker() {
        datePicker.do {
            $0.datePickerMode = .date
            $0.preferredDatePickerStyle = .wheels
            $0.locale = Locale(identifier: "ko_KR")
            $0.maximumDate = Date()
            $0.addTarget(self, action: #selector(datePickerValueDidChange), for: .valueChanged)
        }
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(didTapDoneOnDatePicker))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexSpace, doneButton], animated: true)
        
        dateTextField.do {
            $0.inputView = datePicker
            $0.inputAccessoryView = toolbar
            $0.text = formatDate(date: self.date)
        }
    }
    
    private func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    @objc private func didTapDoneOnDatePicker() {
        self.date = datePicker.date
        self.endEditing(true)
    }
    
    // 미래 시점으로 스크롤 할 경우 오늘 날짜로 복구
    @objc private func datePickerValueDidChange(_ sender: UIDatePicker) {
        if sender.date > Date() {
            sender.setDate(Date(), animated: true)
        }
        self.date = sender.date
    }
}


// MARK: - UITextFieldDelegate

extension DiaryDatePickerView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
