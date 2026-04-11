//
//  CalendarViewModel.swift
//  RichDiary
//
//  Created by OneTen on 10/9/25.
//

import Foundation
import RxSwift
import RxCocoa

final class CalendarViewModel: ViewModelType {
    
    // MARK: - Properties
    
    let input: Input
    let output: Output
    
    private let fetchDiariesUseCase: FetchDiariesUseCase
    private let disposeBag = DisposeBag()
    private let calendarManager = CalendarManager()
    
    
    // MARK: - init
    
    init(fetchDiariesUseCase: FetchDiariesUseCase) {
        self.fetchDiariesUseCase = fetchDiariesUseCase
        
        // Input
        let previousMonthButtonTapped = PublishRelay<Void>()
        let nextMonthButtonTapped = PublishRelay<Void>()
        let dateCellTapped = PublishRelay<Date>()
        
        let resetTapped = PublishRelay<Void>()
        let viewWillAppear = PublishRelay<Void>()
        
        self.input = Input(
            previousMonthButtonTapped: previousMonthButtonTapped,
            nextMonthButtonTapped: nextMonthButtonTapped,
            dateCellTapped: dateCellTapped,
            resetTapped: resetTapped,
            viewWillAppear: viewWillAppear
        )
        
        // Output
        let currentCalendarDate = BehaviorRelay<Date>(value: Date())
        let selectedDate = BehaviorRelay<Date?>(value: Date())
        let allDiaries = BehaviorRelay<[DiaryModel]>(value: [])
        let filteredDiaries = BehaviorRelay<[DiaryModel]>(value: [])
        let alertMessage = PublishRelay<(String, String)>()
        
        self.output = Output(
            _currentCalendarDate: currentCalendarDate,
            _selectedDate: selectedDate,
            _allDiaries: allDiaries,
            _filteredDiaries: filteredDiaries,
            _alertMessage: alertMessage
        )
        
        bind(input: self.input, output: self.output)
    }
}


// MARK: - Private Func

extension CalendarViewModel {
    
    private func bind(input: Input, output: Output) {
        
        Observable.merge(
            input.previousMonthButtonTapped.map { -1 },
            input.nextMonthButtonTapped.map { 1 }
        )
        .subscribe(onNext: { monthOffset in
            
            let currentDate = output._currentCalendarDate.value
            guard let newDate = Calendar.current.date(byAdding: .month, value: monthOffset, to: currentDate) else { return }
            
            output._currentCalendarDate.accept(newDate)
            
            let calendar = Calendar.current
            let today = Date()
            
            if calendar.isDate(newDate, equalTo: today, toGranularity: .month) {
                output._selectedDate.accept(today)
            } else if newDate < today {
                if let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: newDate)) {
                    output._selectedDate.accept(firstDayOfMonth)
                } else {
                    output._selectedDate.accept(nil)
                }
            } else {
                output._selectedDate.accept(nil)
                output._filteredDiaries.accept([])
            }
        })
        .disposed(by: disposeBag)
        
        input.dateCellTapped
            .distinctUntilChanged()
            .subscribe(onNext: { date in
                if Calendar.current.compare(date, to: Date(), toGranularity: .day) == .orderedDescending {
                    output._alertMessage.accept(("알림", "미래 날짜는 선택할 수 없습니다."))
                    return
                }
                output._selectedDate.accept(date)
            })
            .disposed(by: disposeBag)
        
        enum ReloadCase {
            case viewWillAppear
            case resetTapped
        }
        
        Observable.merge(
            input.viewWillAppear.map { ReloadCase.viewWillAppear },
            input.resetTapped.map { ReloadCase.resetTapped }
        )
        .subscribe(onNext: { [weak self] event in
            guard let self = self else { return }
            let today = Date()
            
            switch event {
            case .viewWillAppear:
                if !Calendar.current.isDate(output._currentCalendarDate.value, equalTo: today, toGranularity: .month) {
                    output._currentCalendarDate.accept(today)
                    output._selectedDate.accept(today)
                } else if output._selectedDate.value == nil {
                    output._selectedDate.accept(today)
                }
            case .resetTapped:
                output._currentCalendarDate.accept(today)
                output._selectedDate.accept(today)
            }
        })
        .disposed(by: disposeBag)
        
        // UseCase를 통한 데이터 관찰
        self.fetchDiariesUseCase.execute(date: Date()) // 초기 날짜 무관하게 전체 관찰 필요 시 Repository 수정 검토
            .subscribe(onNext: { diaries in
                output._allDiaries.accept(diaries)
            }, onError: { error in
                output._alertMessage.accept(("오류", "데이터를 불러오지 못했습니다."))
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            output._selectedDate.asObservable().compactMap { $0 },
            output._allDiaries.asObservable()
        )
        .map { (selectedDate, allDiaries) -> [DiaryModel] in
            return allDiaries.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
        }
        .bind(to: output._filteredDiaries)
        .disposed(by: disposeBag)
    }
}


// MARK: - ViewModelType

extension CalendarViewModel {
    struct Input {
        let previousMonthButtonTapped: PublishRelay<Void>
        let nextMonthButtonTapped: PublishRelay<Void>
        let dateCellTapped: PublishRelay<Date>
        
        let resetTapped: PublishRelay<Void>
        let viewWillAppear: PublishRelay<Void>
    }
    
    struct Output {
        let _currentCalendarDate: BehaviorRelay<Date>
        let _selectedDate: BehaviorRelay<Date?>
        let _allDiaries: BehaviorRelay<[DiaryModel]>
        let _filteredDiaries: BehaviorRelay<[DiaryModel]>
        let _alertMessage: PublishRelay<(String, String)>
        
        var currentMonthText: Driver<String> {
            return _currentCalendarDate
                .map { DateFormatter.monthFormatter.string(from: $0) }
                .asDriver(onErrorJustReturn: "")
        }
        
        var currentYearText: Driver<String> {
            return _currentCalendarDate
                .map { DateFormatter.yearFormatter.string(from: $0) }
                .asDriver(onErrorJustReturn: "")
        }
        
        var currentCalendarDate: Driver<Date> {
            return _currentCalendarDate.asDriver(onErrorJustReturn: Date())
        }
        
        var selectedDate: Driver<Date?> {
            return _selectedDate.asDriver(onErrorJustReturn: nil)
        }
        
        var calendarDayData: Driver<CalendarDayData> {
            return Observable.combineLatest(
                _currentCalendarDate.asObservable(),
                _allDiaries.asObservable()
            )
            .map { (dateForMonth, allDiaryModels) -> CalendarDayData in
                let calendarManager = CalendarManager()
                let daysInMonth = calendarManager.daysInMonth(for: dateForMonth)
                let calendar = Calendar.current
                let diaryDatesSet = Set(allDiaryModels.map { calendar.dateComponents([.year, .month, .day], from: $0.date) })
                return CalendarDayData(days: daysInMonth, diaryDates: diaryDatesSet)
            }
            .asDriver(onErrorJustReturn: CalendarDayData(days: [], diaryDates: []))
        }
        
        var allDiaries: Driver<[DiaryModel]> {
            return _allDiaries.asDriver(onErrorJustReturn: [])
        }
        
        var filteredDiaries: Driver<[DiaryModel]> {
            return _filteredDiaries.asDriver(onErrorJustReturn: [])
        }
        
        var alertMessage: Driver<(String, String)> {
            return _alertMessage.asDriver(onErrorJustReturn: ("", ""))
        }
        
    }
}

struct CalendarDayData {
    let days: [Date?]
    let diaryDates: Set<DateComponents>
}
