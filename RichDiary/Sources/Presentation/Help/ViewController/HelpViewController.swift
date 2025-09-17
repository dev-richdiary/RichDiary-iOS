//
//  HelpViewController.swift
//  RichDiary
//
//  Created by OneTen on 9/18/25.
//

import UIKit

import SnapKit
import Then

final class HelpViewController: BaseUIViewController {
    
    // MARK: - UI Components
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let mainTitleLabel = UILabel()
    private let descriptionStackView = UIStackView()
    private let typeAView = HelpTypeDescriptionView()
    private let typeBView = HelpTypeDescriptionView()
    private let typeCView = HelpTypeDescriptionView()
    
    
    //MARK: - Life Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.tintColor = .white
    }
    

    //MARK: - Override Func
    
    override func setUI() {
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(mainTitleLabel, descriptionStackView)
        descriptionStackView.addArrangedSubviews(typeAView, typeBView, typeCView)
    }
    
    override func setStyle() {
        self.view.backgroundColor = .gray11
        
        mainTitleLabel.do {
            $0.attributedText = .richStyle("소비 타입 도움말", style: .custom(fontWeight: .bold, size: 28))
            $0.textColor = .white
            $0.textAlignment = .center
        }
        
        descriptionStackView.do {
            $0.axis = .vertical
            $0.spacing = 20
            $0.distribution = .fill
            $0.alignment = .fill
        }
        
        typeAView.do {
            $0.configure(type: "A", title: "필수 소비", description: "삶을 유지하는 데 꼭 필요한 지출이에요. 식비, 주거비, 교통비, 통신비 등이 여기에 해당돼요. 이 소비를 줄이는 것은 삶의 질에 큰 영향을 줄 수 있으니 신중하게 관리해야 해요.", backgroundColor: .primaryLight)
        }
        
        typeBView.do {
            $0.configure(type: "B", title: "선택적 소비", description: "삶을 더 풍요롭게 하지만, 반드시 필요하지는 않은 지출이에요. 취미 활동, 외식, 쇼핑, 문화생활 등이 여기에 속해요. 재정 상황에 따라 조절할 수 있는 여지가 많아요.", backgroundColor: .primaryOrange)
        }

        typeCView.do {
            $0.configure(type: "C", title: "불필요 소비", description: "당장 필요 없거나, 소비하지 않아도 삶에 지장이 없는 지출이에요. 충동적인 구매, 잦은 배달 음식, 불필요한 구독 서비스 등이 해당돼요. 이 소비를 줄이면 재정 건전성을 크게 향상시킬 수 있어요.", backgroundColor: .primaryRed)
        }

    }
    
    override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        descriptionStackView.snp.makeConstraints {
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(30)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(30)
        }
    }
    
}

#Preview {
    HelpViewController()
}
