//
//  HomeViewModel.swift
//  RichDiary
//
//  Created by OneTen on 9/29/25.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeViewModel {
    
    // MARK: - Properties
    
    let input: Input
    let output: Output
    
    private let fetchDiariesUseCase: FetchDiariesUseCase
    private let disposeBag = DisposeBag()
    
    
    // MARK: - init

    init(fetchDiariesUseCase: FetchDiariesUseCase) {
        self.fetchDiariesUseCase = fetchDiariesUseCase
        
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
    }
    
}


// MARK: - Private Func

extension HomeViewModel {

    private func bind(input: Input, output: Output) {
        // 월 변경 로직
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
        
        // 날짜 변경 시 데이터 다시 가져오기
        output.currentDate
            .flatMapLatest { [weak self] date -> Observable<[DiaryModel]> in
                guard let self = self else { return .empty() }
                return self.fetchDiariesUseCase.execute(date: date)
                    .catch { error in
                        output.alertMessage.accept(("오류", "데이터를 불러오지 못했습니다."))
                        return .just([])
                    }
            }
            .subscribe(onNext: { [weak self] diaries in
                self?.updateUIState(output: output, with: diaries)
            })
            .disposed(by: disposeBag)
    }
    
    private func updateUIState(output: Output, with diaries: [DiaryModel]) {
        // 지출/수입 계산
        let expense = diaries.filter { $0.diaryType == .expense }.reduce(0) { $0 + $1.money }
        let income = diaries.filter { $0.diaryType == .income }.reduce(0) { $0 + $1.money }
        let goal = UserDefaults.monthlyGoal
        
        output.monthlySummary.accept((expense, income, goal))
        
        // 날짜별 그룹화
        let grouped = Dictionary(grouping: diaries) { Calendar.current.startOfDay(for: $0.date) }
        output.groupedDiaries.accept(grouped)
        
        output.isEmpty.accept(diaries.isEmpty)
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
