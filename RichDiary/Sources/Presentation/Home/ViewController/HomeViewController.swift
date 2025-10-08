//
//  HomeViewController.swift
//  RichDiary-iOS
//
//  Created by OneTen on 9/5/25.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

final class HomeViewController: BaseUIViewController, TabBarResettable {
    
    // MARK: - Properties
    
    private let viewModel = HomeViewModel()
    private let disposeBag = DisposeBag()
    
    private var diaryStackViewBottomConstraint: Constraint?
    private var diaryEmptyViewBottomConstraint: Constraint?
    
    
    // MARK: - UI Components
    
    private let scrollview = UIScrollView()
    private let contentView = UIView()
    private let headerView = HomeHeaderView()
    private let summaryView = HomeSummaryView()
    private let separator = UIView()
    private let diaryStackView = UIStackView()
    private let diaryEmptyView = DiaryEmptyView()
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    
    // MARK: - Override Func
    
    override func setUI() {
        self.view.addSubviews(headerView, scrollview)
        scrollview.addSubview(contentView)
        contentView.addSubviews(summaryView, separator, diaryEmptyView, diaryStackView)
    }
    
    override func setStyle() {
        headerView.do {
            $0.helpButton.rx.tap
                .subscribe(onNext: { [weak self] in
                    let helpVC = HelpViewController()
                    helpVC.hidesBottomBarWhenPushed = true
                    self?.navigationController?.pushViewController(helpVC, animated: true)
                })
                .disposed(by: disposeBag)
            
            /*
             $0.noticeButton.rx.tap
             .subscribe(onNext: { [weak self] in
             let noticeVC = NoticeViewController()
             noticeVC.hidesBottomBarWhenPushed = true
             self?.navigationController?.pushViewController(noticeVC, animated: true)
             })
             .disposed(by: disposeBag)
             */
        }
        
        scrollview.do {
            $0.showsVerticalScrollIndicator = false
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 40
            $0.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
            $0.contentInsetAdjustmentBehavior = .never
        }
        
        separator.do {
            $0.backgroundColor = .gray5
        }
        
        diaryStackView.do {
            $0.axis = .vertical
            $0.spacing = 0
            $0.distribution = .fill
        }
    }
    
    override func setLayout() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(52)
        }
        
        scrollview.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(25)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        summaryView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(250)
        }
        
        separator.snp.makeConstraints {
            $0.top.equalTo(summaryView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(10)
        }
        
        diaryStackView.snp.makeConstraints {
            $0.top.equalTo(separator.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            
            self.diaryStackViewBottomConstraint = $0.bottom.equalToSuperview().inset(40).constraint
            self.diaryStackViewBottomConstraint?.deactivate()
        }
        
        diaryEmptyView.snp.makeConstraints {
            $0.top.equalTo(separator.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(350)
            
            self.diaryEmptyViewBottomConstraint = $0.bottom.equalToSuperview().inset(40).constraint
        }
    }
    
    
    // MARK: - Func
    
    func resetToInitialState() {
        scrollview.setContentOffset(.zero, animated: true)
        viewModel.output.currentDate.accept(Date())
    }
}


// MARK: - Private Func

extension HomeViewController {
    private func bind() {
        
        // Input
        summaryView.previousMonthButton.rx.tap
            .bind(to: viewModel.input.previousMonthTapped)
            .disposed(by: disposeBag)
        
        summaryView.nextMonthButton.rx.tap
            .bind(to: viewModel.input.nextMonthTapped)
            .disposed(by: disposeBag)
        
        summaryView.setGoalButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let setGoalVC = GoalSettingViewController()
                setGoalVC.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(setGoalVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        // Output
        viewModel.output.monthlySummary
            .subscribe(onNext: { [weak self] summary in
                guard let self else { return }
                self.summaryView.configure(
                    date: self.viewModel.output.currentDate.value,
                    expense: summary.expense,
                    income: summary.income,
                    goal: summary.goal
                )
            })
            .disposed(by: disposeBag)
        
        viewModel.output.groupedDiaries
            .subscribe(onNext: { [weak self] grouped in
                self?.updateDiaryTiles(grouped)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.isEmpty
            .subscribe(onNext: { [weak self] empty in
                self?.diaryStackView.isHidden = empty
                self?.diaryEmptyView.isHidden = !empty
                
                if empty {
                    self?.diaryEmptyViewBottomConstraint?.activate()
                    self?.diaryStackViewBottomConstraint?.deactivate()
                } else {
                    self?.diaryStackViewBottomConstraint?.activate()
                    self?.diaryEmptyViewBottomConstraint?.deactivate()
                }
                
                self?.view.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
        
        viewModel.output.alertMessage
            .subscribe(onNext: { [weak self] title, msg in
                self?.presentAlert(title: title, message: msg)
            })
            .disposed(by: disposeBag)
    }
    
    private func presentAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
            completion?()
        })
        self.present(alert, animated: true)
    }
    
    private func createDateHeaderLabel(for date: Date) -> UIView {
        let label = UILabel()
        let container = UIView()
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일 EEEE" // ex) 9월 11일 목요일
        
        label.do {
            $0.text = formatter.string(from: date)
            $0.font = .systemFont(ofSize: 14, weight: .medium)
            $0.textColor = .gray
        }
        
        container.addSubviews(label)
        
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
        
        return container
    }
    
    private func updateDiaryTiles(_ grouped: [Date: [DiaryModel]]) {
        diaryStackView.arrangedSubviews.forEach {
            diaryStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        let sortedDates = grouped.keys.sorted(by: >)
        
        for date in sortedDates {
            let header = createDateHeaderLabel(for: date)
            diaryStackView.addArrangedSubview(header)
            header.snp.makeConstraints {
                $0.height.equalTo(40)
            }
            
            guard let diariesForDate = grouped[date], !diariesForDate.isEmpty else {
                continue
            }
            
            for model in diariesForDate {
                let tile = DiaryTile()
                tile.configure(with: model)
                tile.snp.makeConstraints {
                    $0.height.equalTo(72)
                }
                tile.onTap = { [weak self] diaryID in
                    let detailVC = DiaryDetailViewController(diaryId: diaryID)
                    detailVC.modalPresentationStyle = .overFullScreen
                    detailVC.modalTransitionStyle = .crossDissolve
                    self?.present(detailVC, animated: true)
                }
                diaryStackView.addArrangedSubview(tile)
            }
        }
        
    }
}
