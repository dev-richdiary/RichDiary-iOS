//
//  HomeViewController.swift
//  RichDiary-iOS
//
//  Created by OneTen on 9/5/25.
//

import UIKit

import SnapKit

final class HomeViewController: BaseUIViewController {
    
    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .richStyle("홈 화면", style: .custom(fontWeight: .bold, size: 25))
        label.textColor = UIColor.label // 다크모드 대응
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "폰트와 컬러 확인 중"
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = UIColor.secondaryLabel
        return label
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("테스트 버튼", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let colorBox: UIView = {
        let view = UIView()
        view.backgroundColor = .primaryBlue
        view.layer.cornerRadius = 12
        return view
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupLayout()
    }
    
    // MARK: - Layout
    private func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(actionButton)
        view.addSubview(colorBox)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        actionButton.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.width.equalTo(160)
            make.height.equalTo(44)
        }
        
        colorBox.snp.makeConstraints { make in
            make.top.equalTo(actionButton.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(80)
        }
    }
}
