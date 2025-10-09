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
    
    
    // MARK: - init
    
    init() {
        
        // Input
        let previousMonthTapped = PublishRelay<Void>()
        let nextMonthTapped = PublishRelay<Void>()
        let dateSelected = BehaviorRelay<Date>(value: Date())
        let resetTapped = PublishRelay<Void>()
        let viewWillAppear = PublishRelay<Void>()
        
        self.input = Input(
            previousMonthTapped: previousMonthTapped,
            nextMonthTapped: nextMonthTapped,
            dateSelected: dateSelected,
            resetTapped: resetTapped,
            viewWillAppear: viewWillAppear
        )
        
        // Output
        let allDiaries = BehaviorRelay<[DiaryModel]>(value: [])
        let filteredDiaries = BehaviorRelay<[DiaryModel]>(value: [])
        let alertMessage = PublishRelay<(String, String)>()
        
        self.output = Output(
            allDiaries: allDiaries,
            filteredDiaries: filteredDiaries,
            alertMessage: alertMessage
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
                
        Observable.merge(
            input.viewWillAppear.asObservable(),
            input.resetTapped.asObservable()
        )
        .subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.observeRealmChanges(output: output)
            self.updateUIState(output: output)
        })
        .disposed(by: disposeBag)
        
        input.dateSelected
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.updateUIState(output: output)
            })
            .disposed(by: disposeBag)
    }
    
    private func observeRealmChanges(output: Output) {
        notificationToken?.invalidate()
        
        do {
            let realm = try Realm()
            let results = realm.objects(DiaryModel.self).sorted(byKeyPath: "date", ascending: false)
            
            notificationToken = results.observe { [weak self] changes in
                guard let self = self else { return }
                
                switch changes {
                case .initial(let data), .update(let data, _, _, _):
                    let validDiaries = Array(data).filter { !$0.isInvalidated }
                    output.allDiaries.accept(validDiaries)
                    self.updateUIState(output: output)
                case .error(let error):
                    print("Realm observe error:", error)
                    output.alertMessage.accept(("오류", "데이터를 불러오지 못했습니다."))
                }
            }
        } catch {
            output.alertMessage.accept(("오류", "데이터베이스 연결 실패: \(error.localizedDescription)"))
        }
    }
    
    private func updateUIState(output: Output) {
        let selectedDate = input.dateSelected.value
        let filtered = output.allDiaries.value.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
        output.filteredDiaries.accept(filtered)
    }
    
    func reloadAllData() {
        self.observeRealmChanges(output: self.output)
        self.input.dateSelected.accept(self.input.dateSelected.value)
    }
}


//MARK: - ViewModelType

extension CalendarViewModel {
    struct Input {
        let previousMonthTapped: PublishRelay<Void>
        let nextMonthTapped: PublishRelay<Void>
        let dateSelected: BehaviorRelay<Date>
        let resetTapped: PublishRelay<Void>
        let viewWillAppear: PublishRelay<Void>
    }
    
    struct Output {
        let allDiaries: BehaviorRelay<[DiaryModel]>
        let filteredDiaries: BehaviorRelay<[DiaryModel]>
        let alertMessage: PublishRelay<(String, String)>
    }
}
