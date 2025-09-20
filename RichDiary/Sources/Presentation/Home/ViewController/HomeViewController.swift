//
//  HomeViewController.swift
//  RichDiary-iOS
//
//  Created by OneTen on 9/5/25.
//

import UIKit

import SnapKit
import Then

import RealmSwift
import RxSwift
import RxCocoa

final class HomeViewController: BaseUIViewController, TabBarResettable {
    
    // MARK: - Properties
    
    private let currentDateRelay = BehaviorRelay<Date>(value: Date())
    private let disposeBag = DisposeBag()
    
    private var notificationToken: RealmSwift.NotificationToken?
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setRealmNotification()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBinding()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        notificationToken?.invalidate()
        notificationToken = nil
    }
    
    //MARK: - Func
    
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
    
    func resetToInitialState() {
        scrollview.setContentOffset(.zero, animated: true)
        currentDateRelay.accept(Date())
        
        loadAndRefreshDiaries()
    }
}


//MARK: - Private Func

extension HomeViewController {
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
    
    // DiaryDetailViewController 이동 로직 분리
    private func navigateToDiaryDetail(diaryID: ObjectId) {
        do {
            let realm = try Realm()
            if let liveDiary = realm.object(ofType: DiaryModel.self, forPrimaryKey: diaryID) {
                let detailVC = DiaryDetailViewController(diaryId: liveDiary.diaryID)
                detailVC.modalPresentationStyle = .overFullScreen
                detailVC.modalTransitionStyle = .crossDissolve
                self.present(detailVC, animated: true)
            } else {
                // 해당 ID의 일기가 삭제되었거나 찾을 수 없을 경우
                print("오류: ID(\(diaryID))를 가진 일기를 찾을 수 없습니다. 이미 삭제되었을 수 있습니다.")
                presentAlert(title: "알림", message: "해당 일기가 삭제되었거나 찾을 수 없습니다.") { [weak self] in
                    // 삭제 알림 후 UI 재갱신
                    self?.loadAndRefreshDiaries()
                }
            }
        } catch {
            print("Realm 조회 중 에러 발생: \(error)")
            presentAlert(title: "오류", message: "데이터 로딩 중 문제가 발생했습니다.")
        }
    }
    
    // Realm에서 모든 일기를 불러와 UI를 갱신하는 함수
    private func loadAndRefreshDiaries() {
        do {
            let realm = try Realm()
            let allDiaries = Array(realm.objects(DiaryModel.self).sorted(byKeyPath: "date", ascending: false))
            updateUI(for: currentDateRelay.value, diaries: allDiaries)
        } catch {
            print("Realm 데이터 조회 중 에러: \(error)")
            updateUI(for: currentDateRelay.value, diaries: [])
        }
    }
    
    // 가계부 목록들 생성 함수
    private func setDiaryTiles(with models: [DiaryModel]) {
        
        diaryStackView.arrangedSubviews.forEach {
            diaryStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        let groupedByDate = Dictionary(grouping: models.filter { !$0.isInvalidated }) { model in
            return Calendar.current.startOfDay(for: model.date)
        }
        
        let sortedDates: [Date] = groupedByDate.keys.sorted(by: >)
        
        for date in sortedDates {
            let header = createDateHeaderLabel(for: date)
            diaryStackView.addArrangedSubview(header)
            
            header.snp.makeConstraints {
                $0.height.equalTo(40)
            }
            
            // 해당 날짜에 유효한 일기가 없으면 다음 날짜로 넘어감
            guard let diariesForDate = groupedByDate[date], !diariesForDate.isEmpty else {
                continue
            }
            
            for model in diariesForDate {
                let tile = DiaryTile()
                tile.configure(with: model)
                
                tile.snp.makeConstraints {
                    $0.height.equalTo(72)
                }
                
                tile.onTap = { [weak self] diaryID in
                    self?.navigateToDiaryDetail(diaryID: diaryID)
                }
                
                diaryStackView.addArrangedSubview(tile)
            }
        }
    }
    
    private func updateUI(for date: Date, diaries: [DiaryModel]) {
        
        // 해당 월에 맞는 데이터 필터링
        let filteredDiariesForMonth = diaries.filter { Calendar.current.isDate($0.date, equalTo: date, toGranularity: .month) }
        
        // 지출/수입 계산
        let totalExpense = filteredDiariesForMonth.filter { $0.diaryType == .expense }.reduce(0) { $0 + $1.money }
        let totalIncome = filteredDiariesForMonth.filter { $0.diaryType == .income }.reduce(0) { $0 + $1.money }
        let goal = UserDefaults.monthlyGoal
        
        summaryView.configure(date: date, expense: totalExpense, income: totalIncome, goal: goal)
        
        if filteredDiariesForMonth.isEmpty {
            diaryStackView.isHidden = true
            diaryEmptyView.isHidden = false
            
            self.diaryEmptyViewBottomConstraint?.activate()
            self.diaryStackViewBottomConstraint?.deactivate()
            
            diaryStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        } else {
            diaryStackView.isHidden = false
            diaryEmptyView.isHidden = true
            
            self.diaryStackViewBottomConstraint?.activate()
            self.diaryEmptyViewBottomConstraint?.deactivate()
            
            setDiaryTiles(with: filteredDiariesForMonth)
        }
        
        view.layoutIfNeeded()
    }
    
    private func updateDiariesAndUI(with diaries: [DiaryModel]) {
        updateUI(for: currentDateRelay.value, diaries: diaries)
    }
    
    private func setRealmNotification() {
        notificationToken?.invalidate()
        notificationToken = nil
        
        do {
            let realm = try Realm()
            let realmResults = realm.objects(DiaryModel.self).sorted(byKeyPath: "date", ascending: false)
            
            notificationToken = realmResults.observe { [weak self] (changes: RealmCollectionChange) in
                guard let self = self else { return }
                
                switch changes {
                case .initial(let results):
                    updateUI(for: currentDateRelay.value, diaries: Array(results))
                case .update(let results, _, _, _):
                    updateUI(for: currentDateRelay.value, diaries: Array(results))
                case .error(let error):
                    print("Realm Notification Error: \(error)")
                    updateUI(for: currentDateRelay.value, diaries: [])
                }
            }
        } catch {
            print("Realm Notification 초기화 중 에러 발생: \(error)")
            updateUI(for: currentDateRelay.value, diaries: [])
        }
    }
    
    private func setBinding() {
        
        // currentDateRelay의 변화에 따라 UI만 업데이트
        currentDateRelay
            .subscribe(onNext: { [weak self] date in
                guard let self = self else { return }
                self.loadAndRefreshDiaries()
            })
            .disposed(by: disposeBag)
        
        // SummaryView의 버튼 탭 이벤트 처리
        summaryView.previousMonthButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let previousMonthDate = Calendar.current.date(byAdding: .month, value: -1, to: self.currentDateRelay.value) ?? self.currentDateRelay.value
                self.currentDateRelay.accept(previousMonthDate)
            })
            .disposed(by: disposeBag)
        
        summaryView.nextMonthButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let nextMonthDate = Calendar.current.date(byAdding: .month, value: 1, to: self.currentDateRelay.value) ?? self.currentDateRelay.value
                self.currentDateRelay.accept(nextMonthDate)
            })
            .disposed(by: disposeBag)
        
        summaryView.setGoalButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let setGoalVC = GoalSettingViewController()
                setGoalVC.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(setGoalVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
