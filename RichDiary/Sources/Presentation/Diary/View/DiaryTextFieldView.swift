//
//  DiaryTextFieldView.swift
//  RichDiary
//
//  Created by OneTen on 9/12/25.
//

import UIKit

import SnapKit
import Then

final class DiaryTextFieldView: BaseUIView {

    // MARK: - Properties

    public var amount: Int {
        let amountString = amountTextField.text?.replacingOccurrences(of: ",", with: "") ?? ""
        return Int(amountString) ?? 0
    }
    
    public var diaryDescription: String {
        return descriptionTextField.text ?? ""
    }

    private lazy var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()

    
    // MARK: - UI Components
    
    private let amountLabel = UILabel()
    private let amountTextField = UITextField()
    private let limitLabel = UILabel()

    private let descriptionLabel = UILabel()
    private let descriptionTextField = UITextField()

    
    // MARK: - override Func
    
    override func setUI() {
        self.addSubviews(amountLabel, amountTextField, limitLabel, descriptionLabel, descriptionTextField)
    }

    override func setStyle() {
        amountLabel.do {
            $0.attributedText = .richStyle("금액", style: .custom(fontWeight: .bold, size: 16))
        }

        amountTextField.do {
            $0.borderStyle = .roundedRect
            $0.keyboardType = .numberPad
            $0.placeholder = "금액을 입력하세요"
            $0.delegate = self
            $0.textAlignment = .right
            
            let unitLabel = UILabel()
            unitLabel.attributedText = .richStyle("  원  ", style: .custom(fontWeight: .regular, size: 14))
            unitLabel.textColor = .gray
            unitLabel.sizeToFit()
            
            $0.rightView = unitLabel
            $0.rightViewMode = .always
        }
        
        limitLabel.do {
            $0.text = "최대 1억까지 입력 가능해요."
            $0.font = .systemFont(ofSize: 12)
            $0.textColor = .systemGray2
            $0.textAlignment = .right
        }

        descriptionLabel.do {
            $0.attributedText = .richStyle("내용", style: .custom(fontWeight: .bold, size: 16))
        }

        descriptionTextField.do {
            $0.borderStyle = .roundedRect
            $0.placeholder = "내용을 입력하세요"
        }
    }

    override func setLayout() {
        amountLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }

        amountTextField.snp.makeConstraints {
            $0.top.equalTo(amountLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }

        limitLabel.snp.makeConstraints {
            $0.top.equalTo(amountTextField.snp.bottom).offset(4)
            $0.trailing.equalTo(amountTextField.snp.trailing)
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(limitLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
        }

        descriptionTextField.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
            $0.bottom.equalToSuperview()
        }
    }
}


// MARK: - UITextField Delegate

extension DiaryTextFieldView: UITextFieldDelegate {
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
            
            // 0으로 시작하는 숫자 입력 방지 ("0" 하나만 입력하는 것은 제외)
            if numberString.hasPrefix("0") && numberString.count > 1 {
                return false
            }
            
            // 금액제한 1억
            guard let number = Int(numberString) else { return false }
            
            let maxAmount = 100_000_000
            let clampedNumber = min(number, maxAmount)
            
            let formattedString = numberFormatter.string(from: NSNumber(value: clampedNumber))
            textField.text = formattedString
            
            return false
        }
        
        return true
    }
}
