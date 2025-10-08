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
    
    let input: Input
    let output: Output
    
    private var notificationToken: NotificationToken?
    private let disposeBag = DisposeBag()
    
    
    // MARK: - init

    init() {
        
        // Input
        let previousMonthTapped = PublishRelay<Void>()
        let nextMonthTapped = PublishRelay<Void>()
        let setGoalTapped = PublishRelay<Void>()
        
        self.input = Input(
            previousMonthTapped: previousMonthTapped,
            nextMonthTapped: nextMonthTapped,
            setGoalTapped: setGoalTapped
        )
        
        // Output
        let currentDate = BehaviorRelay<Date>(value: Date())
        let monthlySummary = BehaviorRelay<(expense: Int, income: Int, goal: Int)>(value: (0, 0, 0))
        let groupedDiaries = BehaviorRelay<[Date: [DiaryModel]]>(value: [:])
        let isEmpty = BehaviorRelay<Bool>(value: true)
        let alertMessage = PublishRelay<(String, String)>()
        
        self.output = Output(
            currentDate: currentDate,
            monthlySummary: monthlySummary,
            groupedDiaries: groupedDiaries,
            isEmpty: isEmpty,
            alertMessage: alertMessage
        )
        
        bind(input: self.input, output: self.output)
        observeRealmChanges(output: self.output)
        loadAndRefreshDiaries(output: self.output)
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
}


//MARK: - Private Func

extension HomeViewModel {

    private func bind(input: Input, output: Output) {
        input.previousMonthTapped
            .withLatestFrom(output.currentDate)
            .map { Calendar.current.date(byAdding: .month, value: -1, to: $0) ?? $0 }
            .bind(to: output.currentDate)
            .disposed(by: disposeBag)
        
        input.nextMonthTapped
            .withLatestFrom(output.currentDate)
            .map { Calendar.current.date(byAdding: .month, value: 1, to: $0) ?? $0 }
            .bind(to: output.currentDate)
            .disposed(by: disposeBag)
        
        output.currentDate
            .subscribe(onNext: { [weak self] _ in
                self?.loadAndRefreshDiaries(output: output)
            })
            .disposed(by: disposeBag)
    }
    
    private func observeRealmChanges(output: Output) {
        do {
            let realm = try Realm()
            let results = realm.objects(DiaryModel.self).sorted(byKeyPath: "date", ascending: false)
            
            notificationToken = results.observe { [weak self] change in
                guard let self = self else { return }
                switch change {
                case .initial(let data), .update(let data, _, _, _):
                    self.updateUIState(output: output, with: Array(data))
                case .error(let error):
                    print("Realm observe error:", error)
                    output.alertMessage.accept(("오류", "데이터를 불러오지 못했습니다."))
                }
            }
        } catch {
            output.alertMessage.accept(("오류", "데이터베이스 연결 실패"))
        }
    }
    
    private func loadAndRefreshDiaries(output: Output) {
        do {
            let realm = try Realm()
            let allDiaries = Array(realm.objects(DiaryModel.self).sorted(byKeyPath: "date", ascending: false))
            updateUIState(output: output, with: allDiaries)
        } catch {
            output.alertMessage.accept(("오류", "데이터를 불러오지 못했습니다."))
        }
    }
    
    private func updateUIState(output: Output, with diaries: [DiaryModel]) {
        let date = output.currentDate.value
        
        // 월별 필터링
        let filtered = diaries.filter { Calendar.current.isDate($0.date, equalTo: date, toGranularity: .month) }
        
        // 지출/수입 계산
        let expense = filtered.filter { $0.diaryType == .expense }.reduce(0) { $0 + $1.money }
        let income = filtered.filter { $0.diaryType == .income }.reduce(0) { $0 + $1.money }
        let goal = UserDefaults.monthlyGoal
        
        output.monthlySummary.accept((expense, income, goal))
        
        // 날짜별 그룹화
        let grouped = Dictionary(grouping: filtered) { Calendar.current.startOfDay(for: $0.date) }
        output.groupedDiaries.accept(grouped)
        
        output.isEmpty.accept(filtered.isEmpty)
    }
}


//MARK: - ViewModelType

extension HomeViewModel: ViewModelType {
    struct Input {
        let previousMonthTapped: PublishRelay<Void>
        let nextMonthTapped: PublishRelay<Void>
        let setGoalTapped: PublishRelay<Void>
    }
    
    struct Output {
        let currentDate: BehaviorRelay<Date>
        let monthlySummary: BehaviorRelay<(expense: Int, income: Int, goal: Int)>
        let groupedDiaries: BehaviorRelay<[Date: [DiaryModel]]>
        let isEmpty: BehaviorRelay<Bool>
        let alertMessage: PublishRelay<(String, String)>
    }
}
