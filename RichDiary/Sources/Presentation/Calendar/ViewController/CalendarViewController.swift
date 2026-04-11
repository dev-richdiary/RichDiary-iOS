//
//  CalendarViewController.swift
//  RichDiary-iOS
//
//  Created by OneTen on 9/5/25.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

final class CalendarViewController: BaseUIViewController, TabBarResettable {
    
    // MARK: - Properties
    
    private let viewModel: CalendarViewModel
    private let disposeBag = DisposeBag()
    
    
    // MARK: - UI Components
    
    private let scrollview = UIScrollView()
    private let contentView = UIView()
    private let headerView = CalendarHeaderView()
    private let calendarView = CalendarView()
    private let diaryStackView = UIStackView()
    
    
    // MARK: - Init
    
    init(viewModel: CalendarViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.input.viewWillAppear.accept(())
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleDiaryChangesNotification), name: .diaryChanged, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: .diaryChanged, object: nil)
    }
    
    //MARK: - Func
    
    override func setUI() {
        self.view.addSubviews(headerView, scrollview)
        scrollview.addSubview(contentView)
        contentView.addSubviews(calendarView, diaryStackView)
    }
    
    override func setStyle() {
        scrollview.do {
            $0.showsVerticalScrollIndicator = false
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 40
            $0.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
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
        
        calendarView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        diaryStackView.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
    func resetToInitialState() {
        scrollview.setContentOffset(.zero, animated: true)
        viewModel.input.resetTapped.accept(())
    }
}


// MARK: - Private Func

extension CalendarViewController {
    private func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        self.present(alert, animated: true)
    }
    
    private func bind() {
        calendarView.bind(to: viewModel)
        
        headerView.helpButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let helpVC = HelpViewController()
                helpVC.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(helpVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.filteredDiaries
            .drive(onNext: { [weak self] diaries in
                self?.updateDiaryTiles(with: diaries)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.alertMessage
            .drive(onNext: { [weak self] title, message in
                self?.presentAlert(title: title, message: message)
            })
            .disposed(by: disposeBag)
    }
    
    private func updateDiaryTiles(with diaries: [DiaryModel]) {
        
        // 기존 뷰 제거
        diaryStackView.arrangedSubviews.forEach {
            diaryStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        if diaries.isEmpty {
            let noDiaryLabel = UILabel().then {
                $0.text = "선택한 날짜에 가계부가 없습니다."
                $0.textColor = .gray
                $0.textAlignment = .center
                $0.font = .systemFont(ofSize: 16)
            }
            diaryStackView.addArrangedSubview(noDiaryLabel)
            noDiaryLabel.snp.makeConstraints {
                $0.height.equalTo(100)
            }
        } else {
            for model in diaries {
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
        view.layoutIfNeeded()
    }
}


// MARK: - Notification Handling

extension CalendarViewController {
    @objc private func handleDiaryChangesNotification() {
        // viewModel.reloadAllData() 
        // -> UseCase 스트림을 통해 자동 업데이트되므로 명시적 호출 불필요할 수 있음. 
        // 필요 시 viewModel.input.viewWillAppear.accept(()) 등으로 대체 가능.
    }
}
