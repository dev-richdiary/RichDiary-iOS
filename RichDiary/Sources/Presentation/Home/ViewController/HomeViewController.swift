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

final class HomeViewController: BaseUIViewController, TabBarResettable, HomeSummaryViewDelegate {
    
    // MARK: - Properties
    
    private var allDiaries: [DiaryModel] = []
    private var currentDate = Date()
    
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
        
        fetchData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        summaryView.delegate = self
    }
    
    
    //MARK: - Func
    
    override func setUI() {
        self.view.addSubviews(headerView, scrollview)
        scrollview.addSubview(contentView)
        contentView.addSubviews(summaryView, separator, diaryEmptyView, diaryStackView)
    }
    
    override func setStyle() {
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
        currentDate = Date()
        updateUI(for: currentDate)
    }
    
    func didTapPreviousMonth() {
        self.currentDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
        updateUI(for: currentDate)
    }
    
    func didTapNextMonth() {
        self.currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
        updateUI(for: currentDate)
    }
    
    func didTapCalendar() {
        self.tabBarController?.selectedIndex = 1
    }
    
}


//MARK: - Private Func

extension HomeViewController {
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
    
    private func setDiaryTiles(with models: [DiaryModel]) {
        // 기존 뷰 제거
        diaryStackView.arrangedSubviews.forEach {
            diaryStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        let groupedByDate = Dictionary(grouping: models) { model in
            return Calendar.current.startOfDay(for: model.date)
        }
        
        let sortedDates: [Date] = groupedByDate.keys.sorted(by: >)
        
        for date in sortedDates {
            let header = createDateHeaderLabel(for: date)
            diaryStackView.addArrangedSubview(header)
            
            header.snp.makeConstraints {
                $0.height.equalTo(40)
            }
            
            if let diariesForDate = groupedByDate[date] {
                let validDiariesForDate = diariesForDate.filter { !$0.isInvalidated }
                
                for model in validDiariesForDate {
                    let tile = DiaryTile()
                    tile.configure(with: model)
                    tile.snp.makeConstraints {
                        $0.height.equalTo(72)
                    }
                    
                    tile.onTap = { [weak self] diaryID in
                        guard let self = self else { return }
                        
                        do {
                            let realm = try Realm()
                            if let liveDiary = realm.object(ofType: DiaryModel.self, forPrimaryKey: diaryID) {
                                let detailVC = DiaryDetailViewController(diary: liveDiary)
                                detailVC.modalPresentationStyle = .overFullScreen
                                detailVC.modalTransitionStyle = .crossDissolve
                                self.present(detailVC, animated: true)
                            } else {
                                // 해당 ID의 일기가 삭제되었거나 찾을 수 없을 경우
                                print("오류: ID(\(diaryID))를 가진 일기를 찾을 수 없습니다. 이미 삭제되었을 수 있습니다.")
                                let alert = UIAlertController(title: "알림", message: "해당 일기가 삭제되었거나 찾을 수 없습니다.", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
                                    self.fetchData()
                                })
                                self.present(alert, animated: true, completion: nil)
                            }
                        } catch {
                            print("Realm 조회 중 에러 발생: \(error)")
                            let alert = UIAlertController(title: "오류", message: "데이터 로딩 중 문제가 발생했습니다.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                    
                    diaryStackView.addArrangedSubview(tile)
                }
            }
        }
    }
    
    private func updateUI(for date: Date) {
        
        // 해당 월에 맞는 데이터 필터링
        let diariesForMonth = allDiaries
            .filter { !$0.isInvalidated }
            .filter { Calendar.current.isDate($0.date, equalTo: date, toGranularity: .month) }
        
        // 지출/수입 계산
        let totalExpense = diariesForMonth.filter { $0.diaryType == .expense }.reduce(0) { $0 + $1.money }
        let totalIncome = diariesForMonth.filter { $0.diaryType == .income }.reduce(0) { $0 + $1.money }
        let goal = 2_000_000 // TODO: - 목표 금액은 일단 고정, 추후 목표 금액 세팅 기능 구현 예정
        
        summaryView.configure(date: date, expense: totalExpense, income: totalIncome, goal: goal)
        
        if diariesForMonth.isEmpty {
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
            
            setDiaryTiles(with: diariesForMonth)
        }
        
        view.layoutIfNeeded()
    }
    
    private func fetchData() {
        do {
            let realm = try Realm()
            let realmResults = realm.objects(DiaryModel.self).sorted(byKeyPath: "date", ascending: false)
            self.allDiaries = Array(realmResults)
            updateUI(for: currentDate)
        } catch {
            print("Realm 데이터 로딩 중 에러 발생: \(error)")
        }
    }
}
