//
//  CalendarViewModel.swift
//  RichDiary
//
//  Created by OneTen on 10/9/25.
//

import Foundation

import RealmSwift
import RxSwift
import RxCocoa

final class CalendarViewModel: ViewModelType {
    
    // MARK: - Properties
    
    let input: Input
    let output: Output
    
    private var notificationToken: NotificationToken?
    private let disposeBag = DisposeBag()
    private let calendarManager = CalendarManager()
    
    
    // MARK: - init
    
    init() {
        
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
    
    deinit {
        notificationToken?.invalidate()
    }
}


// MARK: - Private Func

extension CalendarViewModel {
    
    private func bind(input: Input, output: Output) {
        
        input.previousMonthButtonTapped
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                output._selectedDate.accept(nil)
                let newDate = self.calendarManager.previousMonth(from: output._currentCalendarDate.value)
                output._currentCalendarDate.accept(newDate)
            })
            .disposed(by: disposeBag)
        
        input.nextMonthButtonTapped
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                output._selectedDate.accept(nil)
                let newDate = self.calendarManager.nextMonth(from: output._currentCalendarDate.value)
                output._currentCalendarDate.accept(newDate)
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
        
        Observable.merge(
            input.viewWillAppear.asObservable(),
            input.resetTapped.asObservable()
        )
        .subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.observeRealmChanges(allDiaries: output._allDiaries, alertMessage: output._alertMessage)
            output._currentCalendarDate.accept(Date())
            output._selectedDate.accept(Date())
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
    
    private func observeRealmChanges(allDiaries: BehaviorRelay<[DiaryModel]>, alertMessage: PublishRelay<(String, String)>) {
        notificationToken?.invalidate()
        
        do {
            let realm = try Realm()
            let results = realm.objects(DiaryModel.self).sorted(byKeyPath: "date", ascending: false)
            
            notificationToken = results.observe { changes in
                switch changes {
                case .initial(let data), .update(let data, _, _, _):
                    let validDiaries = Array(data).filter { !$0.isInvalidated }
                    allDiaries.accept(validDiaries)
                case .error(let error):
                    print("Realm observe error:", error)
                    alertMessage.accept(("오류", "데이터를 불러오지 못했습니다."))
                }
            }
        } catch {
            alertMessage.accept(("오류", "데이터베이스 연결 실패: \(error.localizedDescription)"))
        }
    }
    
    func reloadAllData() {
        self.observeRealmChanges(allDiaries: output._allDiaries, alertMessage: output._alertMessage)
        output._selectedDate.accept(output._selectedDate.value)
    }
}


//MARK: - ViewModelType

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
