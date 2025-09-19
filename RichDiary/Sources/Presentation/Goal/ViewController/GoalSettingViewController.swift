//
//  GoalSettingViewController.swift
//  RichDiary
//
//  Created by OneTen on 9/19/25.
//

import UIKit

import SnapKit
import Then

final class GoalSettingViewController: BaseUIViewController {
    
    // MARK: - Properties
    
    private lazy var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let goalTextField = UITextField()
    private let saveButton = UIButton()
    
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.tintColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hidesBottomBarWhenPushed = true
    }
    
    // MARK: - Override Func
    
    override func setUI() {
        self.view.addSubviews(titleLabel, descriptionLabel, goalTextField, saveButton)
    }
    
    override func setStyle() {
        self.view.backgroundColor = .gray11
        
        titleLabel.do {
            $0.attributedText = .richStyle("한 달 목표 지출 설정", style: .custom(fontWeight: .bold, size: 24))
            $0.textColor = .white
            $0.textAlignment = .center
        }
        
        descriptionLabel.do {
            $0.attributedText = .richStyle("이번 달 목표 지출 금액을 입력해주세요.\n(숫자만 입력)", style: .body0)
            $0.textColor = .lightGray
            $0.textAlignment = .center
            $0.numberOfLines = 2
        }
        
        goalTextField.do {
            $0.placeholder = "현재 \(UserDefaults.monthlyGoal.asCurrencyString)"
            $0.keyboardType = .numberPad
            $0.textAlignment = .center
            $0.font = .richFont(.custom(fontWeight: .bold, size: 24))
            $0.textColor = .white
            $0.borderStyle = .roundedRect
            $0.backgroundColor = .gray5
            $0.layer.cornerRadius = 15
            $0.clipsToBounds = true
            $0.delegate = self
        }
        
        saveButton.do {
            $0.setTitle("저장하기", for: .normal)
            $0.setTitleColor(.gray11, for: .normal)
            $0.titleLabel?.font = .richFont(.custom(fontWeight: .semiBold, size: 16))
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 15
            $0.clipsToBounds = true
            $0.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        }
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(15)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        goalTextField.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(40)
            $0.horizontalEdges.equalToSuperview().inset(40)
            $0.height.equalTo(60)
        }
        
        saveButton.snp.makeConstraints {
            $0.top.equalTo(goalTextField.snp.bottom).offset(50)
            $0.horizontalEdges.equalToSuperview().inset(40)
            $0.height.equalTo(50)
        }
    }
    
}


// MARK: - Private Func

extension GoalSettingViewController {
    @objc private func saveButtonTapped() {
        guard let text = goalTextField.text, !text.isEmpty else {
            let alert = UIAlertController(title: "알림", message: "목표 금액을 입력해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        let cleanText = text.replacingOccurrences(of: ",", with: "")
        
        if let goal = Int(cleanText) {
            UserDefaults.monthlyGoal = goal
            
            let alert = UIAlertController(title: "완료", message: "목표 지출 금액이 저장되었습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
                self.navigationController?.popViewController(animated: true)
            })
            present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "오류", message: "유효한 숫자를 입력해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
}


// MARK: - UITextField Delegate

extension GoalSettingViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == goalTextField {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            let numberString = updatedText.replacingOccurrences(of: ",", with: "")
            
            if numberString.isEmpty {
                textField.text = ""
                return false
            }
            
            if numberString.hasPrefix("0") && numberString.count > 1 {
                return false
            }
            
            // 금액제한 100억
            let maxAmount = 10_000_000_000
            
            guard let number = Int(numberString) else {
                return false
            }
            
            if number > maxAmount {
                let formattedMaxAmount = numberFormatter.string(from: NSNumber(value: maxAmount)) ?? "\(maxAmount)"
                let alert = UIAlertController(title: "금액 초과", message: "최대 \(formattedMaxAmount)원까지 입력 가능합니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
                return false
            }
            
            let formattedString = numberFormatter.string(from: NSNumber(value: number))
            textField.text = formattedString
            
            return false
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == goalTextField {
            if let text = textField.text, text.isEmpty {
                textField.placeholder = "현재 \(UserDefaults.monthlyGoal.asCurrencyString)"
            }
        }
    }
}
