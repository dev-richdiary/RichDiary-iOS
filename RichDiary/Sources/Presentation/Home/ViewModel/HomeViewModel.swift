//
//  HomeViewModel.swift
//  RichDiary
//
//  Created by OneTen on 9/29/25.
//

import Foundation

import RealmSwift
import RxSwift
import RxCocoa

final class HomeViewModel {
    
    // MARK: - Properties
    
    // Input
    let previousMonthTapped = PublishRelay<Void>()
    let nextMonthTapped = PublishRelay<Void>()
    let setGoalTapped = PublishRelay<Void>()
    
    // Output
    let currentDate: BehaviorRelay<Date>
    let monthlySummary: BehaviorRelay<(expense: Int, income: Int, goal: Int)>
    let groupedDiaries: BehaviorRelay<[Date: [DiaryModel]]>
    let isEmpty: BehaviorRelay<Bool>
    let alertMessage = PublishRelay<(String, String)>()
    
    private var notificationToken: NotificationToken?
    private let disposeBag = DisposeBag()
    
    
    // MARK: - init

    init() {
        currentDate = BehaviorRelay(value: Date())
        monthlySummary = BehaviorRelay(value: (0, 0, 0))
        groupedDiaries = BehaviorRelay(value: [:])
        isEmpty = BehaviorRelay(value: true)
        
        bindInputs()
        observeRealmChanges()
        loadAndRefreshDiaries()
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
}


//MARK: - Private Func

extension HomeViewModel {

    private func bindInputs() {
        previousMonthTapped
            .withLatestFrom(currentDate)
            .map { Calendar.current.date(byAdding: .month, value: -1, to: $0) ?? $0 }
            .bind(to: currentDate)
            .disposed(by: disposeBag)
        
        nextMonthTapped
            .withLatestFrom(currentDate)
            .map { Calendar.current.date(byAdding: .month, value: 1, to: $0) ?? $0 }
            .bind(to: currentDate)
            .disposed(by: disposeBag)
        
        currentDate
            .subscribe(onNext: { [weak self] _ in
                self?.loadAndRefreshDiaries()
            })
            .disposed(by: disposeBag)
    }
    
    private func observeRealmChanges() {
        do {
            let realm = try Realm()
            let results = realm.objects(DiaryModel.self).sorted(byKeyPath: "date", ascending: false)
            
            notificationToken = results.observe { [weak self] change in
                guard let self = self else { return }
                switch change {
                case .initial(let data), .update(let data, _, _, _):
                    self.updateUIState(with: Array(data))
                case .error(let error):
                    print("Realm observe error:", error)
                    self.alertMessage.accept(("오류", "데이터를 불러오지 못했습니다."))
                }
            }
        } catch {
            alertMessage.accept(("오류", "데이터베이스 연결 실패"))
        }
    }
    
    private func loadAndRefreshDiaries() {
        do {
            let realm = try Realm()
            let allDiaries = Array(realm.objects(DiaryModel.self).sorted(byKeyPath: "date", ascending: false))
            updateUIState(with: allDiaries)
        } catch {
            alertMessage.accept(("오류", "데이터를 불러오지 못했습니다."))
        }
    }
    
    private func updateUIState(with diaries: [DiaryModel]) {
        let date = currentDate.value
        
        // 월별 필터링
        let filtered = diaries.filter { Calendar.current.isDate($0.date, equalTo: date, toGranularity: .month) }
        
        // 지출/수입 계산
        let expense = filtered.filter { $0.diaryType == .expense }.reduce(0) { $0 + $1.money }
        let income = filtered.filter { $0.diaryType == .income }.reduce(0) { $0 + $1.money }
        let goal = UserDefaults.monthlyGoal
        
        monthlySummary.accept((expense, income, goal))
        
        // 날짜별 그룹화
        let grouped = Dictionary(grouping: filtered) { Calendar.current.startOfDay(for: $0.date) }
        groupedDiaries.accept(grouped)
        
        isEmpty.accept(filtered.isEmpty)
    }
}
